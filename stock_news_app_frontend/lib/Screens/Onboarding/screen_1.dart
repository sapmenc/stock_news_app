import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/screen_2.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: Center( 
        // Wrap the Column in a Center widget
      
        child: Column(
          
          mainAxisSize: MainAxisSize.min, // Adjusts the Column to the minimum space required

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            const Padding(padding: EdgeInsets.only(top: 60)),
            Image.asset('assets/screen1_img.png'),
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
                    "Your Gateway to Companies strategies and future plans",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15,),
                  Text(
                    "Follow favourite companies, Get real time updates. Stay informed and ahead",
                    textAlign: TextAlign.center,
                    // style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
            SizedBox(height: 60), // Add some spacing between containers
            Container(
              padding: EdgeInsets.only(right: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Screen2()));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), // <-- Radius
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      backgroundColor: Colors.transparent,
                      side: const BorderSide(width: 1, color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(width: 5,),
                        SvgPicture.asset('assets/arrow-right.svg')
                      ],
                    ),
                  ),
                ],
              ),
            )
         
          ],
        ),
      ),
    );
  }
}
