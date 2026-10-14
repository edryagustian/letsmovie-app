import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/film_list_screen.dart';

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
      home: const FilmListScreen(),
    );
  }
}