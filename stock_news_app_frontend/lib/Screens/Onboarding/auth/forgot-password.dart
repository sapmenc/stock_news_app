import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isSent = false;
  TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: !isSent
            ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enter your email to send password reset link"),
                    SizedBox(
                      height: 30,
                    ),
                    Divider(),
                    TextFormField(
                      controller: _emailcontroller,
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
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              if (_emailcontroller.text.isEmpty){
                                                              Fluttertoast.showToast(msg: "Enter your email");
                                                              return;

                              }
                              await FirebaseAuth.instance.sendPasswordResetEmail(
                                  email: _emailcontroller.text);
                              setState(() {
                                isSent = true;
                              });
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Some error occured");
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Reset Password",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 76, 149, 231),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        )),
                  ],
                ),
            )
            : Center(
                child: Text("password reset link has been sent to your email."),
              ));
  }
}
