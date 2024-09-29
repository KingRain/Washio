import 'package:flutter/material.dart';
import 'package:washio/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before making async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://xyz.supabase.co/', // Replace with your Supabase URL
      anonKey: 'xyz', // Replace with your Supabase anonymous key
    );
  } catch (e) {
    // Handle initialization error
    //print('Failed to initialize Supabase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Washio',
      theme: ThemeData(
        primarySwatch: Colors.green, // Set primary swatch to green
        primaryColor: Colors.green, // Change primary color
        hintColor:
            const Color.fromARGB(255, 255, 255, 255), // Change accent color
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.green, // Change loading circle color
        ),
        colorScheme:
            ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
          secondary: Colors.green, // Change secondary color
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none, // Remove border of TextField
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.white, // Change cursor color
          selectionColor: Colors.white, // Change selection color
          selectionHandleColor: Colors.white, // Change selection handle color
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
