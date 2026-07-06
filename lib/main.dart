import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/login_providers.dart';
import 'providers/product_provider.dart';
import 'providers/review_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/checkout_provider.dart';
import 'providers/order_provider.dart';
import 'providers/profile_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Mendaftarkan AuthProvider untuk login, auto-login, logout, dan data user
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..checkLogin(),
        ),

        // Mendaftarkan ProductProvider untuk produk, kategori, search, filter, dan sorting
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),

        // Mendaftarkan ReviewProvider untuk ulasan produk
        ChangeNotifierProvider(
          create: (_) => ReviewProvider(),
        ),

        // Mendaftarkan CartProvider untuk keranjang belanja
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),

        // Mendaftarkan CheckoutProvider untuk checkout
        ChangeNotifierProvider(
          create: (_) => CheckoutProvider(),
        ),

        // Mendaftarkan OrderProvider untuk riwayat pesanan
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),

        // Mendaftarkan ProfileProvider untuk profil
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// Membuat class utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Membuat tampilan utama aplikasi
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uas 2306079',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 1, 48, 86),
        ),
        useMaterial3: true,
      ),

      // Menentukan halaman awal berdasarkan status login
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isLogin) {
            return const HomePage();
          }

          return const LoginPage();
        },
      ),

      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}