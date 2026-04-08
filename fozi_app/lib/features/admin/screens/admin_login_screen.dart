import 'package:flutter/material.dart';
import 'package:fozi_mobile_app/core/api/api_service.dart';
import 'admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter all fields ❗")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await ApiService.adminLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print("LOGIN SUCCESS: $success");
      print("TOKEN: ${ApiService.token}");

      if (!mounted) return;

      if (success && ApiService.token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboardScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Failed ❌")),
        );
      }

    } catch (e) {
      print("LOGIN ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Server Error ⚠️")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Login")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}