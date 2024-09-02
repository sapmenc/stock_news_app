import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

class CompanyDetails extends StatefulWidget {
  final bool isFollowing;
  final String id;

  const CompanyDetails(
      {super.key, required this.isFollowing, required this.id});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  Map<String, dynamic> companyData = {};
  bool isFollowing = false;
  final client = http.Client();

  void fetchCompanyData() async {
    Uri companyUri = Uri.parse(baseUrl + 'company/id');
    // print(widget.id);
    final req = jsonEncode({"companyId": widget.id as String});
    final response = await client.post(companyUri,
        body: req, headers: {'Content-Type': 'application/json'});
    final res = jsonDecode(response.body);
    // print("111111111111111111111111111111111111111111111111");
    print(response.body);
    setState(() {
      companyData = res['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCompanyData();
    isFollowing = widget.isFollowing;
  }

  void toggleFollow() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString('userId');
    final base_url = '$baseUrl';
    Uri follow = Uri.parse(base_url + "company/follow");
    Uri unfollow = Uri.parse(base_url + "company/unfollow");
    final req = jsonEncode({"userId": userId, "companyId": widget.id});
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
      final res = jsonDecode(response.body);
      if (res['status'] == false) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
            else{
        await analytics.logEvent(name: "Alpha_companypage_unfollow_${companyData['name']}", parameters: {
          "timestamp": DateTime.now().toIso8601String()
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


      final res = jsonDecode(response.body);
      if (res['status'] == false) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
      else{
        await analytics.logEvent(name: "Alpha_companypage_follow_${companyData['id']}", parameters: {
          "timestamp": DateTime.now().toIso8601String()
        });
      }

    }
    } catch (e) {
      Fluttertoast.showToast(msg: "Some error occured. try again later");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      child: Column(
        children: [
          if (companyData.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(companyData['logo'] ?? ''),
                  radius: 30,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: screenWidth * 0.7),
                        child: Text(
                          companyData['name'] ?? '',
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${(companyData['post'] ?? []).length} articles"),
                          ElevatedButton(
                              onPressed: () {
                                toggleFollow();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20), // <-- Radius
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: !isFollowing ? 40 : 36.6,
                                    vertical: 0),
                                backgroundColor: isFollowing
                                    ? Color(0xFF4285F4)
                                    : Colors.transparent,
                                side: const BorderSide(
                                    width: 1, color: Colors.grey),
                              ),
                              child: !isFollowing
                                  ? const Row(
                                      children: [
                                        Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "+",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    )
                                  : Text(
                                      "Following",
                                      style: TextStyle(color: Colors.white),
                                    ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          else
            Container(),
          SizedBox(
            height: 15,
          ),
          if (companyData.containsKey('description'))
            Text(companyData['description'] ?? ''),
          Divider(),
        ],
      ),
    );
  }
}
