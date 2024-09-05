import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';
class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
    ScrollController _scrollController = ScrollController();
    var page = 1;
    bool isFetching = true;
  final client = http.Client();
  List postData = [];
  bool end = false;

  void fetchPosts() async {
    DateTime start = DateTime.now();
    Uri fetchposts = Uri.parse(baseUrl + 'post/company?page=${page}&limit=25');
    final req = jsonEncode(
        {"userEmail": FirebaseAuth.instance.currentUser!.email as String});
    final response = await client.post(fetchposts,
        body: req, headers: {'Content-Type': 'Application/json'});
    final res = jsonDecode(response.body);
    if (res['data'] == null || res['data'].length<25){
      setState(() {
        end = true;
      });
    }
    setState(() {
      postData = [...postData, ...res['data']];
      isFetching = false;
    });
    DateTime endTime = DateTime.now();
    final duration = endTime.difference(start).inMilliseconds;    await analytics.logEvent(name: "home_load_time_all", parameters: {
      "time": duration
    });

  }

  void logCategory()async{
    await analytics.logEvent(name: "Category", parameters: {
      "category_name": "All",
      "timsestamp": DateTime.now().toIso8601String(),
    });
  }

  @override
  void initState() {
    logCategory();
    // TODO: implement initState
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
            setState(() {
              page+=1;
            });
        fetchPosts();
      }
    });
    fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return      RefreshIndicator(
        onRefresh: ()async{
          setState(() {
            postData = [];
            page = 1;
            isFetching = true;
          });
          fetchPosts();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 60),
            child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Adjusts the Column to the minimum space required
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 ...postData.map((e) {
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
                      }).toList(),
                      Container(
                        height:isFetching? MediaQuery.of(context).size.height*0.8:50,

                        alignment: Alignment.center,
                        child: !end? CircularProgressIndicator():Container(),
                      )
                ]
                    // Provide an empty list or a default widget when `postData` is null or empty
                )),
      );
  }
}