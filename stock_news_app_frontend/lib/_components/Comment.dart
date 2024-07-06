import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  const Comment({super.key});

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
        child: const Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                "User Name",
                style: TextStyle(
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
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              style: TextStyle(fontSize: 13),
            )
          ],
        ),
      );
  }
}