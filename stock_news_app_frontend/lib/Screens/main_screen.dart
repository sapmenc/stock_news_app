import 'package:flutter/material.dart';
import 'package:stock_news_app_frontend/Screens/Explore/explore.dart';
import 'package:stock_news_app_frontend/Screens/HomeScreens/home.dart';
import 'package:stock_news_app_frontend/Screens/Profile/profile.dart';
import 'package:stock_news_app_frontend/_components/nav_bar.dart';
import 'package:stock_news_app_frontend/_components/nav_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final exploreNavKey = GlobalKey<NavigatorState>();
  final homeNavKey = GlobalKey<NavigatorState>();
  final profileNavKey = GlobalKey<NavigatorState>();
  int selectedTab = 1;
  List<NavModel> items=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items=[
      NavModel(page: Explore(), navkey: exploreNavKey),
      NavModel(page: Home(), navkey: homeNavKey),
      NavModel(page: Profile(), navkey: profileNavKey),
    ];
  }
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(items[selectedTab].navkey.currentState?.canPop()??false){
          items[selectedTab].navkey.currentState?.pop();
          return Future.value(false);
        }
        else{
          return Future.value(true);
        }
      },
      child: SafeArea(
        child: Scaffold(
          // extendBodyBehindAppBar: true,
          body: IndexedStack(
            index: selectedTab,
            children: items.map((page) => Navigator(key: page.navkey,
            onGenerateInitialRoutes: (navigator, initialRoute){
              return [
                MaterialPageRoute(builder: (context)=>page.page)
              ];
            },)).toList(),
          ),
          extendBody: true,
          
          bottomNavigationBar: Navbar(pageIndex: selectedTab, onTap: (index){
            if(index==selectedTab){
              items[index].navkey.currentState?.popUntil((route) => route.isFirst);
            }
            else{
              setState(() {
                selectedTab = index;
              });
            }
          }),
        ),
      ));
  }
}