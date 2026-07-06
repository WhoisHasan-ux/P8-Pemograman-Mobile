import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/home_header.dart';
import 'product_detail_screen.dart';

// Membuat halaman produk
class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

// Membuat state untuk halaman produk
class _ProductPageState extends State<ProductPage> {
  final searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        Provider.of<ProductProvider>(context, listen: false).loadMoreProducts();
      }
    });

    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).getInitialData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Membuat format harga Rupiah
  String formatRupiah(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Column(
      children: [
        // 1. Header (Tetap diam / fixed di atas)
        const HomeHeader(),
        
        // 2. Area yang bisa discroll (Search, Filter, dan Produk)
        Expanded(
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [

        // 2. Search, Filter, dan Sorting (Ikut di-scroll)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Membuat search produk
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              searchController.clear();
                              productProvider.setSearch('');
                              setState(() {});
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    productProvider.setSearch(value);
                  },
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    // Membuat filter kategori
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: productProvider.selectedCategory.isEmpty
                            ? ''
                            : productProvider.selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem(value: '', child: Text('Semua')),
                          ...productProvider.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(
                                category.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          productProvider.setCategory(value ?? '');
                        },
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Membuat sorting produk
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: productProvider.selectedSort.isEmpty
                            ? ''
                            : productProvider.selectedSort,
                        decoration: const InputDecoration(
                          labelText: 'Urutkan',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Default')),
                          DropdownMenuItem(
                            value: 'price_asc',
                            child: Text('Termurah'),
                          ),
                          DropdownMenuItem(
                            value: 'price_desc',
                            child: Text('Termahal'),
                          ),
                          DropdownMenuItem(
                            value: 'newest',
                            child: Text('Terbaru'),
                          ),
                        ],
                        onChanged: (value) {
                          productProvider.setSort(value ?? '');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 3. Area Produk (Loading / Error / Empty / Grid)
        if (productProvider.isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (productProvider.errorMessage != null)
          SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  productProvider.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        else if (productProvider.products.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('Produk tidak ditemukan')),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                // Rasio ideal agar tidak kepanjangan ke bawah
                childAspectRatio: 0.72,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = productProvider.products[index];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    clipBehavior: Clip.antiAlias, // Lengkungan mulus otomatis
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                              product: product,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded agar gambar mengisi sisa ruang tanpa error
                          Expanded(
                            child: product.imageUrl.isNotEmpty
                                ? Image.network(
                                    product.imageUrl,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),

                          // Teks produk dibuat compact
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product.categoryName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  formatRupiah(product.price),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 1, 48, 86),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Stok: ${product.stock}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: productProvider.products.length,
              ),
            ),
          ),
          
        if (productProvider.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
            ], // Menutup slivers array
          ), // Menutup CustomScrollView
        ), // Menutup Expanded
      ], // Menutup children Column
    ); // Menutup Column
  }
}
