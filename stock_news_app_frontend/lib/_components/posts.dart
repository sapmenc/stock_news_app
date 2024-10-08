import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/CommentsScreen/comments_screen.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stock_news_app_frontend/_components/Comments.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/_components/PDFScreen.dart';
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class Posts extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String name;
  final int numLikes;
  final int numDislikes;
  final int numComments;
  final List likes;
  final List dislikes;
  final String pdf;
  final String logo;
  final String companyId;
  final String createdAt;
  const Posts(
      {super.key,
      required this.id,
      required this.logo,
      required this.title,
      required this.description,
      required this.name,
      required this.numLikes,
      required this.numDislikes,
      required this.numComments,
      required this.likes,
      required this.dislikes,
      required this.pdf,
      required this.companyId,
      required this.createdAt});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  String remotePDFpath = "";
  final client = http.Client();
  bool isExpanded = false;
  int numLikes = 0;
  int numComments = 0;
  String pdf = "";
  int numDislikes = 0;
  bool isLiked = false;
  bool isDisliked = false;
  String? userId = null;
  bool showReadMore = false;
  void setVariables() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final user_Id = sharedPreferences.getString('userId');

    // print("11111111111111111111111111111111111111111111111111111111");
    // print(userId);
    setState(() {
      numLikes = widget.numLikes;
      userId = user_Id;
      numDislikes = widget.numDislikes;
      numComments = widget.numComments;
      pdf = widget.pdf;
      if (widget.likes.contains(userId)) {
        isLiked = true;
      }
      if (widget.dislikes.contains(userId)) {
        isDisliked = true;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTextHeight();
    });
  }

  void _checkTextHeight() {
    // print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    final textSpan = TextSpan(
      text: widget.description,
      style: const TextStyle(fontSize: 13),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width);

    if (textPainter.didExceedMaxLines) {
      setState(() {
        showReadMore = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setVariables();
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    // print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = widget.pdf;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      // print("Download files");
      // print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    void handleLike() async {
      setState(() {
        if (isLiked == true) {
          isLiked = false;
          numLikes -= 1;
        } else {
          isLiked = true;
          numLikes += 1;
          if (isDisliked) {
            numDislikes -= 1;
            isDisliked = false;
          }
        }
      });
      Uri likeUri = Uri.parse(baseUrl + 'post/like');
      final req = jsonEncode({"userId": userId, "postId": widget.id});
      // print(req);
      final response = await client.post(likeUri,
          body: req, headers: {'Content-Type': 'application/json'});
      final res = jsonDecode(response.body);
      // print(res);

      if (res['status'] == false) {
        setState(() {
          if (isLiked == false) {
            isLiked = true;
            numLikes += 1;
          } else {
            isLiked = false;
            numLikes -= 1;
          }
        });
      } else {
        analytics.logEvent(name: "React_bull", parameters: {
          "postId": widget.id,
        });
      }
    }

    void handleDislike() async {
      setState(() {
        if (isDisliked == true) {
          isDisliked = false;
          numDislikes -= 1;
        } else {
          isDisliked = true;
          numDislikes += 1;
          if (isLiked) {
            isLiked = false;
            numLikes -= 1;
          }
        }
      });
      Uri likeUri = Uri.parse(baseUrl + 'post/dislike');
      final req = jsonEncode({"userId": userId, "postId": widget.id});
      final response = await client.post(likeUri,
          body: req, headers: {'Content-Type': 'application/json'});
      final res = jsonDecode(response.body);
      // print(res);
      if (res['status'] == false) {
        setState(() {
          if (isDisliked == false) {
            isDisliked = true;
            numDislikes += 1;
          } else {
            isDisliked = false;
            numDislikes -= 1;
          }
        });
      } else {
        analytics.logEvent(name: "React_bear", parameters: {
          "postId": widget.id,
        });
      }
    }

    Future? handleCommentSectionOpen() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CommentsScreen(
                    postId: widget.id,
                  )));
    }

    Future? handlePdf(String pdf) async {
      final Uri url = Uri.parse(pdf);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.inAppWebView);
      } else {
        throw 'Could not launch $url';
      }
    }

    Future? createHandleClick() async {
      if (!widget.pdf.endsWith("pdf")) {
        
          await handlePdf(pdf);
        
      } else {
        if (remotePDFpath.isNotEmpty) {
          await analytics.logEvent(name: "Article_pdf", parameters: {
            "timestamp": DateTime.now().toIso8601String(),
            "postId": widget.id
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(path: remotePDFpath),
            ),
          );
        }
      }
    }

    var postActions = [
      {
        'icon': 'assets/Bullish.svg',
        'label': 'Bullish',
        'isActive': isLiked,
        'activeColor': Color.fromARGB(255, 94, 244, 71),
        'num': numLikes,
        'handleClick': handleLike
      },
      {
        'icon': 'assets/Bearish.svg',
        'label': 'Bearish',
        'isActive': isDisliked,
        'activeColor': Color.fromRGBO(235, 26, 26, 1),
        'num': numDislikes,
        'handleClick': handleDislike
      },
      {
        'icon': 'assets/Comment.svg',
        'label': 'Comment',
        'isActive': false,
        'activeColor': Color(0xFFFFFFFF),
        'num': numComments,
        'handleClick': handleCommentSectionOpen
      },
      {
        'icon': 'assets/Pdf.svg',
        'label': 'Pdf',
        'isActive': false,
        'activeColor': Color(0xFFFFFFFF),
        'num': null,
        'handleClick': createHandleClick,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0x99515151)),
        borderRadius: BorderRadius.circular(20),
      ),
      width: screenWidth,
      constraints: const BoxConstraints(
          minHeight:
              double.minPositive // Minimum height of 30% of screen height
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyProfile(
                        id: widget.companyId,
                        name: widget.name,
                        isFollowing: true,
                      ),
                    ),
                  );
                },
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.5, minWidth: screenWidth * 0.3),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(widget.logo),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                            color: Color(0xFF79ABFF),
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                child: Text(
                  '${widget.createdAt.substring(0, 10).split('-').reversed.join('-')} | ${widget.createdAt.substring(11, 19)}',
                  style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 12),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentsScreen(postId: widget.id)));
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFF4285F4))),
              ),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Color(0xFF4285F4),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.description,
                      maxLines: isExpanded ? null : 3,
                      style: const TextStyle(fontSize: 13),
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                    if (showReadMore)
                      Text(
                        isExpanded ? "Read less" : "Read more",
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromARGB(255, 42, 119, 245)),
                      )
                  ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: postActions.map((action) {
              final String icon = action['icon'] as String;
              final String label = action['label'] as String;
              final int? num = action['num'] as int?;
              final VoidCallback handleClick =
                  action['handleClick'] as VoidCallback;
              final bool isActive = action['isActive'] as bool;
              final Color activeColor = action['activeColor'] as Color;

              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: handleClick,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SvgPicture.asset(
                          icon,
                          semanticsLabel: label,
                          colorFilter: ColorFilter.mode(
                              isActive ? activeColor : Colors.white,
                              BlendMode.srcIn),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '$label',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    if (num != null)
                      Text(
                        '$num',
                        style: const TextStyle(color: Colors.white),
                      ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
