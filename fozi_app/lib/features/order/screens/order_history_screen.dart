import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/api/api_service.dart';
import '../../../core/services/pdf_service.dart';
import '../../../features/auth/providers/auth_provider.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState
    extends State<OrderHistoryScreen> {

  late Future<List<dynamic>> orders;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  // ==============================
  // 📦 LOAD ORDERS
  // ==============================
  void loadOrders() {
    final userId = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).userId;

    orders = ApiService.getOrders(userId ?? "");
  }

  // ==============================
  // 🎨 STATUS COLOR
  // ==============================
  Color getStatusColor(String status) {
    switch (status) {
      case "Delivered":
        return Colors.green;
      case "Shipped":
        return Colors.blue;
      case "Packed":
        return Colors.orange;
      case "Processing":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  // ==============================
  // 🔄 REFRESH
  // ==============================
  Future<void> refresh() async {
    setState(() {
      loadOrders();
    });
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),

      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<List<dynamic>>(
          future: orders,
          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}"));
            }

            if (!snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return const Center(
                  child: Text("No Orders Yet"));
            }

            final data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {

                final order = data[index];

                return Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// ORDER ID
                      Text(
                        "Order #${order['_id']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// TOTAL
                      Text(
                        "Total: ₹${order['totalAmount']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// STATUS
                      Row(
                        children: [
                          const Text("Status: "),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                      order['status'])
                                  .withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: Text(
                              order['status'],
                              style: TextStyle(
                                color: getStatusColor(
                                    order['status']),
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// 📦 PRODUCTS
                      const Text(
                        "Products:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),

                      ...order['products']
                          .map<Widget>((p) {
                        return Text(
                          "- ${p['name']} x${p['quantity']}",
                        );
                      }).toList(),

                      const SizedBox(height: 10),

                      /// 🔘 ACTION BUTTONS
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          /// 📍 TRACK ORDER
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OrderTrackingScreen(
                                    orderId:
                                        order['_id'],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.local_shipping),
                            label: const Text("Track"),
                          ),

                          /// 📄 DOWNLOAD PDF
                          ElevatedButton.icon(
                            onPressed: () {
                              PdfService
                                  .generateInvoice(order);
                            },
                            icon: const Icon(Icons.picture_as_pdf),
                            label: const Text("Invoice"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}