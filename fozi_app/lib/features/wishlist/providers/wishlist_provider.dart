import 'package:flutter/material.dart';
import '../../product/models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _wishlist = [];

  List<Product> get items => _wishlist;

  bool isInWishlist(Product product) {
    return _wishlist.any((p) => p.id == product.id);
  }

  void toggleWishlist(Product product) {
    if (isInWishlist(product)) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }
}
