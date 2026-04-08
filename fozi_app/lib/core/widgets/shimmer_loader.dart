// Loading Widget
import 'package:flutter/material.dart';
class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade300, Colors.grey.shade100],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
