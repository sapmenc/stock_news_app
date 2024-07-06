import 'package:flutter/material.dart';

class NavModel{
  final Widget page;
  final GlobalKey<NavigatorState> navkey;
  NavModel({required this.page, required this.navkey});
}