import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';
import 'package:stock_news_app_frontend/Screens/Explore/_components/companies.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                appBar: AppBar(
            title: Text("logo"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
      body: Container(
          padding: EdgeInsets.all(15),
          child: const Column(children: [
            TextField(
              cursorColor: Colors.white,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(102, 255, 255, 255),
                filled: true,
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue, // Change border color here
                  ),
                ),
                hintText: "Search company",
                suffixIcon: Icon(Icons.search),
                hintStyle: TextStyle(
                  color: Color.fromARGB(
                      255, 255, 255, 255), // Change hint text color here
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(
                          0xFF515151), // Change border color for enabled state
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(
                          0xFF515151), // Change border color for focused state
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                    Companies(),
                    Divider(),
                  ],
                ),
              ),
            )
          ]),
        ),
      
    );
  }
}
