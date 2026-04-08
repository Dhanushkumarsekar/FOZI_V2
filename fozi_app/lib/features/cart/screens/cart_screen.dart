import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/api/api_service.dart';

// import '../../../core/services/payment_service.dart';
// import '../../order/screens/order_success_screen.dart';

import '../providers/cart_provider.dart';
import '../../order/screens/order_success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "My Cart",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [

                /// CART LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {

                      final item = cart.items[index];

                      return Container(
                        margin: const EdgeInsets.all(12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.1),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          children: [

                            /// IMAGE
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(12),
                              child: Image.network(
                                item.product.image,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 15),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "₹${item.product.price}",
                                  ),
                                ],
                              ),
                            ),

                            /// QUANTITY
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    cart.decreaseQty(
                                        item.product.id);
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                                Text(item.quantity.toString()),
                                IconButton(
                                  onPressed: () {
                                    cart.increaseQty(
                                        item.product.id);
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                /// TOTAL + PAYMENT
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    children: [

                      /// TOTAL
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                          Text(
                            "₹${cart.totalAmount.toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      /// PAY BUTTON
                      ElevatedButton(
                        onPressed: () async {

                          int total = cart.totalAmount.toInt();
                          if (total == 0) return;

                          /// 🔥 PREPARE ITEMS LIST
                          List items = cart.items.map((e) {
                            return {
                              "productId": e.product.id,
                              "quantity": e.quantity
                            };
                          }).toList();

                          PaymentService.startPayment(
                            amount: total,

                            /// ✅ SUCCESS
                            onSuccess: (response) async {

                              try {

                                /// 🔥 VERIFY + SAVE ORDER
                                await ApiService.verifyPayment(
                                  orderId: response.orderId!,
                                  paymentId: response.paymentId!,
                                  signature: response.signature!,
                                  userId: "user123",
                                  items: items,
                                  totalAmount: total,
                                );

                                /// 🔥 CLEAR CART
                                cart.clearCart();

                                /// 🔥 NAVIGATE TO SUCCESS SCREEN
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                      OrderSuccessScreen(),
                                  ),
                                );

                              } catch (e) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                      content: Text("Verification Failed ❌")),
                                );
                              }
                            },

                            /// ❌ ERROR
                            onError: (error) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text("Payment Failed ❌"),
                                ),
                              );
                            },
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize:
                              const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),

                        child: const Text(
                          "Pay Now",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}