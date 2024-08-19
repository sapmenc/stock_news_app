import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stock_news_app_frontend/Screens/Explore/_components/companies.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:stock_news_app_frontend/utils.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  bool end = false;
  int page = 0;
  TextEditingController _commentController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List? userData = [];
  var companies = [];
  final base_url = '${baseUrl}';
  final client = http.Client();
    bool isFollowing = false;
bool showButton = false;
  void fetchCompanies() async {
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
  }

  Future<bool> fetchUser() async {
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
        setState(() {
      userData = res['data']['following'];
      isFollowing = true;
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

  @override
  void initState() {

        _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && !end) {
print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
print(page);
        fetchCompanies();
      }
    });
    fetchCompanies();
    fetchUser();

    super.initState();
  }

  void filterCompanies()async{
    print(_commentController.text);
    if (_commentController.text == ""){
      setState(() {
        page = 0;
        companies = [];
      });
      fetchCompanies();
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
    print(respose);
    setState(() {
      companies = respose['data'];
      if (respose['data'].length<10){
        end = true;
      }
      else{
        end = false;
      }
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
            page = 0;
            userData = [];
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
            showButton? Container(
              padding: EdgeInsets.only(bottom: 70),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(onPressed: ()async{

                  bool status = await fetchUser();
                  if (userData!.isEmpty || userData ==null ||status == false){
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
