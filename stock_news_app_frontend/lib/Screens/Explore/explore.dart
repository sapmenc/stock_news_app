import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stock_news_app_frontend/Screens/Explore/_components/companies.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool end = false;
  int page = 1;
  TextEditingController _commentController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List? userData = null;
  var companies = [];
  final base_url = '${baseUrl}';
  final client = http.Client();

  void fetchCompanies() async {
    Uri companiesUrl = Uri.parse(baseUrl + 'company/page?page=${page}&limit=25');
    final response = await client.get(companiesUrl);
    final res = jsonDecode(response.body);
    final data = res['data'];
    final companiesList = data['companies'];
    if (companiesList.length == 0){
      setState(() {
        end = true;
      });
      return;
    }
    setState(() {
      companies = [...companies, ...companiesList];
    });
  }

  void fetchUser() async {
    final email = FirebaseAuth.instance.currentUser!.email;
    Uri userUri = Uri.parse(base_url + 'user/email');
    final req = jsonEncode({"email": email});
    final response = await client.post(
      userUri,
      body: req,
      headers: {
        'Content-Type': 'application/json', // Add this header
      },
    );
    final res = jsonDecode(response.body);

    setState(() {
      userData = res['data']['following'];
    });
  }

  @override
  void initState() {

        _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !end) {
            setState(() {
              page+=1;
            });
        fetchCompanies();
      }
    });
    fetchCompanies();
    fetchUser();

    _commentController.addListener(
      filterCompanies
    );
    super.initState();
  }

  void filterCompanies()async{
    Uri filterCompanies = Uri.parse(base_url+'company/search');
    final req = jsonEncode({
      "query": _commentController.text
    });
    final res = await client.post(filterCompanies, body: req, headers: {
      "Content-Type": "Application/json"
    });
    final respose = jsonDecode(res.body);
    print("111111111111111111111111111111111111111111111111111111111");
    print(respose);
    setState(() {
      companies = respose['data'];
    });

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
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          setState(() {
            page = 1;
            userData = [];
            companies = [];
          });
          fetchCompanies();
          fetchUser();
        },
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
             TextField(
              controller: _commentController,
              
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                fillColor: Color.fromARGB(102, 255, 255, 255),
                filled: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Change border color here
                  ),
                ),
                hintText: "Search company",
                suffixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  color: Color.fromARGB(
                      255, 255, 255, 255), // Change hint text color here
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(
                          0xFF515151), // Change border color for enabled state
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(
                          0xFF515151), // Change border color for focused state
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 60),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [...companies.map((e) {
                      // print(e);
                      var isFollowing = true;
                      var matchingCompany = userData!
                          .where((following) => following['_id'] == e['_id'])
                          .toList();
                      if (matchingCompany.isEmpty) {
                        print("it is not in the following list");
                        isFollowing = false;
                      }
                      return Companies(
                          id: e['_id'],
                          name: e['name'],
                          profile: e['logo'],
                          numArticles: e['postCount'],
                          isFollowing: isFollowing);
                    }).toList(),
                    !end?CircularProgressIndicator():Container()
                    
                    ]),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
