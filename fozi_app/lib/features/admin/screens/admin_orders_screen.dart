import 'package:flutter/material.dart';
import 'package:fozi_mobile_app/core/api/api_service.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {

  List orders = [];
  bool isLoading = true;

  final List<String> statusList = [
    "Processing",
    "Packed",
    "Shipped",
    "Delivered"
  ];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  // ==============================
  // 📦 FETCH ORDERS
  // ==============================
  Future<void> fetchOrders() async {
    try {
      final data = await ApiService.getAdminOrders();

      setState(() {
        orders = data;
        isLoading = false;
      });

    } catch (e) {
      print("ORDER ERROR: $e");
      setState(() => isLoading = false);
    }
  }

  // ==============================
  // 🔄 UPDATE STATUS
  // ==============================
  Future<void> updateStatus(String orderId, String status) async {
    try {
      await ApiService.updateOrderStatus(
        orderId: orderId,
        status: status,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Updated to $status")),
      );

      fetchOrders(); // 🔥 refresh

    } catch (e) {
      print(e);
    }
  }

  // ==============================
  // UI
  // ==============================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Orders"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => isLoading = true);
              fetchOrders();
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("No Orders Found"))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {

                    final o = orders[index];

                    return Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// 🧾 ORDER ID
                            Text(
                              "Order ID: ${o['_id']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 8),

                            /// 👤 USER
                            if (o['userId'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("User: ${o['userId']['name']}"),
                                  Text("Email: ${o['userId']['email']}"),
                                ],
                              ),

                            const SizedBox(height: 8),

                            /// 📦 PRODUCTS
                            const Text(
                              "Products:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            ...o['products'].map<Widget>((p) {
                              return Text(
                                  "- ${p['name']} x${p['quantity']} (₹${p['price']})");
                            }).toList(),

                            const SizedBox(height: 8),

                            /// 💰 TOTAL
                            Text(
                              "Total: ₹${o['totalAmount']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 8),

                            /// 📍 ADDRESS
                            if (o['customerDetails'] != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Name: ${o['customerDetails']['name']}"),
                                  Text("Phone: ${o['customerDetails']['phone']}"),
                                  Text("Address: ${o['customerDetails']['address']}"),
                                ],
                              ),

                            const SizedBox(height: 10),

                            /// 🔄 STATUS DROPDOWN
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Status:"),

                                DropdownButton<String>(
                                  value: statusList.contains(o['status'])
                                      ? o['status']
                                      : "Processing",

                                  items: statusList
                                      .map((s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(s),
                                          ))
                                      .toList(),

                                  onChanged: (value) {
                                    if (value == null) return;

                                    updateStatus(
                                      o['_id'].toString(),
                                      value,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}