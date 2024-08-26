import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/_components/company_details.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

class CompanyProfile extends StatefulWidget {
  final id;
  final isFollowing;
  final name;
  const CompanyProfile(
      {super.key,
      required this.id,
      required this.isFollowing,
      required this.name});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  ScrollController _scrollController = ScrollController();
  bool end = false;
  int page = 1;
  var companyPosts = [];
  var companyData = {};
  final base_url = '${baseUrl}';
  final client = http.Client();
  void getpostbyCompanyName() async {
    // print('Widget Id: ${widget.id}');
    Uri companyposturi =
        Uri.parse(baseUrl + 'post/companyName?page=${page}&limit=25');
    final req = jsonEncode({"companyName": widget.name});
    final response = await client.post(companyposturi,
        body: req, headers: {'Content-Type': 'Application/json'});
    final res = jsonDecode(response.body);
    if (res['data']['posts'].length ==0){
      setState(() {
        end = true;
      });
      return;
    }
    setState(() {
      companyPosts = [...companyPosts, ...res['data']['posts']];
      companyData = res['data']['company'][0];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // fetchCompanyData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
            setState(() {
              page+=1;
            });
        getpostbyCompanyName();
      }
    });
    getpostbyCompanyName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: RefreshIndicator(
          onRefresh: ()async{
            setState(() {
              page = 1;
              companyPosts = [];
            });
            getpostbyCompanyName();
          },
          child: SingleChildScrollView(
            controller: _scrollController,
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 60),
              child: Column(
                children: [
                  CompanyDetails(isFollowing: widget.isFollowing, id: widget.id),
                  ...companyPosts.isNotEmpty
                      ? companyPosts.map((e) {
                          // print(e);
                          return Posts(
                              id: e['_id'],
                              title: e['title'],
                              description: e['content'],
                              name: e['companyName'],
                              numLikes: e['numLikes'],
                              numDislikes: e['numDislikes'],
                              numComments: e['numComments'],
                              likes: e['likes'],
                              dislikes: e['dislikes'],
                              pdf: e['pdf'],
                              logo: companyData['logo'],
                              companyId: companyData['_id'],
                            createdAt: e['date']);
                        }).toList()

                      : [Container()],
                      !end?CircularProgressIndicator():Container()

                ],
              )),
        ));
  }
}
