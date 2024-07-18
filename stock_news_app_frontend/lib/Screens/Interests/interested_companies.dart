import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/Interests/_components/category.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

class InterestedCompanies extends StatefulWidget {
  const InterestedCompanies({super.key});

  @override
  State<InterestedCompanies> createState() => _InterestedCompaniesState();
}

class _InterestedCompaniesState extends State<InterestedCompanies> {
  var categories = {};
  final base_url = '$baseUrl';

  @override
  void initState() {
    fetchCompanies();
    // TODO: implement initState
    super.initState();
  }

  void fetchCompanies() async {
    final client = http.Client();
    Uri fetch_companies = Uri.parse(base_url + "/company/industry");
    print(
        "fetch companies: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5: ");
    print(fetch_companies);
    final response = await http.get(fetch_companies);
    print("#############################################");
    // final res = jsonDecode(response.body);
    print(response.body);
    // setState(() {
    //   categories = res['data'];
    // });
    // categories.forEach((key, value) {
    //   print(value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              const Text(
                "Select the companies you are interested in",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories.entries.map((e) {
                      return Category(name: e.key, companies: e.value);
                    }).toList()),
              )),
              ElevatedButton(
                onPressed: () async {
                  final client = http.Client();
                  Uri user = Uri.parse(base_url + "/user/email");
                  final req = jsonEncode({"email": "mdareeb176@gmail.com"});
                  final response = await client.post(
                    user,
                    body: req,
                    headers: {
                      'Content-Type': 'application/json', // Add this header
                    },
                  );
                  final res = jsonDecode(response.body);
                  print(
                      "##################################################################");
                  // print(res);
                  final data = res['data'];
                  print(data);
                  if (data['following'].length == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Follow atleast one company.")));
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  "Save details",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
