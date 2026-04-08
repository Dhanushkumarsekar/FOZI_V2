import 'package:flutter/material.dart';
import '../../../core/api/api_service.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {

  Map? order;
  bool isLoading = true;

  final List<String> stages = [
    "Processing",
    "Packed",
    "Shipped",
    "Delivered"
  ];

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    final data = await ApiService.trackOrder(widget.orderId);

    setState(() {
      order = data;
      isLoading = false;
    });
  }

  int getCurrentStep() {
    if (order == null) return 0;
    return stages.indexOf(order!['status']);
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Track Order")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 📊 TIMELINE
            Stepper(
              currentStep: getCurrentStep(),
              controlsBuilder: (_, __) => const SizedBox(),
              steps: stages.map((stage) {
                return Step(
                  title: Text(stage),
                  isActive: true,
                  state: stages.indexOf(stage) <= getCurrentStep()
                      ? StepState.complete
                      : StepState.indexed,
                  content: const SizedBox(),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// 📦 ORDER DETAILS
            Text("Total: ₹${order!['totalAmount']}"),
            Text("Status: ${order!['status']}"),

            const SizedBox(height: 10),

            /// PRODUCTS
            ...order!['products'].map<Widget>((p) {
              return Text("${p['name']} x${p['quantity']}");
            }).toList(),

          ],
        ),
      ),
    );
  }
}