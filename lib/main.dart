// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/shop_provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(const BeautyHallApp());
}

class BeautyHallApp extends StatelessWidget {
  const BeautyHallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopProvider()..loadProducts(),
      child: MaterialApp(
        title: 'Beauty Hall',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC93D78),
            primary: const Color(0xFFC93D78),
            secondary: const Color(0xFFD4AF37),
            surface: Colors.white,
            error: const Color(0xFFEA4335),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFCF9FA),
          textTheme: GoogleFonts.plusJakartaSansTextTheme(
            ThemeData.light().textTheme,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF1E1B1D)),
            titleTextStyle: GoogleFonts.playfairDisplay(
              color: const Color(0xFF1E1B1D),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        home: const CatalogScreen(),
      ),
    );
  }
}
