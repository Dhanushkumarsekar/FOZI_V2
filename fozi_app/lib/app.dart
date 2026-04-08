import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/navigation/main_nav_screen.dart';

import 'features/auth/screens/login_screen.dart';

import 'features/cart/providers/cart_provider.dart';
import 'features/order/providers/order_provider.dart';

import 'features/checkout/screens/checkout_screen.dart';
import 'features/order/screens/order_history_screen.dart';
import 'features/wishlist/providers/wishlist_provider.dart';
import 'features/notifications/providers/notification_provider.dart';

class FoziApp extends StatelessWidget {
  const FoziApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        /// ✅ CART PROVIDER
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),

        /// ✅ WISHLIST PROVIDER
        ChangeNotifierProvider<WishlistProvider>(
          create: (_) => WishlistProvider(),
        ),

        /// ✅ NOTIFICATION PROVIDER
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),

        /// ✅ ORDER PROVIDER
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "FOZI",

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F2EE),
          colorSchemeSeed: const Color(0xFF1F4E3D),
        ),

        /// 🔥 MAIN ENTRY
        home: const MainNavScreen(),

        /// NAMED ROUTES
        routes: {
          '/login': (context) => const LoginScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/orders': (context) => const OrderHistoryScreen(),
        },
      ),
    );
  }
}
