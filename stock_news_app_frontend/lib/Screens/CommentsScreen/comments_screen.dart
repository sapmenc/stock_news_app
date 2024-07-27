import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/_components/Comments.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/Alpha-logo.png',
            scale: 20,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: const BoxDecoration(
              color: Color(0xFF111111),
              // borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
            ),
            child: Comments(id: widget.postId)),
      ),
    );
  }
}
