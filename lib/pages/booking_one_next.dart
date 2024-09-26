// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:washio/pages/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingPageOneNext extends StatefulWidget {
  const BookingPageOneNext({super.key});

  @override
  _BookingPageOneNextState createState() => _BookingPageOneNextState();
}

class _BookingPageOneNextState extends State<BookingPageOneNext> {
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
        await Supabase.instance.client.from('floor1_nextday').select('Slot');
    /*
    if (existingSlots.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This slot is already taken!')),
      );
      return;
    }
    */

    final now = TimeOfDay.now();
    final int nowInMinutes = now.hour * 60 + now.minute;

    // Check if the total time selected is less than or equal to 1 hour
    if (selectedStopTimeInMinutes - selectedStartTimeInMinutes > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Total time selected should be 1 hour or less!')),
      );
      return;
    }

    // Check if the finish time is before the start time
    if (selectedStopTimeInMinutes <= selectedStartTimeInMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Finish time should be after start time!')),
      );
      return;
    }

    // Check if the start and stop times are before the current time
    if (selectedStartTimeInMinutes < nowInMinutes ||
        selectedStopTimeInMinutes < nowInMinutes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Start and stop times should not be before the current time!')),
      );
      return;
    }

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
    final response = await Supabase.instance.client
        .from('floor1_nextday')
        .insert({
      'Name': "$name ($roomNo)",
      'RoomNo': roomNo,
      'Slot': slot,
      'CurrentDay': "False"
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
    final currentDate = DateFormat('d MMMM yyyy')
        .format(DateTime.now().add(const Duration(days: 1)));

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.bottomLeft,
          radius: 1.3,
          colors: [
            const Color.fromARGB(255, 0, 255, 8).withOpacity(0.5),
            Colors.transparent,
          ],
          stops: const [0.0, 1.0],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          title: const Text(
            'First floor booking',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                setState(() {
                  name = '';
                  roomNo = '';
                  startTime = null;
                  stopTime = null;
                });
                _formKey.currentState?.reset();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Date Display
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color.fromARGB(255, 0, 255, 8)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    currentDate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 20,
                    ),
                  ),
                ),
                // Name Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle:
                        TextStyle(color: Colors.white, fontFamily: 'Inter'),
                    filled: true,
                    fillColor: Color.fromRGBO(0, 0, 0, 0.8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(100, 255, 255, 255))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(100, 255, 255, 255))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 255, 8))),
                  ),
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                  onChanged: (value) => setState(() => name = value),
                ),
                const SizedBox(height: 16.0),
                // Room Field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Room',
                    labelStyle:
                        TextStyle(color: Colors.white, fontFamily: 'Inter'),
                    filled: true,
                    fillColor: Color.fromRGBO(0, 0, 0, 0.8),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(100, 255, 255, 255))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                            color: Color.fromARGB(100, 255, 255, 255))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 255, 8))),
                  ),
                  style:
                      const TextStyle(color: Colors.white, fontFamily: 'Inter'),
                  onChanged: (value) => setState(() => roomNo = value),
                ),
                const SizedBox(height: 16.0),
                // Time Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final selectedTime = await _selectTime(context);
                          if (selectedTime != null) {
                            setState(() {
                              startTime = selectedTime;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(100, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            startTime != null
                                ? 'From: ${startTime!.format(context)}'
                                : 'From',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Inter'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final selectedTime = await _selectTime(context);
                          if (selectedTime != null) {
                            setState(() {
                              stopTime = selectedTime;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.8),
                            border: Border.all(
                                color:
                                    const Color.fromARGB(100, 255, 255, 255)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            stopTime != null
                                ? 'To: ${stopTime!.format(context)}'
                                : 'To',
                            style: const TextStyle(
                                color: Colors.white, fontFamily: 'Inter'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitData();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(
                          color: Color.fromARGB(
                              100, 255, 255, 255)), // White border
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
