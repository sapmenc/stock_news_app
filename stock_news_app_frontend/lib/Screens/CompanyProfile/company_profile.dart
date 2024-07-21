import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/_components/company_details.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;
class CompanyProfile extends StatefulWidget {
  final id;
  final isFollowing;
  const CompanyProfile({super.key, required this.id, required this.isFollowing});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
        final base_url = '${baseUrl}';
    final client = http.Client();

    void fetchCompanyData()async{
      
    }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            CompanyDetails(isFollowing: widget.isFollowing, id:widget.id),
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