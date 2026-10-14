import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LetsMovie',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: Scaffold(
        appBar: AppBar(title: const Text('LetsMovie')),
        body: const Center(child: Text('LetsMovie')),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}