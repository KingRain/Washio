import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:machinex/pages/groundfloor.dart';
import 'package:machinex/pages/secondfloor.dart';
import 'firstfloor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wash.io',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
              fontFamily: 'JetBrains Mono',
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 64, 64, 64),
        leading: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(0, 255, 255, 255),
          ),
          child: SvgPicture.asset(
            '../assets/icons/HomeIcon.svg',
            width: 16,
            height: 16,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Image.asset(
              '../assets/images/main-icon.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 10),
            const Text('Select the floor',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 32,
                  fontFamily: 'JetBrains Mono',
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FloorZeroPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
              ),
              child: const Text('Ground Floor',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontFamily: 'JetBrains Mono',
                  )),
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
              child: const Text('First Floor',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontFamily: 'JetBrains Mono',
                  )),
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
              child: const Text('Second Floor',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontFamily: 'JetBrains Mono',
                  )),
            ),
            const SizedBox(height: 150),
            const Text('Powered by Wash.io',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 16,
                  fontFamily: 'JetBrains Mono',
                )),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 29, 29, 29), // Add this line
    );
  }
}
