import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_screen.dart';
import 'cart_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import '../providers/cart_provider.dart';

// Membuat halaman utama dengan bottom navbar
class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Membuat state untuk mengatur perpindahan menu navbar
class _HomePageState extends State<HomePage> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
  }

  // Membuat daftar halaman yang akan ditampilkan
  List<Widget> get pages => [
        const ProductPage(),
        CartPage(onShopNow: () {
          setState(() {
            currentIndex = 0;
          });
        }),
        const OrderScreen(),
        const ProfileScreen(),
      ];

  // Membuat daftar judul appbar sesuai halaman
  final List<String> titles = const [
    'Produk',
    'Keranjang',
    'Pesanan',
    'Profil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (currentIndex == 0 || currentIndex == 3)
          ? null // Sembunyikan AppBar bawaan di halaman Produk & Profil
          : AppBar(
              title: Text(titles[currentIndex]),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 1, 48, 86),
              foregroundColor: Colors.white,
            ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromARGB(255, 1, 48, 86),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        // Mengubah halaman ketika menu navbar diklik
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Produk'),
          BottomNavigationBarItem(
            icon: Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Badge(
                  isLabelVisible: cartProvider.totalItem > 0,
                  label: Text('${cartProvider.totalItem}'),
                  child: const Icon(Icons.shopping_cart),
                );
              },
            ),
            label: 'Keranjang',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pesanan',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
