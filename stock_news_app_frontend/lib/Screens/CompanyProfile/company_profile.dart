import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/_components/company_details.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("logo"),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: BackButton(onPressed: (){
              Navigator.pop(context);
            }),
          ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            CompanyDetails(),
            Posts(),
            Posts(),
            Posts(),
            Posts(),
            Posts(),
          ],
        ),
      )
    );
  }
}