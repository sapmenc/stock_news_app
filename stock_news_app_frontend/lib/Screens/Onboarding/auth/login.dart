import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/Interests/interested_companies.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final client = http.Client();
  final base_url = "https://stock-market-news-backend.vercel.app/";
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _submitForm() async{
    // await Firebase.initializeApp();
    if (_formKey.currentState!.validate()) {
      // Process the login
      print(_emailController.value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
        try{
          Uri uri = Uri.parse(base_url);
          final response = await client.get(uri);
          print("#######################################################");
          print(response.body);
          if (_emailController.text == "mdareeb176@gmail.com" && _passwordController.text == "test01@123"){
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.setString('email', 'mdareeb176@gmail.com');
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InterestedCompanies()));

            // if(true){
            //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InterestedCompanies()));
            // }
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));

          }
          else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid credentials")));
          }

          // UserCredential usercreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.value as String, password: _passwordController.value as String);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
        } catch(e){
          print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              
              children: [
                SizedBox(height: 20,),
                TextFormField(
                  controller: _emailController,
                      cursorColor: Colors.white,
                      
                    decoration: const InputDecoration(
                                      fillColor: Color.fromARGB(15, 255, 255, 255),
                  filled: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(0, 81, 81, 81), // Change border color for enabled state
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(0, 81, 81, 81), // Change border color for focused state
                        ),
                      ),
                    ),
                  validator: _validateEmail,
                ),
                SizedBox(height: 30,),
                TextFormField(
                  controller: _passwordController,
                                      cursorColor: Colors.white,
            
                  decoration: InputDecoration(
                                      fillColor: Color.fromARGB(15, 255, 255, 255),
                  filled: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(0, 81, 81, 81), // Change border color for enabled state
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(0, 81, 81, 81), // Change border color for focused state
                        ),
                      ),                  suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  validator: _validatePassword,
                ),
                              SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A6A6A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text('Login', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(height: 20),
                // Divider(),
                Text("Or", textAlign: TextAlign.center,),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Handle Google login
                      },
                      child: FaIcon(FontAwesomeIcons.google, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: const Color.fromARGB(91, 255, 255, 255), width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        padding: EdgeInsets.all(18),
                        backgroundColor: Colors.transparent,
                        
                      ),
                    ),
                   
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Handle Google login
                      },
                      child: FaIcon(FontAwesomeIcons.microsoft, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(color: const Color.fromARGB(91, 255, 255, 255), width: 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                        padding: EdgeInsets.all(18),
                        backgroundColor: Colors.transparent,
                        
                      ),
                    ),
                   
                  ],
                ),
              ],
            ),
          ),
        ),
    );
  }
}
