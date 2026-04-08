import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:image_picker/image_picker.dart';
import '../../../core/api/api_service.dart';

import '../../product/models/product_model.dart';
import '../../home/widgets/product_card.dart';
import '../../cart/providers/cart_provider.dart';
import '../../notifications/providers/notification_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  late stt.SpeechToText speech;
  bool isListening = false;

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    loadProducts();
  }

  /// 🔥 LOAD PRODUCTS
  Future<void> loadProducts() async {
    try {
      final data = await ApiService.getProducts();

      setState(() {
        allProducts = data;
        filteredProducts = data;
        isLoading = false;
      });
    } catch (e) {
      print("API ERROR: $e");

      /// 🔥 FALLBACK PRODUCTS
      allProducts = [
        Product(
          id: '1',
          name: 'Amber Accord',
          description: 'Warm amber fragrance',
          image:
              'https://images.unsplash.com/photo-1594035910387-fea47794261f',
          price: 1999,
        ),
        Product(
          id: '2',
          name: 'Royal Oud',
          description: 'Luxury oud blend',
          image:
              'https://images.unsplash.com/photo-1615634260167-c8cdede054de',
          price: 2499,
        ),
        Product(
          id: '3',
          name: 'Citrus Bloom',
          description: 'Fresh citrus scent',
          image:
              'https://images.unsplash.com/photo-1502741338009-cac2772e18bc',
          price: 1799,
        ),
        Product(
          id: '4',
          name: 'Midnight Rose',
          description: 'Romantic fragrance',
          image:
              'https://images.unsplash.com/photo-1585386959984-a4155224a1ad',
          price: 3499,
        ),
        Product(
          id: '5',
          name: 'Ocean Breeze',
          description: 'Fresh aquatic scent',
          image:
              'https://images.unsplash.com/photo-1600180758890-6a3f1e7e77b6',
          price: 2199,
        ),
        Product(
          id: '6',
          name: 'Velvet Oud',
          description: 'Premium oud',
          image:
              'https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec',
          price: 2899,
        ),
      ];

      setState(() {
        filteredProducts = allProducts;
        isLoading = false;
      });
    }
  }

  /// 🔍 SEARCH
  void filterSearch(String query) {
    final results = allProducts
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      filteredProducts =
          query.isEmpty ? allProducts : results;
    });
  }

  /// 🎤 VOICE
  void startListening() async {
    bool available = await speech.initialize();
    if (available) {
      setState(() => isListening = true);

      speech.listen(onResult: (result) {
        searchController.text = result.recognizedWords;
        filterSearch(result.recognizedWords);
      });
    }
  }

  void stopListening() {
    speech.stop();
    setState(() => isListening = false);
  }

  /// 📷 CAMERA
  Future<void> openCameraSearch() async {
    final picker = ImagePicker();
    await picker.pickImage(source: ImageSource.camera);

    if (allProducts.isNotEmpty) {
      setState(() {
        filteredProducts = [allProducts.first];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider =
        Provider.of<NotificationProvider>(context);

    /// 🔥 LOADING
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    /// 🔥 MAIN UI (NO SCAFFOLD)
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP BAR
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "FOZI",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F4E3D),
                  ),
                ),
                Stack(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none),
                    ),
                    if (notificationProvider.count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            notificationProvider.count.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 16),

            /// SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: filterSearch,
                      decoration: const InputDecoration(
                        hintText: "Search fragrances...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(isListening
                        ? Icons.mic
                        : Icons.mic_none),
                    onPressed:
                        isListening ? stopListening : startListening,
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    onPressed: openCameraSearch,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// HERO
            if (allProducts.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  allProducts[0].image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 24),

            /// LIMITED OFFERS
            const Text("Limited-Time Offers",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _horizontalList(filteredProducts, context),

            const SizedBox(height: 24),

            /// BEST COMBOS
            const Text("Best Combos",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _horizontalList(allProducts.reversed.toList(), context),

            const SizedBox(height: 24),

            /// GRID
            const Text("In Stock",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allProducts.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 260,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return ProductCard(
                  product: allProducts[index],
                  onAdd: () {
                    Provider.of<CartProvider>(context,
                            listen: false)
                        .addToCart(allProducts[index],
                            quantity: 1);
                  },
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 🔁 LIST
  Widget _horizontalList(List<Product> list, BuildContext context) {
    return SizedBox(
      height: 260,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final product = list[index];

          return ProductCard(
            product: product,
            onAdd: () {
              Provider.of<CartProvider>(context,
                      listen: false)
                  .addToCart(product, quantity: 1);

              ApiService.addToCart(
                userId: "user123",
                productId: product.id,
                quantity: 1,
              );
            },
          );
        },
      ),
    );
  }
}