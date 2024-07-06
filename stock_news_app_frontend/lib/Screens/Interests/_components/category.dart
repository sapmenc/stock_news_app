import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/Interests/_components/category_company.dart';

class Category extends StatefulWidget {
  final String name;
  const Category({super.key, required this.name});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.name}',
            style: TextStyle(
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 16),
          ),
          SizedBox(height: 10,),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 8,
              children: [
                CategoryCompany(),
                CategoryCompany(),
                CategoryCompany(),
                CategoryCompany(),
                CategoryCompany(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
