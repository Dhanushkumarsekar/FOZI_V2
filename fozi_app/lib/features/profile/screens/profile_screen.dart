import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../auth/providers/auth_provider.dart';
import '../../admin/screens/admin_dashboard_screen.dart';
import '../../order/screens/order_tracking_screen.dart';
import '../../order/screens/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// PROFILE IMAGE
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  auth.image != null ? NetworkImage(auth.image!) : null,
              child: auth.image == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            const SizedBox(height: 10),

            /// NAME
            Text(
              auth.name ?? "Guest",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),

            /// EMAIL
            Text(
              auth.email ?? "",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// 📦 ORDER HISTORY
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("My Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderHistoryScreen(),
                  ),
                );
              },
            ),

            /// 🔥 ADMIN BUTTON
            if (auth.isAdmin)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text("Admin Dashboard"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AdminDashboardScreen(),
                    ),
                  );
                },
              ),

            const SizedBox(height: 20),

            /// 🚪 LOGOUT
            ElevatedButton(
              onPressed: () async {
                await auth.logout();

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}