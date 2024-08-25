// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:machinex/pages/booking.dart';

class FloorZeroPage extends StatelessWidget {
  const FloorZeroPage({super.key});

  Future<List<Map<String, dynamic>>> fetchSupabaseData() async {
    final response = await Supabase.instance.client.from('floor0').select();

    if (response.isEmpty) {
      throw Exception('No data found in Supabase');
    }
    return response;
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
            const SizedBox(height: 20), // Space between the text and table
            Expanded(
              child: FutureBuilder(
                future: fetchSupabaseData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    var data = snapshot.data as List<Map<String, dynamic>>;
                    if (data.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }
                    var columns = data.first.keys.toList();
                    return SingleChildScrollView(
                      child: DataTable(
                        columns: columns.map<DataColumn>((value) {
                          return DataColumn(
                              label: Text(value,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'JetBrains Mono',
                                  )));
                        }).toList(),
                        rows: data.map<DataRow>((row) {
                          return DataRow(
                              cells: columns.map<DataCell>((column) {
                            return DataCell(Text(row[column].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'JetBrains Mono',
                                )));
                          }).toList());
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
