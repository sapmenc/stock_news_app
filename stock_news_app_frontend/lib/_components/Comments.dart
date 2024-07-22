import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/_components/Comment.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

class Comments extends StatefulWidget {
  final id;
  const Comments({super.key, required this.id});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final client = http.Client();
  final _commentController = TextEditingController();
  List? commentData = [];
  var postData = {};
  void fetchComments() async {
    Uri fetchcomments =
        Uri.parse(baseUrl + 'post/comments/page?page=1&limit=25');
    final req = jsonEncode({"postId": widget.id});

    final response = await client.post(fetchcomments,
        body: req, headers: {"Content-Type": "application/json"});
    final res = jsonDecode(response.body);
    print("#############################");
    print(res);

    if (res['status']) {
      setState(() {
        commentData = res['data']['comments'];
        postData = res['data'];
      });
    }
  }

  void createComment() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString("userId");
// print("111111111111111111111111111111111111");
// print(_commentController.text);
    Uri commentUri = Uri.parse(baseUrl + 'post/comment');
    final req = jsonEncode({
      "postId": widget.id,
      "comment": _commentController.text,
      "userId": userId
    });
    final response = await client.post(commentUri,
        body: req, headers: {'Content-Type': 'Application/json'});
// print(response.body);
    final res = jsonDecode(response.body);
    _commentController.clear();
    fetchComments();
  }

  @override
  void initState() {
    fetchComments();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      child: Column(
        children: [
          postData.isNotEmpty
              ? Posts(
                  id: postData['_id'],
                  logo: postData['companyData'][0]['logo'],
                  title: postData['title'],
                  description: postData['companyData'][0]['description'],
                  name: postData['companyName'],
                  numLikes: postData['numLikes'],
                  numDislikes: postData['numDislikes'],
                  numComments: postData['numComments'],
                  likes: postData['likes'],
                  dislikes: postData['dislikes'],
                  pdf: postData['pdf'],
                  companyId: postData['companyData'][0]['_id'],
                )
              : Container(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue, // Change border color here
                      ),
                    ),
                    hintText: "Add a comment",
                    hintStyle: TextStyle(
                      color: Color(0xFF515151), // Change hint text color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFF515151), // Change border color for enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(
                            0xFF515151), // Change border color for focused state
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(150, 158, 158, 158)),
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                      onPressed: () {
                        createComment();
                      },
                      icon: SvgPicture.asset('assets/CommentButton.svg')))
            ],
          ),
          SizedBox(height: 10), // Add some space between the input and comments
          Column(
            mainAxisSize: MainAxisSize.max,
            children: commentData!.isNotEmpty
                ? commentData!.map((e) {
                    // print("1111111111111111111111111");
                    // print(e['comment']);
                    return Container(
                        // height: double.infinity,
                        child: Comment(
                      name: e['userId']['name'],
                      comment: e['comment'],
                    )); // Replace with your actual widget
                  }).toList()
                : [
                    Text("No comments yet!")
                  ], // Wrap the single widget in a list
          )
        ],
      ),
    );
  }
}
