import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/Screens/Interests/interested_companies.dart';
import 'package:stock_news_app_frontend/Screens/Onboarding/screen_1.dart';
import 'package:flutter/services.dart';
import 'package:stock_news_app_frontend/Screens/main_screen.dart';
import 'package:stock_news_app_frontend/firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:stock_news_app_frontend/utils.dart';

FirebaseAnalytics analytics = FirebaseAnalytics.instance;
bool hello = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final client = http.Client();
  bool isNew = false;
  bool? isLoggedin = null;
  DateTime? _sessionStartTime;
  void logAppOpen()async{
    await analytics.logAppOpen(
      parameters: {
        'user': FirebaseAuth.instance.currentUser!=null?FirebaseAuth.instance.currentUser:"new user",
        'timestamp': DateTime.now().toIso8601String()
      }
    );
  }

    Future<void> _logSessionDuration() async {
    if (_sessionStartTime == null) return;

    final sessionEndTime = DateTime.now();
    final duration = sessionEndTime.difference(_sessionStartTime!).inMinutes;

    await analytics.logEvent(
      name: 'session_duration',
      parameters: {
        'duration_minutes': duration,
      },
    );
  }

    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has resumed, start the session timer
      _sessionStartTime = DateTime.now();
    } else if (state == AppLifecycleState.paused) {
      // App is about to be paused or killed, log session duration
      _logSessionDuration();
    }
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    redirect();
    logAppOpen();

  }

  

  Future<void> redirect() async {
    try {
      Uri userUri = Uri.parse('${baseUrl}' + 'user/email');
      if (FirebaseAuth.instance.currentUser != null) {
        final req =
            jsonEncode({'email': FirebaseAuth.instance.currentUser!.email});
        final response = await client.post(userUri,
            body: req, headers: {'Content-Type': 'application/json'});
        final res = jsonDecode(response.body);

        if (res['data']['following'].length == 0) {
          setState(() {
            isNew = true;
            isLoggedin = true;
          });
        } else {
          setState(() {
            isLoggedin = true;
          });
        }
      } else {
        setState(() {
          isLoggedin = false;
        });
      }
    } catch (e) {
      // Handle errors here
      setState(() {
        isLoggedin = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alpha Tribe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
          primary: const Color.fromARGB(255, 255, 255, 255),
          secondary: Colors.amber,
          background: Colors.black,
          surface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: isLoggedin == null
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : isLoggedin! && isNew
              ? MainScreen(tabIndex: 0)
              : isLoggedin!
                  ? MainScreen(tabIndex: 1,)
                  : Screen1(),
    );
  }
}
