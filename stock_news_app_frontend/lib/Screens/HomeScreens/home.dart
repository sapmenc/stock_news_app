import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
      body:  SingleChildScrollView(
        padding: EdgeInsets.only(top: 40, left: 10, right: 10),
        child: Column(

            mainAxisSize: MainAxisSize.min, // Adjusts the Column to the minimum space required
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(child: Posts()),
            Center(child: Posts()),
            Center(child: Posts()),
            Center(child: Posts()),
            Center(child: Posts()),
            Center(child: Posts()),
          ],
        ),
      ),
    );
  }
}