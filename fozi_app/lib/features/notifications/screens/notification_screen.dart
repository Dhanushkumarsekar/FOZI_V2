import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notification_provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              "You have ${provider.count} notifications",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.clearNotifications,
              child: const Text("Clear All"),
            )
          ],
        ),
      ),
    );
  }
}
