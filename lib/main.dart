import 'package:flutter/material.dart';
import 'package:washio/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before making async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url:
          'https://dszccundlyavftavfljq.supabase.co', // Replace with your Supabase URL
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRzemNjdW5kbHlhdmZ0YXZmbGpxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ1OTg1MzAsImV4cCI6MjA0MDE3NDUzMH0.KNYjh3Lf667cZzgU11ACDIfztwZ3PYcokwOE3hwIqZ8', // Replace with your Supabase anonymous key
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
