import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final client = http.Client();
  List postData = [];

  void fetchPosts() async {
    // print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    Uri fetchposts = Uri.parse(baseUrl + 'post/company?page=1&limit=25');
    // print(FirebaseAuth.instance.currentUser!.email);
    final req = jsonEncode(
        {"userEmail": FirebaseAuth.instance.currentUser!.email as String});
    final response = await client.post(fetchposts,
        body: req, headers: {'Content-Type': 'Application/json'});
    print("mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
    print(response.body);
    final res = jsonDecode(response.body);
    setState(() {
      postData = res['data'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/Alpha-logo.png',
          scale: 7,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 60),
          child: Column(
              mainAxisSize: MainAxisSize
                  .min, // Adjusts the Column to the minimum space required
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: postData != null && postData.isNotEmpty
                  ? postData.map((e) {
                      // print(e);
                      return Posts(
                          id: e['_id'],
                          logo: e['companyDetails']['logo'],
                          title: e['title'],
                          description: e['content'],
                          name: e['companyName'],
                          numLikes: e['numLikes'],
                          numDislikes: e['numDislikes'],
                          numComments: e['numComments'],
                          likes: e['likes'],
                          dislikes: e['dislikes'],
                          pdf: e['pdf'],
                          companyId: e['companyDetails']['_id'],
                          createdAt: e['date']);
                    }).toList()
                  : [
                      Container()
                    ] // Provide an empty list or a default widget when `postData` is null or empty
              )),
    );
  }
}
