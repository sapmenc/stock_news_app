import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/Interests/_components/category.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';

class InterestedCompanies extends StatefulWidget {
  const InterestedCompanies({super.key});

  @override
  State<InterestedCompanies> createState() => _InterestedCompaniesState();
}

class _InterestedCompaniesState extends State<InterestedCompanies> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(15),
        child:  Column(
          children: [
            const Text("Select the companies you are interested in", style: TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none, ),),
            const SizedBox(height: 15,),
            const Expanded(
              
              child: 
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Category(name: "Category 1",),
                  Category(name: "Category 2",),
                  Category(name: "Category 3"),
                  Category(name: "Category 4"),
                  Category(name: "Category 5"),
          
                ],
              ),
            )),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()));
            }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF34A853), shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),  child: const Text("Save details", style: TextStyle(color: Colors.white),),)
          ],
      
        ),
      ),
    );
  }
}