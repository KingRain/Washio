import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:machinex/pages/booking.dart';
import 'package:machinex/pages/home.dart';

class FloorOnePage extends StatefulWidget {
  const FloorOnePage({super.key});

  @override
  _FloorOnePageState createState() => _FloorOnePageState();
}

class _FloorOnePageState extends State<FloorOnePage> {
  Future<List<Map<String, dynamic>>> fetchSupabaseData() async {
    try {
      final response = await Supabase.instance.client
          .from('floor1')
          .select('Name, Slot, Status');

      if (response.isEmpty) {
        throw Exception('No data found in Supabase');
      }

      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(response);

      final DateFormat timeFormat = DateFormat('HH:mm');

      data.sort((a, b) {
        try {
          DateTime startTimeA =
              timeFormat.parse(a['Slot'].toString().split('\n').first);
          DateTime startTimeB =
              timeFormat.parse(b['Slot'].toString().split('\n').first);
          return startTimeA.compareTo(startTimeB);
        } catch (e) {
          // Handle any parsing errors, default to no change in order
          print('Error parsing slot times: $e');
          return 0;
        }
      });

      return data;
    } catch (e) {
      // Handle errors that occurred during the request or processing
      print('Error fetching data: $e');
      throw Exception('Failed to fetch data from Supabase');
    }
  }

  Future<void> updateStatusBasedOnTime() async {
    final data = await fetchSupabaseData();
    final DateTime now = DateTime
        .now(); //Returns current date and time like 2021-10-10 09:00:00.000
    final DateFormat timeFormat = DateFormat('HH:mm');

    for (var row in data) {
      String slot = row['Slot'].toString();
      String currentStatus = row['Status'].toString();

      try {
        List<String> slotTimes = slot.split('\n').map((e) {
          return e.split(' ').first;
        }).toList(); //Returns data like ['09:00', '10:00']

        if (slotTimes.length == 2) {
          DateTime startTime =
              timeFormat.parse(slotTimes[0]); //Returns data like 09:00 PM
          DateTime endTime =
              timeFormat.parse(slotTimes[1]); //Returns data like 10:00 PM

          // Adjusting to current date
          startTime = DateTime(now.year, now.month, now.day, startTime.hour,
              startTime.minute); //Returns data like 2021-10-10 09:00:00.000
          endTime = DateTime(now.year, now.month, now.day, endTime.hour,
              endTime.minute); //Returns data like 2021-10-10 10:00:00.000

          String newStatus;

          if (now.isAfter(endTime)) {
            newStatus = 'Finished';
          }
          if (now.isAfter(startTime) && now.isBefore(endTime)) {
            newStatus = 'Active';
          } else if (now.isBefore(startTime) && currentStatus == 'Active') {
            newStatus = 'Pending';
          } else {
            newStatus = currentStatus; // No change
          }

          // Update status in Supabase if it has changed
          if (newStatus != currentStatus) {
            await Supabase.instance.client
                .from('floor1')
                .update({'Status': newStatus}).eq('Name', row['Name']);
          }
        }
      } catch (e) {
        // Handle any parsing errors
        print('Error parsing slot times: $e');
      }
    }

    // Refresh the UI by fetching the updated data
    setState(() {});
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Floor 1',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () async {
              await updateStatusBasedOnTime();
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
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchSupabaseData(),
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
                            label:
                                Text(column.replaceAll('_', ' ').toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JetBrains Mono',
                                    )),
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
            MaterialPageRoute(builder: (context) => const BookingPage()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
