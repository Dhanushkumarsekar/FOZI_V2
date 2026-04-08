// App Routes
import 'package:flutter/material.dart';
import '../features/home/screens/home_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/checkout/screens/checkout_screen.dart';

class AppRoutes {
  static const home = "/";
  static const login = "/login";
  static const cart = "/cart";
  static const checkout = "/checkout";

  static Map<String, WidgetBuilder> routes = {
    home: (_) => const HomeScreen(),
    login: (_) => const LoginScreen(),
    cart: (_) => const CartScreen(),
    checkout: (_) => const CheckoutScreen(),
  };
}
