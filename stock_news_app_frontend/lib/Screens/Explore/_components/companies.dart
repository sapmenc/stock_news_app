import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';

class Companies extends StatefulWidget {
  const Companies({super.key});

  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {
    bool isFollowing = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CompanyProfile()));
          },
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage("https://github.com/shadcn.png"),
            radius: 25,
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CompanyProfile()));
          },
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Company Name",
                style: TextStyle(fontSize: 18),
              ),
              Text("1739 articles")
            ],
          ),
        ),
        SizedBox(
          width: 40,
        ),
        TextButton(
            onPressed: () {
              setState(() {
                isFollowing = !isFollowing;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isFollowing?Color(0xFF4285F4):Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Color(0xFF727272),
                  )),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
              child: Text(
                "+",
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ))
      ],
    );
  }
}
