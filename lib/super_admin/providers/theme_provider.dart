import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData get lightTheme {
    const seed = Color(0xFF0E8F4A);
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Quicksand',
      colorScheme: ColorScheme.fromSeed(seedColor: seed),
      scaffoldBackgroundColor: const Color(0xFFF7F9F7),
      appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
    );
  }
}
