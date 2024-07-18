import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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
    if (value == null || value.isEmpty || value.length<3) {
      return 'Please enter your full name';
    }
    return null;
  }
  String? _validateConfirmPassword(String? value){
    // if(value != _passwordController.value as String){
    //   return "Passwords do not match";
    // }
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
    // await Firebase.initializeApp();
    print("##############################################################");
    if (_formKey.currentState!.validate()) {
      // Process the login
      print(_emailController.value);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Processing Data')),
      );
        try{
          // UserCredential usercreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: "aalam@gitam.com", password: "Nazaarah@aesha9");
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainScreen()));
        } catch(e){
          print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some error Occured:')),
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
                  controller: _fullNameController,
                      cursorColor: Colors.white,
                      
                    decoration: const InputDecoration(
                  fillColor: Color.fromARGB(15, 255, 255, 255),
                  filled: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Full name",
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
                  validator: _validateName,
                ),
             
                SizedBox(height: 30,),
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
                              SizedBox(height: 30),
                TextFormField(
                  controller: _confirmPasswordController,
                                      cursorColor: Colors.white,
            
                  decoration: InputDecoration(
                                      fillColor: Color.fromARGB(15, 255, 255, 255),
                  filled: true,
                      contentPadding: EdgeInsets.all(10),
                      labelText: "Re-enter Password",
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
                  validator: _validateConfirmPassword,
                ),
                              SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A6A6A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: Text('Sign up', style: TextStyle(color: Colors.white),),
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
