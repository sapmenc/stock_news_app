import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/forgot-password.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/screen_2.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? username = null;
  List companies = [];
  final client = http.Client();
  final base_url = '${baseUrl}';

  Uri userUri = Uri.parse(baseUrl + 'user/email');
  final userEmail = FirebaseAuth.instance.currentUser!.email;


  void fetchUser() async {
    final req = jsonEncode({"email": userEmail});
    final response = await client.post(userUri,
        body: req, headers: {'Content-Type': 'Application/json'});
    print(response.body);
    final res = jsonDecode(response.body);
    setState(() {
      username = res['data']['name'];
      companies = res['data']['following'];
    });
    _controller.text = res['data']['name'];
  }

  void updateUser() async{
    try {
      
    Uri userUpdateUrl = Uri.parse(baseUrl + 'user/update');
    final req = jsonEncode({
      "email": _Emailcontroller.text,
      "name": _controller.text
    });
    final response = await client.post(userUpdateUrl, body: req, headers: {
      "Content-Type": "Application/json"
    });
    final res = jsonDecode(response.body);
    print("00000000000000000000000000000000000000000000000000000000");
    print(res);
    if (res['status']){
      Fluttertoast.showToast(msg: "user name updated.");
    }
    else{
      Fluttertoast.showToast(msg: "some error occured. try again later");
    }
    } catch (e) {
      Fluttertoast.showToast(msg: "some error occured. try again later");
    }
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController _Emailcontroller =
      TextEditingController(text: FirebaseAuth.instance.currentUser!.email);
  TextEditingController _Passwordcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/Alpha-logo.png',
            scale: 20,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: RefreshIndicator(
              onRefresh: () async {
                fetchUser();
              },
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _controller,
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(71, 255, 255, 255),
                              filled: true,
                              contentPadding: EdgeInsets.all(10),
                              labelText: "name",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(0, 81, 81,
                                      81), // Change border color for enabled state
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(0, 81, 81,
                                      81), // Change border color for focused state
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  updateUser();
                                },
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              )),
                          TextFormField(
                            controller: _Emailcontroller,
                            readOnly: true,
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(71, 255, 255, 255),
                              filled: true,
                              contentPadding: EdgeInsets.all(10),
                              labelText: "Email",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(0, 81, 81,
                                      81), // Change border color for enabled state
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(0, 81, 81,
                                      81), // Change border color for focused state
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // TextFormField(
                          //   controller: _Passwordcontroller,
                          //   cursorColor: Colors.white,
                          //   decoration: const InputDecoration(
                          //     fillColor: Color.fromARGB(71, 255, 255, 255),
                          //     filled: true,
                          //     contentPadding: EdgeInsets.all(10),
                          //     labelText: "Password",
                          //     enabledBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: Color.fromARGB(0, 81, 81,
                          //             81), // Change border color for enabled state
                          //       ),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: Color.fromARGB(0, 81, 81,
                          //             81), // Change border color for focused state
                          //       ),
                          //     ),
                          //   ),
                          // ),

                          Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));
                                },
                                child: Text(
                                  "Update Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(255, 83, 161, 238),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              )),
                          SizedBox(height: 10),
                          Divider(),
                          Text("Companies you follow"),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: companies.isNotEmpty
                                ? companies.map((e) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CompanyProfile(
                                                      id: e['_id'],
                                                      isFollowing: true,
                                                      name: e['name'],
                                                    )));
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                Color.fromARGB(255, 42, 41, 41),
                                            foregroundImage:
                                                NetworkImage(e['logo']),
                                            radius: 40,
                                            child: Text(e['name'][0]),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              constraints:
                                                  BoxConstraints(maxWidth: 120),
                                              child: Text(
                                                e['name'],
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ))
                                        ],
                                      ),
                                    );
                                  }).toList()
                                : [Container()],
                          )
                        ],
                      ),
                    ),
                  )),
                  Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await GoogleSignIn().signOut();
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          await sharedPreferences.clear();
                          Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const Screen2();
                              },
                            ),
                            (_) => false,
                          );
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ))
                ],
              ),
            )),
      ),
    );
  }
}
