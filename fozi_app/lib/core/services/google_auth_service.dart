import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthService {

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        "58198664634-0qj65ee2a40projk24u4i84hqdd5klkn.apps.googleusercontent.com",
    scopes: ['email', 'profile'], // 🔥 IMPORTANT
  );

  static Future<Map?> login() async {
    try {
      // 🔥 STEP 1: OPEN GOOGLE LOGIN
      final GoogleSignInAccount? user = await _googleSignIn.signIn();

      if (user == null) return null;

      // 🔥 STEP 2: GET ACCESS TOKEN (NOT idToken)
      final GoogleSignInAuthentication auth = await user.authentication;

      final accessToken = auth.accessToken;

      print("ACCESS TOKEN: $accessToken"); // 🔥 DEBUG

      if (accessToken == null) return null;

      // 🔥 STEP 3: SEND TOKEN TO BACKEND
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/api/auth/google"), // 🔥 FIXED
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "access_token": accessToken, // ✅ IMPORTANT CHANGE
        }),
      );

      print("API STATUS: ${response.statusCode}");
      print("API BODY: ${response.body}");

      // 🔥 STEP 4: DECODE RESPONSE
      final data = jsonDecode(response.body);

      return data;

    } catch (e) {
      print("Google Login Error: $e");
      return null;
    }
  }
}