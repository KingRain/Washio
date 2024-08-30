// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:washio/pages/booking_one.dart';
import 'package:washio/pages/booking_two.dart';
import 'package:washio/pages/home.dart';

class FloorTwoPage extends StatefulWidget {
  const FloorTwoPage({super.key});

  @override
  _FloorTwoPageState createState() => _FloorTwoPageState();
}

class _FloorTwoPageState extends State<FloorTwoPage> {
  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = updateStatusAndFetchData();
  }

  Future<List<Map<String, dynamic>>> fetchSupabaseData() async {
    final response = await Supabase.instance.client
        .from('floor2')
        .select('Name, Slot, Status')
        .order('Slot', ascending: true);

    if (response.isEmpty) {
      throw Exception('No data found in Supabase');
    }
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> updateStatusAndFetchData() async {
    final data = await fetchSupabaseData();
    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat('HH:mm');

    for (var row in data) {
      String slot = row['Slot'].toString();
      String currentStatus = row['Status'].toString();

      try {
        List<String> slotTimes = slot.split('\n');

        if (slotTimes.length == 2) {
          DateTime startTime = timeFormat.parse(slotTimes[0]);
          DateTime endTime = timeFormat.parse(slotTimes[1]);

          // Adjusting to current date
          startTime = DateTime(
              now.year, now.month, now.day, startTime.hour, startTime.minute);
          endTime = DateTime(
              now.year, now.month, now.day, endTime.hour, endTime.minute);

          String newStatus;

          if (now.isAfter(endTime)) {
            newStatus = 'Finished';
          } else if (now.isAfter(startTime) && now.isBefore(endTime)) {
            newStatus = 'Active';
          } else if (now.isBefore(startTime)) {
            newStatus = 'Pending';
          } else {
            newStatus = currentStatus; // No change
          }

          // Update status in Supabase if it has changed
          if (newStatus != currentStatus) {
            await Supabase.instance.client
                .from('floor2')
                .update({'Status': newStatus}).eq('Name', row['Name']);
          }
        }
      } catch (e) {
        //print('Error parsing slot times: $e');
      }
    }

    return data;
  }

  bool isSlotOverlap(DateTime newStartTime, DateTime newEndTime,
      List<Map<String, dynamic>> existingData) {
    final DateFormat timeFormat = DateFormat('HH:mm');

    for (var row in existingData) {
      List<String> slotTimes = row['Slot'].toString().split('\n');
      if (slotTimes.length == 2) {
        DateTime existingStartTime = timeFormat.parse(slotTimes[0]);
        DateTime existingEndTime = timeFormat.parse(slotTimes[1]);

        // Adjusting to current date
        existingStartTime = DateTime(newStartTime.year, newStartTime.month,
            newStartTime.day, existingStartTime.hour, existingStartTime.minute);
        existingEndTime = DateTime(newEndTime.year, newEndTime.month,
            newEndTime.day, existingEndTime.hour, existingEndTime.minute);

        if (newStartTime.isBefore(existingEndTime) &&
            newEndTime.isAfter(existingStartTime)) {
          return true; // Overlap detected
        }
      }
    }
    return false; // No overlap
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
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
        title: const Text(
          'Second Floor Slot Booking',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 16,
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                futureData = updateStatusAndFetchData();
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              '${getCurrentDate()} Slots',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'JetBrains Mono',
              ),
            ),
            const Text(
              'Refresh the page for updating the list',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                fontFamily: 'JetBrains Mono',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var data = snapshot.data!;
                    if (data.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }

                    var columns = ['Name', 'Slot', 'Status'];

                    return SingleChildScrollView(
                      child: DataTable(
                        columns: columns.map<DataColumn>((column) {
                          return DataColumn(
                            label: Text(
                              column.replaceAll('_', ' ').toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JetBrains Mono',
                              ),
                            ),
                          );
                        }).toList(),
                        rows: data.map<DataRow>((row) {
                          return DataRow(
                            cells: columns.map<DataCell>((column) {
                              String displayText = row[column].toString();
                              TextStyle textStyle = const TextStyle(
                                color: Colors.white,
                                fontFamily: 'JetBrains Mono',
                              );

                              if (column == 'Status' &&
                                  row['Status'] == 'Active') {
                                textStyle =
                                    textStyle.copyWith(color: Colors.green);
                              }

                              if (column == 'Status' &&
                                  row['Status'] == 'Finished') {
                                textStyle = textStyle.copyWith(
                                    color:
                                        const Color.fromARGB(255, 66, 66, 66));
                              }

                              if (column == 'Status' &&
                                  row['Status'] == 'Pending') {
                                textStyle =
                                    textStyle.copyWith(color: Colors.red);
                              }

                              return DataCell(
                                  Text(displayText, style: textStyle));
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingPageTwo()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
