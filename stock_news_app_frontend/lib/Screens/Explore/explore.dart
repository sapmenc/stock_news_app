
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';
import 'package:stock_news_app_frontend/Screens/Explore/_components/companies.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List? userData = null;
  var companies = [];
      // final baseUrl = "https://stock-market-news-backend.vercel.app/api";
      final base_url = '${baseUrl}';
    final client = http.Client();
    // Uri userUrl = Uri.parse(baseUrl+'/user/email');

    void fetchCompanies()async {
    Uri companiesUrl = Uri.parse(baseUrl+'company/page?page=1&limit=25');
    final response = await client.get(companiesUrl);
    print("333333333333333333333333333333333333333333333333333333");
    // print(response.body);
    final res = jsonDecode(response.body);
    final data = res['data'];
    final companiesList = data['companies'];
    print(companiesList);
    setState(() {
      companies=companiesList;
    });
  }
      void fetchUser()async{
        final email = FirebaseAuth.instance.currentUser!.email;
      Uri userUri = Uri.parse(base_url+'user/email');
      final req = jsonEncode({"email":email});
                  final response = await client.post(
                    userUri,
                    body: req,
                    headers: {
                      'Content-Type': 'application/json', // Add this header
                    },
                  );
                  final res = jsonDecode(response.body);
                  print(res['data']['following']);
                  setState(() {
                    userData=res['data']['following'];
                  });
                  
    }

  @override
  void initState() {
    // TODO: implement initState
    fetchCompanies();
    fetchUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                appBar: AppBar(
            title: Text("logo"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            const TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
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
            SizedBox(height: 20,),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: companies.map((e) { 
                    print(e);
                    var isFollowing = true;
    var matchingCompany = userData!.where((following) => following['_id'] == e['_id']).toList();
  if (matchingCompany.isEmpty){
    print("it is not in the following list");
    isFollowing = false;
  }
                    return Companies(id:e['_id'], name: e['name'], profile: e['logo'], numArticles: e['post'], isFollowing: isFollowing);
                    
                    }).toList()
                ),
              ),
            )
          ]),
        ),
      
    );
  }
}
