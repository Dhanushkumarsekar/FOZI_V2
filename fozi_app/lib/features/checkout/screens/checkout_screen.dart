import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/api/api_service.dart';
import '../../../core/services/payment_service.dart';

import '../../cart/providers/cart_provider.dart';
import '../../order/providers/order_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../order/screens/order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedPayment = "Cash on Delivery";

  Map<String, dynamic> buildOrderData(
      CartProvider cart, String userId) {

    return {
      "userId": userId,
      "products": cart.items.map((item) => {
            "name": item.product.name,
            "price": item.product.price,
            "quantity": item.quantity,
          }).toList(),
      "totalAmount": cart.totalAmount.toInt(),
      "customerDetails": {
        "name": nameController.text,
        "phone": phoneController.text,
        "address": addressController.text,
      }
    };
  }

  @override
  Widget build(BuildContext context) {

    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Checkout")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              _input(nameController, "Name"),
              _input(addressController, "Address"),
              _input(phoneController, "Phone"),

              const SizedBox(height: 20),

              /// PAYMENT
              RadioListTile(
                value: "Cash on Delivery",
                groupValue: selectedPayment,
                onChanged: (v) => setState(() => selectedPayment = v!),
                title: const Text("Cash on Delivery"),
              ),

              RadioListTile(
                value: "Online Payment",
                groupValue: selectedPayment,
                onChanged: (v) => setState(() => selectedPayment = v!),
                title: const Text("Online Payment"),
              ),

              const SizedBox(height: 20),

              /// TOTAL
              Text("Total: ₹${cart.totalAmount}"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {

                  if (!_formKey.currentState!.validate()) return;

                  final orderData =
                      buildOrderData(cart, auth.userId ?? "");

                  await ApiService.createOrder(orderData);

                  cart.clearCart();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OrderSuccessScreen(),
                    ),
                  );
                },
                child: const Text("Place Order"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String hint) {
    return TextFormField(
      controller: c,
      validator: (v) => v!.isEmpty ? "Required" : null,
      decoration: InputDecoration(hintText: hint),
    );
  }
}