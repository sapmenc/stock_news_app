  import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

Future<bool> googleSignIn() async {
  print("1111111111111111111111111111111111111111111111111111111111111111111111");
  final client = http.Client();
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  print("22222222222222222222222222222222222222222222222222222222222222222222222");
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  print("33333333333333333333333333333333333333333333333333333333333333333333333");
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );
  print("4444444444444444444444444444444444444444444444444444444444444444444444444");


  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  print("5555555555555555555555555555555555555555555555555555555555555555555555555555555");
  print(userCredential.user!.displayName);
  if (userCredential.user!.displayName!=null && userCredential.user!.email!=null){
    print("fetching user from db");
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
      await sharedPreferences.setString("email", res['data']['email']);
      await sharedPreferences.setString("userId", res['data']['_id']);
      return true;
    }
    else{
      print("creating user in db");
      final response2 = await client.post(createUser, body: user1req, headers: {
        'Content-Type': 'Application/json'
      });
      final resp = jsonDecode(response2.body);
      print(resp);
      if (resp['status']){
        await sharedPreferences.setString("email", resp['data']['email']);
        await sharedPreferences.setString("userId", resp['data']['_id']);
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
