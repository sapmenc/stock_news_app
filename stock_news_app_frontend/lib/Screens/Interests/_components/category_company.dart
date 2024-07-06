import 'package:flutter/material.dart';

class CategoryCompany extends StatefulWidget {
  const CategoryCompany({super.key});

  @override
  State<CategoryCompany> createState() => _CategoryCompanyState();
}

class _CategoryCompanyState extends State<CategoryCompany> {
  bool isFollowing = false;
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFollowing = !isFollowing;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // <-- Radius
                  ),
                  
                  backgroundColor: isFollowing?Color(0xFF4285F4):Colors.transparent,
                  side: const BorderSide(width: 1, color: Colors.grey),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Company name", style: TextStyle(color: Colors.white,),),
                    SizedBox(width: 5,),
                    Text("+", style: TextStyle(color: Colors.white),)
                  ],
                )
              );

  }
}