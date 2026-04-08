import 'package:flutter/material.dart';

import '../../product/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get total => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalAmount =>
      _items.fold(0, (sum, item) => sum + item.total);

  void addToCart(Product product, {int quantity = 1}) {
    final index =
        _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(product: product, quantity: quantity),
      );
    }

    notifyListeners();
  }

  void increaseQty(String productId) {
    final index =
        _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQty(String productId) {
    final index =
        _items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
