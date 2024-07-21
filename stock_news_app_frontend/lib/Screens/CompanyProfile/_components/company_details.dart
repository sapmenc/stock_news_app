import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;
class CompanyDetails extends StatefulWidget {
  final isFollowing;
  final id;
  const CompanyDetails({super.key, required this.isFollowing, required this.id});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  final client = http.Client();
  bool isFollowing = false;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      isFollowing = widget.isFollowing;
    });
    super.initState();
  }

  void toggleFollow() async {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final userId = sharedPreferences.getString('userId');
    final base_url = '$baseUrl';
    Uri follow = Uri.parse(base_url + "company/follow");
    Uri unfollow = Uri.parse(base_url + "company/unfollow");
    final req = jsonEncode(
        {"userId": userId, "companyId": widget.id});
    print("3333333333333333333333333333333333333333333333333333");
    print(widget.id);
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
      print(response.body);

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

      print(response.body);
      final res = jsonDecode(response.body);
      if (res['status'] == false) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      width: screenWidth,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage("https://github.com/shadcn.png"),
                radius: 30,
              ),
              const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                                const Text(
                          "Company name",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("1248 articles"),
                                        ElevatedButton(
                                        onPressed: () {
                                          toggleFollow();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20), // <-- Radius
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: !isFollowing?40:36.6, vertical: 0),
                                          
                                          backgroundColor: isFollowing?Color(0xFF4285F4):Colors.transparent,
                                          side: const BorderSide(width: 1, color: Colors.grey),
                                        ),
                                        child: !isFollowing? const Row(
                                          children: [
                                            Text("Follow", style: TextStyle(color: Colors.white,),),
                                            SizedBox(width: 5,),
                                            Text("+", style: TextStyle(color: Colors.white),)
                                          ],
                                        ):Text("Following", style: TextStyle(color: Colors.white),)
                                      )
                        
                          ],
                        )
                          ],
                        ),
                      )
            ],
          ),
          SizedBox(height: 15,),
          const Text("Rotta Print India Private Limited an ISO 9001: 2008 Certified Company with its CE Certified Products, is a dream project of two highly successful technocrats with a combined experience of more than 25 years."),
          Divider(),
        ],
      ),
    );
  }
}
