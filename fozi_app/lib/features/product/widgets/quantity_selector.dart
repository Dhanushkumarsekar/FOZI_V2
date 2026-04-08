import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Quantity",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrease,
              ),
              Text(
                quantity.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: onIncrease,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
