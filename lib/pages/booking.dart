// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:machinex/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String roomNo = '';
  TimeOfDay? startTime;
  TimeOfDay? stopTime;

  Future<void> submitData() async {
    if (startTime == null || stopTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both start and stop times')),
      );
      return;
    }

    final slot = '${startTime!.format(context)}\n${stopTime!.format(context)}';

    final response = await Supabase.instance.client
        .from('floor1')
        .insert({'Name': name, 'RoomNo': roomNo, 'Slot': slot});

    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot booked successfully!')),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to book slot: ${response.error!.message}')),
      );
    }
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your room number';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid room number';
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.white),
                    onPressed: () async {
                      final selectedTime = await _selectTime(context);
                      if (selectedTime != null) {
                        setState(() {
                          startTime = selectedTime;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      startTime != null
                          ? 'Start Time: ${startTime!.format(context)}'
                          : 'Select Start Time',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.access_time, color: Colors.white),
                    onPressed: () async {
                      final selectedTime = await _selectTime(context);
                      if (selectedTime != null) {
                        setState(() {
                          stopTime = selectedTime;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      stopTime != null
                          ? 'Stop Time: ${stopTime!.format(context)}'
                          : 'Select Stop Time',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitData();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
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
