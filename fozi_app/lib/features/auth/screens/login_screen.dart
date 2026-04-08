import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../../../core/services/google_auth_service.dart';
import '../../admin/screens/admin_login_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              /// 🔥 TITLE
              const Text(
                "Welcome Back 👋",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              /// EMAIL
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔐 LOGIN BUTTON
              ElevatedButton(
                onPressed: isLoading ? null : () async {

                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fill all fields")),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  bool success = await auth.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  setState(() => isLoading = false);

                  if (!context.mounted) return;

                  if (success) {
                    Navigator.pushReplacementNamed(context, "/home");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Failed ❌")),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),

              const SizedBox(height: 15),

              /// 🔥 GOOGLE LOGIN
              ElevatedButton.icon(
                icon: const Icon(Icons.g_mobiledata, size: 30),
                onPressed: () async {

                  final result = await GoogleAuthService.login();

                  if (!context.mounted) return;

                  if (result != null && result['success'] == true) {

                    await auth.loginWithGoogle(result);

                    if (!context.mounted) return;

                    Navigator.pushReplacementNamed(context, "/home");

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Google Login Failed ❌")),
                    );
                  }
                },
                label: const Text("Login with Google"),
              ),

              const SizedBox(height: 15),

              /// 🆕 REGISTER BUTTON
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Register"),
              ),

              const SizedBox(height: 10),

              /// 👨‍💼 ADMIN PANEL
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminLoginScreen(),
                    ),
                  );
                },
                child: const Text("Admin Panel"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}