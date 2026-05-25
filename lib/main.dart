import 'package:flutter/material.dart';
import 'post.dart';
import 'photos.dart';
import 'package:provider/provider.dart';
import 'providers/post_provider.dart';
import 'providers/photo_provider.dart';


void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => PostProvider(),
        ),
      ChangeNotifierProvider(
        create: (_) => PhotoProvider(),
        ),
    ],
    child: const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pertemuan 8 - Consume API',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: '/',
      routes: {
        '/': (context) => PostPage(),
        '/photos': (context) => PhotoPage(),
      },
      
    
    );
  }
}
