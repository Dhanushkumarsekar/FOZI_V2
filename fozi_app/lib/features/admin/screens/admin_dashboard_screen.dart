import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';
import '../screens/admin_orders_screen.dart';
import '../../product/screens/add_product_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  Map<String, dynamic> stats = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final data = await ApiService.getStats();

      setState(() {
        stats = data;
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
      appBar: AppBar(title: const Text("Admin Dashboard")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// STATS
            Row(
              children: [
                Expanded(child: _card("Users", stats['users'], Icons.people)),
                const SizedBox(width: 10),
                Expanded(child: _card("Orders", stats['orders'], Icons.shopping_cart)),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: _card("Products", stats['products'], Icons.inventory)),
                const SizedBox(width: 10),
                Expanded(child: _card("Revenue", "₹${stats['revenue']}", Icons.currency_rupee)),
              ],
            ),

            const SizedBox(height: 20),

            /// ACTIONS
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AdminOrdersScreen()));
              },
              child: const Text("📦 View Orders"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AddProductScreen()));
              },
              child: const Text("➕ Add Product"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, dynamic value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon),
          Text(title),
          Text("$value", style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}