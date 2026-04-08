import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/api/api_service.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() =>
      _AdminStatsScreenState();
}

class _AdminStatsScreenState
    extends State<AdminStatsScreen> {

  Map? stats;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final data = await ApiService.getStats();

    setState(() {
      stats = data;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (stats == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Analytics")),

      body: Column(
        children: [

          Text("Revenue: ₹${stats!['totalRevenue']}"),
          Text("Orders: ${stats!['totalOrders']}"),

          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(1, 1000),
                      FlSpot(2, 2000),
                      FlSpot(3, 3000),
                      FlSpot(4, 2500),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}