import 'package:flutter/material.dart';

class BannerSection extends StatelessWidget {
  const BannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage(
            "https://images.unsplash.com/photo-1594035910387-fea47794261f",
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
