import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {

  List users = [];

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    final res = await ApiService.getAdminUsers();
    setState(() => users = res);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("All Users")),

      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {

          final u = users[index];

          return ListTile(
            title: Text(u['name']),
            subtitle: Text(u['email']),
          );
        },
      ),
    );
  }
}