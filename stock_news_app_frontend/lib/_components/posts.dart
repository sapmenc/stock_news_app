import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/CommentsScreen/comments_screen.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stock_news_app_frontend/_components/Comments.dart';
import 'package:http/http.dart' as http;
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
  const Posts({
    super.key,
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
  });

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  final client = http.Client();
  bool isExpanded = false;
  int numLikes = 0;
  int numComments = 0;
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
    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
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

    void handlePdf() async {
      const Pdfurl =
          "https://nsearchives.nseindia.com/corporate/xbrl/NESCO_01012024014219_CIM_15614_1005823_01012024014219_WEB.xml";
      final Uri url = Uri.parse(Pdfurl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
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
        'handleClick': handlePdf
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
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(widget.logo),
                    ),
                    SizedBox(width: 10),
                    Container(
                      constraints: BoxConstraints(maxWidth: 200),
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
              const Text(
                "10m ago",
                style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 12),
              ),
            ],
          ),
          Container(
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
