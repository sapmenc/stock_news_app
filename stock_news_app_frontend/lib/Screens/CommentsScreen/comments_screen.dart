import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/_components/Comments.dart';

class CommentsScreen extends StatelessWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text("logo"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: BackButton(onPressed: (){
              Navigator.pop(context);
            }),
          ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: const BoxDecoration(
            
            color: Color(0xFF111111),
            // borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
          ),
          child: Comments()
        ),
      ),
    );
  }
}