import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../cart/providers/cart_provider.dart';
import '../models/product_model.dart';
import '../widgets/quantity_selector.dart';
import '../../checkout/screens/checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState
    extends State<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [

          /// 🔹 Image Section
          Expanded(
            child: Stack(
              children: [
                          Hero(
            tag: widget.product.id,
            child: Image.network(
              widget.product.image,
              height: 300,
              fit: BoxFit.cover,
            ),
          ),
        
                /// Back Button
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🔹 Details Section
          Container(
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(35),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Name
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 10),

                /// Price
                Text(
                  "\$${widget.product.price}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                /// Description
                Text(
                  widget.product.description,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                /// Quantity Selector
                QuantitySelector(
                  quantity: quantity,
                  onIncrease: () {
                    setState(() => quantity++);
                  },
                  onDecrease: () {
                    if (quantity > 1) {
                      setState(() => quantity--);
                    }
                  },
                ),

                const SizedBox(height: 25),

                /// Buttons
                Row(
                  children: [

                    /// Add to Cart
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i < quantity; i++) {
  cart.addToCart(widget.product);
}


                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Added to Cart"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          minimumSize:
                              const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Add to Cart",
                          style:
                              TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    /// Buy Now
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i < quantity; i++) {
  cart.addToCart(widget.product);
}


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CheckoutScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black,
                          minimumSize:
                              const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Buy Now",
                          style:
                              TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
