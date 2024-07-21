import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final name;
  final comment;
  const Comment({super.key, required this.comment, required this.name});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.sizeOf(context).width;

    return       Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          top: 10,
        ),
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: const Color(0x99515151)),
            borderRadius: BorderRadius.circular(10),
            color: Colors.black),
        width: screenWidth,
        constraints: const BoxConstraints(
            minHeight:
                double.minPositive // Minimum height of 30% of screen height
            ),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                widget.name,
                style: const TextStyle(
                  color: Color(0xFF79ABFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("2 days ago",
                  style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 12))
            ]),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.comment,
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.left,
            )
          ],
        ),
      );
  }
}