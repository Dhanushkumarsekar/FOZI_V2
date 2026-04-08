import 'package:flutter/material.dart';
import '../../cart/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
  });
}

class OrderProvider extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(List<CartItem> items, double total) {
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: items,
      total: total,
    );

    _orders.insert(0, order);
    notifyListeners();
  }
}
