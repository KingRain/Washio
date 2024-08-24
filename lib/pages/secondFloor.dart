import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FloorTwoPage extends StatelessWidget {
  const FloorTwoPage({super.key});

  final String spreadsheetId = '1puVRlVbGyoUIv6qGVn7Bm2bDIzGpPNYYsEJKdMfkhB4';
  final String sheetName = 'Floor2';
  final String range = 'A1:D80';
  final String apiKey = 'AIzaSyBmsowEETwL5TGyGdtHbXuw-IiqR1cI98E';

  Future<List<List<String>>> fetchSheetData() async {
    final url =
        'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$sheetName!$range?key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final values = json['values'] as List<dynamic>;
      return values.map((row) => List<String>.from(row)).toList();
    } else {
      throw Exception('Failed to load Google Sheets data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floor 2',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
      ),
      body: FutureBuilder(
        future: fetchSheetData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var data = snapshot.data as List<List<String>>;
            return SingleChildScrollView(
              child: DataTable(
                columns: data[0].map<DataColumn>((value) {
                  return DataColumn(
                      label: Text(value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )));
                }).toList(),
                rows: data.skip(1).map<DataRow>((row) {
                  return DataRow(
                      cells: row.map<DataCell>((cell) {
                    return DataCell(Text(cell,
                        style: const TextStyle(color: Colors.white)));
                  }).toList());
                }).toList(),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
    );
  }
}
