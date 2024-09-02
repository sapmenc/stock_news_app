import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/login.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/otp.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/signup.dart';

import 'dart:ui' as ui show ImageFilter;

import 'package:stock_news_app_frontend/main.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  final ValueNotifier<String> authState = ValueNotifier<String>('login');

  void _updateStateVariable(String stateValue) {
    authState.value = stateValue;
  }

  void logScreen2() async{
        await analytics.logEvent(name: "app_onboarding_screen2",
    parameters: {
      "timestamp": DateTime.now().toIso8601String()
    }
    );
  }
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logScreen2();
  }
   
 Future<void> loginSlider() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color.fromARGB(28, 126, 118, 118),
      builder: (context) {
        return ValueListenableBuilder<String>(
          valueListenable: authState,
          builder: (context, value, child) {
            return FractionallySizedBox(
              heightFactor: value == 'login'||value=='otp' ? 0.6 : 0.8,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: value == 'login'
                        ? LoginForm(updateAuthState: _updateStateVariable,)
                        : value == 'sign-up'
                            ? SignUpForm(
                                updateAuthState: _updateStateVariable,
                              ):Container()
                            // : OtpVerification(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: Center(
        // Wrap the Column in a Center widget

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // Adjusts the Column to the minimum space required
          
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
          
            children: [
              const Padding(padding: EdgeInsets.only(top: 60)),
              Image.asset('assets/screen2_img.png'),
              SizedBox(height: 40), // Add some spacing between containers
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.grey[400],
                ),
                // width: 280,
                // height: 110,
                padding: const EdgeInsets.all(5),
                alignment: Alignment.center, // Center the text within the container
                child: const Column(
                  children: [
                    Text(
                      "Community Empowered: Where Conversations Lead to Insights",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15,),
                    Text(
                      "Join the conversation, share insights, and gain valuable perspectives through your comments",
                      textAlign: TextAlign.center,
                      // style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
          
                  ],
                ),
              ),
              SizedBox(height: 50), // Add some spacing between containers
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    
                    onPressed: () async{
                      _updateStateVariable('login');
                      await analytics.logEvent(
                        name: "Alpha_Login_initiated",
                        parameters: {
                          "timestamp": DateTime.now().toIso8601String()
                        }
                      );
                      loginSlider();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // <-- Radius
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(width: 1, color: Colors.grey),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  SizedBox(width: 15,),
                  ElevatedButton(
                    onPressed: () async{
                      // signUpSlider();
                  _updateStateVariable('sign-up');
                      loginSlider();
                                          await  analytics.logEvent(
                        name: "Alpha_Signup_initiated",
                        parameters: {
                          "timestamp": DateTime.now().toIso8601String()
                        }
                      );
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InterestedCompanies()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // <-- Radius
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Color(0xFF79ABFF),
                      side: const BorderSide(width: 1, color: Color(0xFF79ABFF)),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
