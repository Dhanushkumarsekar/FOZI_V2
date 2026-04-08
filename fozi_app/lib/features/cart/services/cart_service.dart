import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) => sum + item.total,
    );
  }

  void addToCart({
    required String id,
    required String title,
    required String image,
    required double price,
  }) {
    final index = _items.indexWhere((item) => item.id == id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItem(
          id: id,
          title: title,
          image: image,
          price: price,
        ),
      );
    }

    notifyListeners();
  }

  void increaseQty(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    _items[index].quantity++;
    notifyListeners();
  }

  void decreaseQty(String id) {
    final index = _items.indexWhere((item) => item.id == id);

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }
}
