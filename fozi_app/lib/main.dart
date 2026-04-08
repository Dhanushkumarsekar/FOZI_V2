import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🔔 NOTIFICATIONS
import 'core/services/notification_service.dart';

// PROVIDERS
import 'features/wishlist/providers/wishlist_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/cart/providers/cart_provider.dart';
import 'features/order/providers/order_provider.dart';
import 'features/notifications/providers/notification_provider.dart';

// SCREENS
import 'features/home/screens/home_screen.dart';
import 'features/cart/screens/cart_screen.dart';
import 'features/menu/screens/menu_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 INIT PUSH NOTIFICATIONS
  // await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: const FoziApp(),
    ),
  );
}

// ==============================
// 🚀 MAIN APP
// ==============================

class FoziApp extends StatefulWidget {
  const FoziApp({super.key});

  @override
  State<FoziApp> createState() => _FoziAppState();
}

class _FoziAppState extends State<FoziApp> {

  @override
  void initState() {
    super.initState();

    // 🔥 AUTO LOGIN
    Future.microtask(() {
      Provider.of<AuthProvider>(context, listen: false).autoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FOZI Perfume Store',

      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),

      routes: {
        "/home": (_) => const MainNavigation(),
      },

      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isLoggedIn
              ? const MainNavigation()
              : const LoginScreen();
        },
      ),
    );
  }
}

// ==============================
// 📱 MAIN NAVIGATION
// ==============================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeScreen(),
    MenuScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}