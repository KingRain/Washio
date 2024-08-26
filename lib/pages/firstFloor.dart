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
    final response = await Supabase.instance.client
        .from('floor1')
        .select('Name, Slot, Status')
        .order('Slot', ascending: true);

    if (response.isEmpty) {
      throw Exception('No data found in Supabase');
    }
    return response;
  }

  Future<void> updateStatusBasedOnTime() async {
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
