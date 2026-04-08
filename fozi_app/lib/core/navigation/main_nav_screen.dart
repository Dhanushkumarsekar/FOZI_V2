import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/home/screens/home_screen.dart';
import '../../features/menu/screens/menu_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/cart/providers/cart_provider.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const MenuScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },

        // 🎨 STYLE
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,

        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Menu",
          ),

          /// 🔥 CART WITH BADGE
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),

                if (cart.items.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        cart.items.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            label: "Cart",
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}