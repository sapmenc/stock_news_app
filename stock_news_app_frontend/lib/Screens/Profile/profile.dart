import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/screen_2.dart';
import 'package:stock_news_app_frontend/utils.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final client = http.Client();
        final base_url = '${baseUrl}';

  TextEditingController _controller = TextEditingController(text: 'Areeb');
  TextEditingController _Emailcontroller = TextEditingController(text: 'mdareeb176@gmail.com');
  TextEditingController _Passwordcontroller = TextEditingController();
  void fetchCompanies(){
    
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("logo"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
      
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(
                child: Center(
                  
                  child: Column(
                    
                    children: [
                      Text("Profile", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      TextFormField(
                controller: _controller,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(71, 255, 255, 255),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Username",
                  
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
                child: ElevatedButton(onPressed: (){}, child: Text("Save", style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),)),
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
              SizedBox(height: 10,),
                                                  TextFormField(
                controller: _Passwordcontroller,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(71, 255, 255, 255),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Password",
                  
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
             SizedBox(height:10),
             Divider(),
             Text("Companies you follow")
             
                    ],
                  ),
                ),
              )),
              Container(
                width: double.infinity,
                child: ElevatedButton(onPressed: ()async{
                  await FirebaseAuth.instance.signOut();
                  SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
                  await sharedPreferences.clear();
   Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const Screen2();
                              },
                            ),
                            (_) => false,
                          );                },
                
                 child: Text("Logout", style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),))
            ],
          )
        ),
      ),
    );
  }
}