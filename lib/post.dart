import 'package:flutter/material.dart';
//import baru
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';

class PostPage extends StatefulWidget {
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  

  @override
  void initState() {
    super.initState();
    Future.microtask((){//yang di ubah
      context.read<PostProvider>().fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Postingan",
          style: TextStyle(
            color: Colors.white,
            fontWeight: .bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Builder(//yang di ubah
        builder: (context) {
          //kondisi jika data dalam aplikasi pertama kali di ambil
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

          return ListView.builder(//yang di ubah
            itemCount: provider.posts.length,
            itemBuilder: (context, index) {
              final post = provider.posts[index];
              return Card(
                child: ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  leading: CircleAvatar(
                    child: Text(post.id.toString()),
                  ),
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
