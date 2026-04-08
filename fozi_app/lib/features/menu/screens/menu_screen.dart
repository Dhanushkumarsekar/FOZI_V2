import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../product/models/product_model.dart';
import '../../../core/api/api_service.dart';
import '../../home/widgets/product_card.dart';
import '../../cart/providers/cart_provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      final data = await ApiService.getProducts();
      setState(() {
        products = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("All Products")),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 260,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {

          final product = products[index];

          return ProductCard(
            product: product,
            onAdd: () {
              Provider.of<CartProvider>(context, listen: false)
                  .addToCart(product, quantity: 1);
            },
          );
        },
      ),
    );
  }
}