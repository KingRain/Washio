import 'package:flutter/material.dart';
import 'package:washio/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized before making async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await Supabase.initialize(
      url: 'https://dszccundlyavftavfljq.supabase.co',
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
