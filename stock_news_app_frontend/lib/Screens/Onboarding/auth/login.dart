import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/Interests/interested_companies.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/forgot-password.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/google-sign-in.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/main.dart';
import '../../../utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginForm extends StatefulWidget {
    final Function(String) updateAuthState;
  const LoginForm({super.key, required this.updateAuthState});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final client = http.Client();
  final base_url = '$baseUrl';
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

  Future signInWithGoogle() async {
    if (await googleSignIn()){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyApp()));
    }
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {  
      try {
       

        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        
         Uri fetchUserUrl = Uri.parse(baseUrl + 'user/email');
        final req = jsonEncode({
          "email": FirebaseAuth.instance.currentUser!.email as String
        });
        final response = await client.post(
      fetchUserUrl,
      body: req,
      headers: {
        'Content-Type': 'application/json', // Add this header
      },
    );

    // print(response.body);
    final res = jsonDecode(response.body);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // print(res);
    sharedPreferences.setString("userId", res['data']['_id']);
    if (res['data']['following'].length == 0){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(tabIndex: 0,)));
    }
        else{

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen(tabIndex: 1,)));
        }
      } catch (e) {
        // print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging in')),
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
              SizedBox(
                height: 20,
              ),
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
                validator: _validateEmail,
              ),
              SizedBox(
                height: 30,
              ),
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
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
              Align(
alignment: Alignment.centerRight,
child: TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPassword()));}, child: Text("Forgot password?", style: TextStyle(color: Colors.blue),)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A6A6A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
           
              SizedBox(height: 20),
              // Divider(),
              Text(
                "Or",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: 200,
                constraints: BoxConstraints(maxWidth: double.infinity),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Google login
                    signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                        color: const Color.fromARGB(91, 255, 255, 255),
                        width: 1),
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/Google_icon.png',
                        scale: 2,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("Continue with Google")
                    ],
                  ),
                ),
              ),
        
            ],
          ),
        ),
      ),
    );
  }
}
