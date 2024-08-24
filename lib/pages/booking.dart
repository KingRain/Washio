import 'package:flutter/material.dart';
import 'package:machinex/pages/firstfloor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String roomNo = '';
  String slot = '';

  final String spreadsheetId = '1puVRlVbGyoUIv6qGVn7Bm2bDIzGpPNYYsEJKdMfkhB4';
  final String sheetName = 'Floor1';
  final String apiKey = 'AIzaSyBmsowEETwL5TGyGdtHbXuw-IiqR1cI98E';

  Future<void> submitData() async {
    final url =
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!A:D:append?valueInputOption=USER_ENTERED&key=$apiKey';

    final Map<String, dynamic> body = {
      "values": [
        [name, roomNo, slot]
      ]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot booked successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book slot: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book a Slot',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JetBrains Mono',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Room No.',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JetBrains Mono',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your room number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    roomNo = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Slot',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JetBrains Mono',
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the desired slot';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    slot = value;
                  });
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FloorOnePage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'JetBrains Mono',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
    );
  }
}
