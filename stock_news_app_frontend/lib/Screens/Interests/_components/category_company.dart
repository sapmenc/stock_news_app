import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/utils.dart';

class CategoryCompany extends StatefulWidget {
  final name;
  final id;
  const CategoryCompany({super.key, required this.name, required this.id});

  @override
  State<CategoryCompany> createState() => _CategoryCompanyState();
}

class _CategoryCompanyState extends State<CategoryCompany> {
  bool isFollowing = false;
  final client = http.Client();
  
  void toggleFollow() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString('userId');
    final base_url = '$baseUrl';
    Uri follow = Uri.parse(base_url + "company/follow");
    Uri unfollow = Uri.parse(base_url + "company/unfollow");
    final req = jsonEncode(
        {"userId": userId, "companyId": widget.id});
    // print(widget.id);
    if (isFollowing) {
      setState(() {
        isFollowing = !isFollowing;
      });
      final response = await client.post(
        unfollow,
        body: req,
        headers: {
          'Content-Type': 'application/json', // Add this header
        },
      );

      // print(response.body);
      final res = jsonDecode(response.body);
      if (res['status'] == false) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
    } else {
      setState(() {
        isFollowing = !isFollowing;
      });

      final response = await client.post(
        follow,
        body: req,
        headers: {
          'Content-Type': 'application/json', // Add this header
        },
      );

      // print(response.body);
      // final res = jsonDecode(response.body);
      // if (res['status'] == false) {
      //   setState(() {
      //     isFollowing = !isFollowing;
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          toggleFollow();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // <-- Radius
          ),
          backgroundColor: isFollowing ? Color(0xFF4285F4) : Colors.transparent,
          side: const BorderSide(width: 1, color: Colors.grey),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 5),
                constraints: BoxConstraints(maxWidth: 250),
                child: Text(
                  "${widget.name}",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                )),
            const SizedBox(
              width: 5,
            ),
            !isFollowing
                ? const Text(
                    "+",
                    style: TextStyle(color: Colors.white),
                  )
                : Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 10,
                  )
          ],
        ));
  }
}
