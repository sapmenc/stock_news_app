import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/_components/Comment.dart';

class Comments extends StatelessWidget {
  // final CommentData;
  const Comments({
    super.key,
    // required this.CommentData
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return const SingleChildScrollView(
      child: Column(children: [
         TextField(
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
       
        Comment(),
        Comment(),
        Comment(),
        Comment(),
        Comment(),
        Comment(),
      
        // Container(
        //   padding: const EdgeInsets.all(10),
        //   margin: const EdgeInsets.symmetric(
        //     vertical: 15,
        //   ),
        //   decoration: BoxDecoration(
        //       border: Border.all(width: 1, color: const Color(0x99515151)),
        //       borderRadius: BorderRadius.circular(10),
        //       color: Colors.black),
        //   width: screenWidth,
        //   constraints: const BoxConstraints(
        //       minHeight:
        //           double.minPositive // Minimum height of 30% of screen height
        //       ),
        //   child: const Column(
        //     children: [
        //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //         Text(
        //           "User Name",
        //           style: TextStyle(
        //             color: Color(0xFF79ABFF),
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         Text("2 days ago",
        //             style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 12))
        //       ]),
        //       SizedBox(
        //         height: 5,
        //       ),
        //       Text(
        //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        //         style: TextStyle(fontSize: 13),
        //       )
        //     ],
        //   ),
        // ),
         
      ]),
    );
  }
}
