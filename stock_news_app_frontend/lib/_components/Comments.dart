import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stock_news_app_frontend/_components/Comment.dart';

class Comments extends StatelessWidget {
  const Comments({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: TextField(
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue, // Change border color here
                      ),
                    ),
                    hintText: "Add a comment",
                    hintStyle: TextStyle(
                      color: Color(0xFF515151), // Change hint text color here
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF515151), // Change border color for enabled state
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF515151), // Change border color for focused state
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color.fromARGB(150, 158, 158, 158)),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: IconButton(onPressed: () {}, icon: SvgPicture.asset('assets/CommentButton.svg')))
            ],
          ),
          SizedBox(height: 10), // Add some space between the input and comments
          Comment(),
          Comment(),
          Comment(),
          Comment(),
          Comment(),
          Comment(),
        ],
      ),
    );
  }
}
