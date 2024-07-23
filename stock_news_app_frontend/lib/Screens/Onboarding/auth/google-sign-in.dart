  import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_news_app_frontend/utils.dart';
import 'package:http/http.dart' as http;

Future<bool> googleSignIn() async {
  final client = http.Client();
  print("111111111111111111111111111111111");
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  print(userCredential.user!.displayName);
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
      sharedPreferences.setString("email", res['data']['email']);
      sharedPreferences.setString("userId", res['data']['_id']);
      return true;
    }
    else{
      final response2 = await client.post(createUser, body: user1req, headers: {
        'Content-Type': 'Application/json'
      });
      final resp = jsonDecode(response2.body);
      print(resp);
      if (resp['status']){
        sharedPreferences.setString("email", res['data']['email']);
        sharedPreferences.setString("userId", res['data']['_id']);
        return true;
      }
      else{
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        sharedPreferences.clear();
        return false;
      }
    }
  }
  return false;
}
