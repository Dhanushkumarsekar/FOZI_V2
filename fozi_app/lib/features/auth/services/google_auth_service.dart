import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthService {

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: "58198664634-0qj65ee2a40projk24u4i84hqdd5klkn.apps.googleusercontent.com",
  );

  static Future<Map?> login() async {
    try {
      final user = await _googleSignIn.signIn();

      if (user == null) return null;

      final auth = await user.authentication;

      final idToken = auth.idToken;

      // 🔥 SEND TOKEN TO BACKEND
      final response = await http.post(
        Uri.parse("http://localhost:5000/api/auth/google"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": idToken,
        }),
      );

      final data = jsonDecode(response.body);

      return data; // ✅ RETURN MAP (IMPORTANT)

    } catch (e) {
      print("Google Login Error: $e");
      return null;
    }
  }
}