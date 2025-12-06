import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home_view.dart';
import 'controllers/code_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Code Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF667eea),
          secondary: const Color(0xFF764ba2),
          surface: const Color(0xFF1e293b),
          background: const Color(0xFF0f172a),
          error: const Color(0xFFf5576c),
        ),
        scaffoldBackgroundColor: const Color(0xFF0f172a),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1e293b),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF667eea), width: 2),
          ),
        ),
      ),
      // Initialize the CodeController when app starts
      initialBinding: BindingsBuilder(() {
        Get.put(CodeController());
      }),
      home: const HomeView(),
    );
  }
}
