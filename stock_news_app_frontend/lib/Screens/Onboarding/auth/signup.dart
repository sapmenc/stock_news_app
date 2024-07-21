import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/Interests/interested_companies.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/otp.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

class SignUpForm extends StatefulWidget {
  final Function(String) updateAuthState;
  const SignUpForm({super.key, required this.updateAuthState});
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final client = http.Client();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void createUserinDb() async {
    Uri createUser = Uri.parse('${baseUrl}' + 'user');
    final req = jsonEncode(
        {'name': _fullNameController.text, 'email': _emailController.text});
    final response = await client.post(
      createUser,
      body: req,
      headers: {
        'Content-Type': 'application/json', // Add this header
      },
    );

    print("111111111111111111111111111111111111111111111111111111111111111111");
    print(response.body);
    final res = jsonDecode(response.body);
    if (res['status']){
      SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
      sharedPreferences.setString('userId', res['data']['_id']);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>InterestedCompanies()));
    }
    else{
      Fluttertoast.showToast(msg: res['message']);
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty || value.length < 3) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (_passwordController.text != _confirmPasswordController.text) {
      return "Passwords do not match";
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
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        createUserinDb();
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'weak-password') {
          message = 'Password is too weak';
        } else if (e.code == 'email-already-in-use') {
          message = "email is already in use";
        }
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
      } catch (e) {
        Fluttertoast.showToast(
            msg: "some error occured",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 14.0);
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
                controller: _fullNameController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  fillColor: Color.fromARGB(15, 255, 255, 255),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Full name",
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
                validator: _validateName,
              ),

              SizedBox(
                height: 30,
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
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 81, 81,
                          81), // Change border color for enabled state
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
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
              SizedBox(height: 30),
              TextFormField(
                controller: _confirmPasswordController,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(15, 255, 255, 255),
                  filled: true,
                  contentPadding: EdgeInsets.all(10),
                  labelText: "Re-enter Password",
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(0, 81, 81,
                          81), // Change border color for enabled state
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
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
                validator: _validateConfirmPassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A6A6A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Divider(),
              const Text(
                "Or",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                constraints: BoxConstraints(maxWidth: double.infinity),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle Google login
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
