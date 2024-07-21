import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stock_news_app_frontend/_components/Comment.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;
class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
    final client = http.Client();
  List? commentData = null;
  void fetchComments()async{
    Uri fetchcomments = Uri.parse(baseUrl+'post/comments/page?page=1&limit=25');
    final req = jsonEncode({
      "postId": "669d1b2cb8611a0f3fb1b05a"
    });
    final response = await client.post(fetchcomments, body: req, headers: {
"Content-Type": "application/json"   
});
  final res = jsonDecode(response.body);
  print(res['data']['comments']);
  if (res['status']){
    setState(() {
      commentData = res['data']['comments'];
    });
  }

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
          Row(
            children: [
              const Expanded(
                child: TextField(
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
                        color: Color(0xFF515151), // Change border color for enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF515151), // Change border color for focused state
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(150, 158, 158, 158)),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/CommentButton.svg')))
            ],
          ),
          SizedBox(height: 10), // Add some space between the input and comments
          Comment(),
          Comment(),
          Comment(),
          Comment(),
          Comment(),
          Comment(),
        ],
      ),
    );
  }
}
