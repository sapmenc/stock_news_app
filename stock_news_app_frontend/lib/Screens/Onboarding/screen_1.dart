import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/screen_2.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 18, 18),
      body: Center( // Wrap the Column in a Center widget
      
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjusts the Column to the minimum space required

          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            const Padding(padding: EdgeInsets.only(top: 60)),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //     color: Colors.grey[400],
            //   ),
            //   width: 100,
            //   height: 40,
            //   alignment: Alignment.center, // Center the text within the container
            //   child: const Text(
            //     "Logo",
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // SizedBox(height: 30), // Add some spacing between containers
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[400],
              ),
              width: 280,
              height: 250,
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center, // Center the text within the container
              child: const Text(
                "Asset",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40), // Add some spacing between containers
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[400],
              ),
              width: 280,
              height: 110,
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center, // Center the text within the container
              child: const Text(
                "Content",
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50), // Add some spacing between containers
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Screen2()));
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // <-- Radius
                ),
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                backgroundColor: Colors.transparent,
                side: const BorderSide(width: 1, color: Colors.grey),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            )
         
          ],
        ),
      ),
    );
  }
}
