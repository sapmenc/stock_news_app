import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/HomeScreens/_components/categories/All.dart';
import 'package:stock_news_app_frontend/Screens/HomeScreens/_components/categories/BusinessUpdates.dart';
import 'package:stock_news_app_frontend/Screens/HomeScreens/_components/categories/FInancialUpdates.dart';
import 'package:stock_news_app_frontend/Screens/HomeScreens/_components/categories/General.dart';
import 'package:stock_news_app_frontend/Screens/HomeScreens/_components/categories/Other.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    ScrollController _scrollController = ScrollController();
    var page = 1;
  List postData = [];
    final client = http.Client();
  final base_url = '${baseUrl}';
  bool userFollowing = true;

  Uri userUri = Uri.parse(baseUrl + 'user/email');
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  void fetchUser() async {
    final req = jsonEncode({"email": userEmail});
    final response = await client.post(userUri,
        body: req, headers: {'Content-Type': 'Application/json'});
    final res = jsonDecode(response.body);
    setState(() {
      if (res['data']['following'].length == 0){
        userFollowing = false;
      }
      else{
        userFollowing = true;
      }
    });
  }


  void fetchPosts() async {
    Uri fetchposts = Uri.parse(baseUrl + 'post/company?page=${page}&limit=25');
    final req = jsonEncode(
        {"userEmail": FirebaseAuth.instance.currentUser!.email as String});
    final response = await client.post(fetchposts,
        body: req, headers: {'Content-Type': 'Application/json'});
    final res = jsonDecode(response.body);

    setState(() {
      postData = [...postData, ...res['data']];
    });

  }

  void logHome() async{
 await analytics.logEvent(name: "home", parameters: {
      "timestamp": DateTime.now().toIso8601String()
    });
  }

  @override
  void initState() {
   logHome();
    // TODO: implement initState
    _scrollController.addListener(() async{
      await analytics.logEvent(name: "Scroll", parameters: {
        "timestamp": DateTime.now().toIso8601String()
      });
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
            setState(() {
              page+=1;
            });
        fetchPosts();
      }
    });
    fetchPosts();
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            tabs: [
            Text("All", style: TextStyle(fontSize: 18),),
            Text("Financial updates", style: TextStyle(fontSize: 18),),
            Text("Business updates", style: TextStyle(fontSize: 18),),
            Text("General", style: TextStyle(fontSize: 18),),
            Text("Other", style: TextStyle(fontSize: 18),)
          ]),
          title: Image.asset(
            'assets/alpha-logo-3.png',
            scale: 15,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: userFollowing? const TabBarView(children: 
        
        [
          All(),
          Financialupdates(),
          BusinessUpdates(),
          General(),
          Other()
        ],):  
        
        TabBarView(children: 
        
        [
          RefreshIndicator(
        onRefresh: ()async{
          fetchUser();
          fetchPosts();

        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height *0.8, // Full screen height
                child: Center(
                  child: Text(
                    "Follow more companies to see related news here.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          RefreshIndicator(
        onRefresh: ()async{
          fetchUser();
          fetchPosts();

        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height *0.8, // Full screen height
                child: Center(
                  child: Text(
                    "Follow more companies to see related news here.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          RefreshIndicator(
        onRefresh: ()async{
          fetchUser();
          fetchPosts();

        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height *0.8, // Full screen height
                child: Center(
                  child: Text(
                    "Follow more companies to see related news here.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          RefreshIndicator(
        onRefresh: ()async{
          fetchUser();
          fetchPosts();

        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height *0.8, // Full screen height
                child: Center(
                  child: Text(
                    "Follow more companies to see related news here.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
          RefreshIndicator(
        onRefresh: ()async{
          fetchUser();
          fetchPosts();

        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height *0.8, // Full screen height
                child: Center(
                  child: Text(
                    "Follow more companies to see related news here.",
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
         

        ],)
        
      ),
    );
  }
}
