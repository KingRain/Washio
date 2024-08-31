import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pages/groundFloor.dart';
import '../pages/secondFloor.dart';
import '../pages/firstFloor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Dev Information',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Developed by Sam Joe in Flutter\n'
            'Instagram: @samjoe.png\n'
            'Github: github.com/KingRain\n'
            'Website: samjoe.tech\n'
            'Support ☕: buymeacoffee.com/samjoe.png',
            style: TextStyle(
              fontFamily: 'JetBrains Mono',
              color: Color.fromARGB(255, 29, 29, 29),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Color.fromARGB(255, 169, 0, 0),
                  fontFamily: 'JetBrains Mono',
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          'Wash.io',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 20,
            fontFamily: 'JetBrains Mono',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/info-icon.svg',
              width: 28,
              height: 28,
              placeholderBuilder: (context) =>
                  const CircularProgressIndicator(),
              color: Colors.white,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              _showInfoDialog(context); // Show the info dialog
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Image.asset(
              'assets/images/main-icon.png',
              width: 200,
              height: 200,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 200,
                );
              },
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'Select your floor',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32,
                        fontFamily: 'JetBrains Mono',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      'Kalapurackal Edition',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 200, 0),
                        fontSize: 16,
                        fontFamily: 'JetBrains Mono',
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FloorZeroPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
              ),
              child: const Text(
                'Ground Floor',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FloorOnePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
              ),
              child: const Text(
                'First Floor',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FloorTwoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
              ),
              child: const Text(
                'Second Floor',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontFamily: 'JetBrains Mono',
                ),
              ),
            ),
            const SizedBox(height: 120),
            const Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'Developed by Sam Joe',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontFamily: 'JetBrains Mono',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      'UI/UX by Basil',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 14,
                        fontFamily: 'JetBrains Mono',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
    );
  }
}
