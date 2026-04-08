// Register Screen
import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: password, decoration: const InputDecoration(labelText: "Password")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {

                final success = await ApiService.register(
                  name: name.text,
                  email: email.text,
                  password: password.text,
                );

                if (success) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}