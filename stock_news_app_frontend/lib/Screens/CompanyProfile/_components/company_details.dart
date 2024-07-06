import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/_components/posts.dart';

class CompanyDetails extends StatefulWidget {
  const CompanyDetails({super.key});

  @override
  State<CompanyDetails> createState() => _CompanyDetailsState();
}

class _CompanyDetailsState extends State<CompanyDetails> {
  bool isFollowing = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      width: screenWidth,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage("https://github.com/shadcn.png"),
                radius: 30,
              ),
              const SizedBox(width: 10),

                      Column(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("1248 articles"),
                          SizedBox(width: 40,),
                                      ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFollowing = !isFollowing;
                  });
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
