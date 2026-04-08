import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../product/models/product_model.dart';
import '../../cart/providers/cart_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';
import '../../product/screens/product_detail_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAdd;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final wishlist = Provider.of<WishlistProvider>(context);

    final bool isFav = wishlist.isInWishlist(product);

    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: product),
              ),
            );
          },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE + WISHLIST
            Stack(
              children: [
                Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Image.network(
                      product.image,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      wishlist.toggleWishlist(product);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFav
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "₹${product.price.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F4E3D),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1F4E3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onAdd ??
                          () {
                            cart.addToCart(product, quantity: 1);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${product.name} added to cart"),
                                duration:
                                    const Duration(seconds: 1),
                              ),
                            );
                          },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
