import 'package:flutter/material.dart';
import 'order_history_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(Icons.check_circle,
                color: Colors.green, size: 100),

            const SizedBox(height: 20),

            const Text(
              "Order Placed Successfully 🎉",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const OrderHistoryScreen(),
                  ),
                );
              },
              child: const Text("View Orders"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context, (route) => route.isFirst);
              },
              child: const Text("Go Home"),
            )
          ],
        ),
      ),
    );
  }
}