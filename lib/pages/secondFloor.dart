// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:washio/pages/booking_two.dart';
import 'package:washio/pages/booking_two_next.dart';
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
      await Supabase.instance.client
          .from('floor1')
          .update({'CurrentDay': "True"}).eq('Name', row['Name']);

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

  Future<List<Map<String, dynamic>>> fetchSupabaseData2() async {
    final response = await Supabase.instance.client
        .from('floor2_nextday')
        .select('Name, Slot, Status')
        .order('Slot', ascending: true);

    if (response.isEmpty) {
      throw Exception('No data found in Supabase');
    }
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> updateStatusAndFetchData2() async {
    final data = await fetchSupabaseData2();
    final DateTime now = DateTime.now();
    final DateFormat timeFormat = DateFormat('HH:mm');

    for (var row in data) {
      String slot = row['Slot'].toString();
      String currentStatus = row['Status'].toString();

      try {
        List<String> slotTimes = slot.split('-');

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
            await Supabase.instance.client.from('floor1_nextday');
            //.update({'Status': newStatus}).eq('Name', row['Name']);
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

  String getNextDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(now.add(const Duration(days: 1)));
  }

  bool isNextDay = false;
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
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              setState(() {
                if (isNextDay) {
                  futureData = updateStatusAndFetchData2();
                } else {
                  futureData = updateStatusAndFetchData();
                }
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Green spotlight added to bottom-left corner
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: 700,
              width: 700,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 1.0,
                  colors: [
                    const Color.fromARGB(255, 0, 255, 8).withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${isNextDay ? getNextDate() : getCurrentDate()}\nSlots',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: Color.fromRGBO(0, 255, 8, 1),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'Refresh the page for updating the list',
                  style: TextStyle(
                    color: Color.fromARGB(255, 109, 109, 109),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  //create a button to switch to next day,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color.fromRGBO(0, 255, 8, 1), width: 1),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildButton('Today', !isNextDay, () {
                          setState(() {
                            isNextDay = false;
                            if (isNextDay) {
                              futureData = updateStatusAndFetchData2();
                            } else {
                              futureData = updateStatusAndFetchData();
                            }
                          });
                        }),
                        buildButton('Tomorrow', isNextDay, () {
                          setState(() {
                            isNextDay = true;
                            if (isNextDay) {
                              futureData = updateStatusAndFetchData2();
                            } else {
                              futureData = updateStatusAndFetchData();
                            }
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        isNextDay = false;
                        if (isNextDay) {
                          futureData = updateStatusAndFetchData2();
                        } else {
                          futureData = updateStatusAndFetchData();
                        }
                      });
                    },
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          var data = snapshot.data!;
                          if (data.isEmpty) {
                            return const Center(child: Text('No data found'));
                          }

                          return SingleChildScrollView(
                            child: Column(
                              children: data.map((row) {
                                String status = row['Status'].toString();
                                Color statusColor;

                                if (status == 'Active') {
                                  statusColor = Colors.green;
                                } else if (status == 'Finished') {
                                  statusColor = Colors.grey;
                                } else {
                                  statusColor = Colors.red;
                                }

                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 0),
                                  leading: Text(
                                    row['Name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        row['Slot'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: statusColor,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(
          side: BorderSide(color: Color.fromARGB(255, 0, 255, 8), width: 1),
        ),
        onPressed: () {
          if (isNextDay) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const BookingPageTwoNext()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingPageTwo()),
            );
          }
        },
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildButton(String text, bool isSelected, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        decoration: BoxDecoration(
          color:
              isSelected ? const Color.fromARGB(255, 0, 255, 8) : Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
