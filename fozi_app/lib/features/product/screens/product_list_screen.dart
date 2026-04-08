import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import '../data/product_data.dart';



class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EE),
      appBar: AppBar(
        title: const Text("dummyProducts"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyProducts.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          Product product = dummyProducts[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProductDetailScreen(product: product),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                    child: Image.network(
                      product.image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  Text("\$${product.price}",
                      style: const TextStyle(
                          color: Color(0xFF1F4B3F),
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}