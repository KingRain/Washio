// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:washio/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingPageTwo extends StatefulWidget {
  const BookingPageTwo({super.key});

  @override
  _BookingPageTwoState createState() => _BookingPageTwoState();
}

class _BookingPageTwoState extends State<BookingPageTwo> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String roomNo = '';
  TimeOfDay? startTime;
  TimeOfDay? stopTime;

  Future<void> submitData() async {
    if ((startTime == null || stopTime == null) ||
        (startTime == null && stopTime == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both start and stop times')),
      );
      return;
    } else if (startTime!.hour == stopTime!.hour &&
        startTime!.minute == stopTime!.minute) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Start and stop times cannot be the same!')),
      );
      return;
    } else if (startTime!.hour > stopTime!.hour) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Start time cannot be greater than stop time!')),
      );
      return;
    }

    // Format the start and stop times in 24-hour format
    final formattedStartTime =
        '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
    final formattedStopTime =
        '${stopTime!.hour.toString().padLeft(2, '0')}:${stopTime!.minute.toString().padLeft(2, '0')}';

    final int selectedStartTimeInMinutes =
        startTime!.hour * 60 + startTime!.minute;
    final int selectedStopTimeInMinutes =
        stopTime!.hour * 60 + stopTime!.minute;

    // Check if the slot already exists
    final existingSlots =
        await Supabase.instance.client.from('floor2').select('Slot');
    /*
    if (existingSlots.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This slot is already taken!')),
      );
      return;
    }
    */

    for (final slot in existingSlots) {
      final List<String> times =
          (slot['Slot'] as String).split('\n'); // Returns time like 9:00\n9:30
      final start = times[0]; //Returns time like 9:00
      final stop = times[1]; // Returns time like 9:30

      // Convert existing slot times to minutes since midnight
      final int existingStartTimeInMinutes =
          int.parse(start.split(':')[0]) * 60 +
              int.parse(start.split(':')[1]); //Returns time like 9:00 as 540
      final int existingStopTimeInMinutes = int.parse(stop.split(':')[0]) * 60 +
          int.parse(stop.split(':')[1]); //Returns time like 9:30 like 570

      // Check if the selected slot overlaps with any existing slot

      if ((selectedStartTimeInMinutes >= existingStartTimeInMinutes &&
              selectedStartTimeInMinutes < existingStopTimeInMinutes) ||
          (selectedStopTimeInMinutes > existingStartTimeInMinutes &&
              selectedStopTimeInMinutes <= existingStopTimeInMinutes) ||
          (selectedStartTimeInMinutes < existingStartTimeInMinutes &&
              selectedStopTimeInMinutes > existingStopTimeInMinutes)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('This slot intersects with an existing slot!')),
        );
        return;
      }
    }

    final slot = '$formattedStartTime\n$formattedStopTime';
    final response = await Supabase.instance.client.from('floor2').insert({
      'Name': "$name ($roomNo)",
      'RoomNo': roomNo,
      'Slot': slot,
      'CurrentDay': "True"
    });

    //Todo: fix error checking
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot booked successfully!')),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to book slot!')),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
      resizeToAvoidBottomInset: true,
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
                    borderSide: BorderSide(color: Colors.indigo),
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
                    borderSide: BorderSide(color: Colors.indigo),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your room number';
                  }
                  if (int.tryParse(value) == null ||
                      int.tryParse(value)!.toString().length > 2) {
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a valid time!'),
                          ),
                        );
                      }
                    },
                  ),
                  Expanded(
                    child: Text(
                      startTime != null
                          ? 'Start Time: ${startTime!.format(context)}'
                          : 'Select Start Time',
                      style: const TextStyle(color: Colors.white),
                      //Check if time is selected
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
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a valid time!'),
                          ),
                        );
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
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  fixedSize: const Size(200, 50),
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
