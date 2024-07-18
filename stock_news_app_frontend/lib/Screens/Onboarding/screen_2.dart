import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/Interests/interested_companies.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/login.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/auth/signup.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:stock_news_app_frontend/main.dart';
import 'dart:ui' as ui show ImageFilter;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  bool isLogin = true;
  
  
   
  Future<void> loginSlider() {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Color.fromARGB(28, 126, 118, 118),
    // showDragHandle: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: isLogin?0.6:0.8,
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
              // color: Color.fromARGB(22, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: isLogin?LoginForm():SignUpForm(),
          ),
        ),
      ),
    ),
  );
}
 
  Future<void> signUpSlider() {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Color.fromARGB(28, 126, 118, 118),
    // showDragHandle: true,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.8,
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
              // color: Color.fromARGB(22, 255, 255, 255),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SignUpForm(),
          ),
        ),
      ),
    ),
  );
}
 @override
  void initState() {
    // TODO: implement initState
    redirect();
    super.initState();
  }
  void redirect()async{
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print(email);
    if (email=="mdareeb176@gmail.com"){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InterestedCompanies()));
    }

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
                    
                    onPressed: () {
                      setState(() {
                        isLogin = true;
                      });
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
                    onPressed: () {
                      // signUpSlider();
                      setState(() {
                        isLogin = false;
                      });
                      loginSlider();
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
