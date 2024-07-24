import 'dart:convert';

import 'package:flutter/material.dart';
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
  var companyPosts = [];
  var companyData = {};
  final base_url = '${baseUrl}';
  final client = http.Client();
  void getpostbyCompanyName() async {
    print("ppppppppppppppppppppppppppppppppppppppppppp");
    print('Widget Id: ${widget.id}');
    Uri companyposturi =
        Uri.parse(baseUrl + 'post/companyName?page=1&limit=25');
    final req = jsonEncode({"companyName": widget.name});
    final response = await client.post(companyposturi,
        body: req, headers: {'Content-Type': 'Application/json'});
    // print(response.body);
    final res = jsonDecode(response.body);
    // print('11111111111111111111111111111111111111111');
    // print(res['data']['company'][0]);
    setState(() {
      companyPosts = res['data']['posts'];
      companyData = res['data']['company'][0];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // fetchCompanyData();
    getpostbyCompanyName();
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
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 60),
            child: Column(
              children: [
                CompanyDetails(isFollowing: widget.isFollowing, id: widget.id),
                ...companyPosts.isNotEmpty
                    ? companyPosts.map((e) {
                        print(e);
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
                        // Replace with your actual widget
                      }).toList()
                    : [Container()] // Wrap the single widget in a list
              ],
            )));
  }
}
