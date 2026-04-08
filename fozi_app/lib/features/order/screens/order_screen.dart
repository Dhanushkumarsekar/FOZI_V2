// // Orders Screen
import 'package:flutter/material.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// SUCCESS ICON
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "Order Placed Successfully 🎉",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            /// SUBTEXT
            const Text(
              "Your perfume will be delivered soon!",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            /// GO HOME BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
              ),
              child: const Text(
                "Continue Shopping",
                style: TextStyle(color: Colors.white),
              ),
            ),

            const SizedBox(height: 15),

            /// VIEW ORDERS BUTTON
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/orders");
              },
              child: const Text("View My Orders"),
            ),
          ],
        ),
      ),
    );
  }
}