import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stock_news_app_frontend/Screens/Explore/_components/companies.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool end = false;
  int page = 0;
  bool isFetching = true;
  TextEditingController _commentController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List? followingCompanies = [];
  var companies = [];
  final base_url = '${baseUrl}';
  final client = http.Client();
    bool isFollowing = false;
bool showButton = false;
  void fetchCompanies() async {
    DateTime start = DateTime.now();
    Uri companiesUrl = Uri.parse(baseUrl + 'company/page?page=${page+1}&limit=25');
    final response = await client.get(companiesUrl);
    final res = jsonDecode(response.body);
    final data = res['data'];
    final companiesList = data['companies'];
    // if (companiesList.length < 20){
    //   setState(() {
    //     end = true;
    //   });
    // };
    setState(() {
      if (companiesList.length<25){
        end = true;
      }
      else{

      end = false;
      }
      companies = [...companies, ...companiesList];
      page+=1;
    });
        DateTime endTime = DateTime.now();
    final duration = endTime.difference(start).inMilliseconds;    await analytics.logEvent(name: "explore_load_time", parameters: {
      "time": duration
    });
  }

  Future<bool> fetchUser() async {
    setState(() {
      isFetching = true;
    });
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
    if (res['data']['following'].length>0){
      print("uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu");
      print(res['data']['following']);
        setState(() {
      followingCompanies = res['data']['following'];
      isFollowing = true;
      isFetching = false;
    });
    return true;
    }
    else{
      setState(() {
        isFollowing = false;
        showButton = true;
      });
      return false;
    }

  }

  void logExplore() async{
    await analytics.logEvent(name: "company_listing", parameters: {
      "timestamp": DateTime.now().toIso8601String()
    });
  }
  @override
  void initState() {
    logExplore();


        _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !end) {
// print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
// print(page);
        fetchCompanies();
      }
    });
    fetchCompanies();
    fetchUser();

    super.initState();
  }

      void logSearches()async{
      await analytics.logEvent(name: "Search", parameters: {
        "timestamp": DateTime.now().toIso8601String()
      });
    }

  void filterCompanies()async{
    DateTime start = DateTime.now();
    setState(() {
      isFetching = true;
    });
    // print(_commentController.text);
    if (_commentController.text == ""){
      setState(() {
        page = 0;
        companies = [];
      });
      fetchCompanies();
      fetchUser();
      
      return;
    }
    Uri filterCompanies = Uri.parse(base_url+'company/search');
    final req = jsonEncode({
      "query": _commentController.text
    });
    final res = await client.post(filterCompanies, body: req, headers: {
      "Content-Type": "Application/json"
    });
    final respose = jsonDecode(res.body);
    // print(respose);
    setState(() {
      companies = respose['data'];
      if (respose['data'].length<25){
        end = true;
      }
      else{
        end = false;
      }
      isFetching = false;
    });
            DateTime endTime = DateTime.now();
    final duration = endTime.difference(start).inMilliseconds;    await analytics.logEvent(name: "search_response_time", parameters: {
      "time": duration
    });
    logSearches();

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
            page = 0;
            followingCompanies = [];
            companies = [];
          });
          fetchCompanies();
          fetchUser();
        },
        child: Stack(
          
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Column(children: [           
                            Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue, // Change border color here
                            ),
                          ),
                          hintText: "Search Company",
                          hintStyle: TextStyle(
                            color: Color(0xFF515151), // Change hint text color here
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(
                                  0xFF515151), // Change border color for enabled state
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(
                                  0xFF515151), // Change border color for focused state
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(150, 158, 158, 158)),
                            borderRadius: BorderRadius.circular(10)),
                        child: IconButton(
                            onPressed: () {
                              filterCompanies();
                              // createComment();
                            },
                            icon: Icon(Icons.search)))
                  ],
                ),
              
            
            
                // SizedBox(
                //   height: 20,
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 60),
                    child: !isFetching?
                     Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [...companies.map((e) {


                          bool following = false;
                          setState(() {
                            following = followingCompanies!.any((c)=>c["_id"]==e["_id"]);
                          });
                       
                          return Companies(
                              id: e['_id'],
                              name: e['name'],
                              profile: e['logo'],
                              numArticles: e['postCount'],
                              isFollowing: following);
                        }).toList(),
                        !end?CircularProgressIndicator():Container()
                        
                        ]):Container(height: MediaQuery.of(context).size.height*0.7,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        ),
                  ),
                )
              ]),
            ),
            showButton? Container(
              padding: EdgeInsets.only(bottom: 70),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(onPressed: ()async{

                  bool status = await fetchUser();
                  if (followingCompanies!.isEmpty || followingCompanies ==null ||status == false){
                    Fluttertoast.showToast(msg: "Follow some companies to proceed");
                  }
                  else{
                      setState(() {
                        showButton = false;
                      });
                                      Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const MainScreen(tabIndex: 1,);
                              },
                            ),
                            (_) => false,
                          );
                  }
                }, child: Text("proceed"), style: ElevatedButton.styleFrom( backgroundColor: Colors.green,),)),
            ):Container()
          ],
        ),
      ),
    );
  }
}
