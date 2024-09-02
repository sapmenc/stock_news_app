import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/CompanyProfile/company_profile.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';
class Companies extends StatefulWidget {
  final String name;
  final String profile;
  final numArticles;
  final String id;
  final bool isFollowing;
  const Companies({super.key, required this.isFollowing, required this.name, required this.profile, required this.numArticles, required this.id});

  @override
  State<Companies> createState() => _CompaniesState();
}

class _CompaniesState extends State<Companies> {

    late bool isFollowing;
    final client = http.Client();

    @override
  void initState() {
    print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz");
    print(widget.name);
    print(widget.isFollowing);
    // TODO: implement initState
    setState(() {
      isFollowing = widget.isFollowing;
    });
    super.initState();
  }

    void toggleFollow() async {
      try{
SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final userId = sharedPreferences.getString('userId');
    final base_url = '$baseUrl';
    Uri follow = Uri.parse(base_url + "company/follow");
    Uri unfollow = Uri.parse(base_url + "company/unfollow");
    final req = jsonEncode(
        {"userId": userId, "companyId": widget.id});

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
      }      else{
        await analytics.logEvent(name: "Alpha_companylisting_unfollow_${widget.id}", parameters: {
          "timestamp": DateTime.now().toIso8601String(),
          "user": userId
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
      await analytics.logEvent(name: "Alpha_companylisting_follow_${widget.name}", parameters: {
        "timestamp": DateTime.now().toIso8601String(),
        "user": userId
      });
      // print(response.body);
      final res = jsonDecode(response.body);
      if (res['status'] == false) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
    }
      }catch(e){
        Fluttertoast.showToast(msg: "Some error occured. try again later");
      }
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyProfile( id: widget.id, name: widget.name, isFollowing: widget.isFollowing)));
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(widget.profile),
                radius: 25,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CompanyProfile(id: widget.id, name: widget.name, isFollowing: isFollowing,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 190
                    ),
                    child: Text(
                      widget.name,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Text('${widget.numArticles} articles')
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
              ],
            ),

            TextButton(
                onPressed: () {
                  toggleFollow();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isFollowing?Color(0xFF4285F4):Colors.transparent,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Color(0xFF727272),
                      )),
                  child: !isFollowing?Text(
                    "+",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ):Icon(Icons.check, color: Colors.white,)
                ))
          ],
        ),
      ],
    );
  }
}
