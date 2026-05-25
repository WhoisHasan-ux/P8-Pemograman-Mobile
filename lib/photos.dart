import 'package:flutter/material.dart';
//import baru 
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class PhotoPage extends StatefulWidget {
  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PhotoProvider>().fetchPhotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Foto",
          style: TextStyle(
            color: Colors.white,
            fontWeight: .bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
      ),
      body: Builder(
        builder: (context) {
          final provider = context.watch<PhotoProvider>();

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Text(provider.errorMessage),
            );
          }

          return ListView.builder(
            itemCount: provider.photos.length,
            itemBuilder: (context, index) {
              final photo = provider.photos[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        photo.url,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      //menampilkan nama author foto sesuai dengan indexnya
                      '${index + 1}. ${photo.author}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: .spaceAround,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
            child: Icon(Icons.home),
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/photos');
            },
            child: Icon(Icons.photo),
          ),
        ],
      ),
    );
  }
}
