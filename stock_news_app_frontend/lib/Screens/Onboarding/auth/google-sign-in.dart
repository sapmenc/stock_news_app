  import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/main.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

Future<bool> googleSignIn() async {
  DateTime start = DateTime.now();
  final client = http.Client();
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );


  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

  if (userCredential.user!.displayName!=null && userCredential.user!.email!=null){
    Uri createUser = Uri.parse('${baseUrl}' + 'user');
    Uri fetchUser = Uri.parse(baseUrl+'user/email');
    final user1req = jsonEncode(
        {'name': userCredential.user!.displayName, 'email': userCredential.user!.email});
    final response = await client.post(
      fetchUser,
      body: user1req,
      headers: {
        'Content-Type': 'application/json', // Add this header
      },
    );
    final res = jsonDecode(response.body);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (res['status']){
      await analytics.logEvent(name: "Alpha_Login_success", parameters: {
        "timestamp": DateTime.now().toIso8601String()
      });
                        DateTime endTime = DateTime.now();
    final duration = endTime.difference(start).inMilliseconds;    await analytics.logEvent(name: "signin_response_time_google", parameters: {
      "time": duration
    });
      await sharedPreferences.setString("email", res['data']['email']);
      await sharedPreferences.setString("userId", res['data']['_id']);
      return true;
    }
    else{
      FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      await analytics.logSignUp(signUpMethod: "google sign in");
      // print("creating user in db");
      final response2 = await client.post(createUser, body: user1req, headers: {
        'Content-Type': 'Application/json'
      });
      final resp = jsonDecode(response2.body);
      // print(resp);
      if (resp['status']){

        await sharedPreferences.setString("email", resp['data']['email']);
        await sharedPreferences.setString("userId", resp['data']['_id']);
                          DateTime endTime = DateTime.now();
    final duration = endTime.difference(start).inMilliseconds;    await analytics.logEvent(name: "signin_response_time_google", parameters: {
      "time": duration
    });
        return true;
      }
      else{
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        await sharedPreferences.clear();
        return false;
      }
    }
  }
  return false;
}
