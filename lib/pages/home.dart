import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../pages/groundFloor.dart';
import '../pages/secondFloor.dart';
import '../pages/firstFloor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Green Spotlight (Gradient)
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 700,
              width: 700,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topLeft,
                  radius: 1.0,
                  colors: [
                    const Color.fromARGB(255, 0, 255, 8).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Title and Info Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wash.io',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showInfoDialog(context); // Function to show dialog
                        },
                        child: SvgPicture.asset(
                          'assets/icons/info-icon.svg', // Replace with your actual SVG file path
                          height: 28,
                          width: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // Washing Machine Icon
                  Center(
                    child: SlideTransition(
                      position: _animation,
                      child: Image.asset(
                        'assets/images/main-icon.png', // Replace with your actual image path
                        height: 220,
                        width: 220,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  // "Select your Floor" Text (Left-aligned with green period)
                  Center(
                    child: RichText(
                      textAlign: TextAlign.left,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 42,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        children: [
                          TextSpan(text: 'Select your\n'),
                          TextSpan(text: 'Floor'),
                          TextSpan(
                            text: '.',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Floor Selection Buttons
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloorButton(floorNumber: 0, routeWidget: FloorZeroPage()),
                      SizedBox(width: 10),
                      FloorButton(floorNumber: 1, routeWidget: FloorOnePage()),
                      SizedBox(width: 10),
                      FloorButton(floorNumber: 2, routeWidget: FloorTwoPage()),
                    ],
                  ),

                  const Spacer(),

                  // Version Information
                  const Center(
                    child: Text(
                      'Kalapurackal Edition\nVersion 2.0.0\n2024 Washio. All rights reserved.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }

  // Function to show info dialog with clickable links
  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Dev Information',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter',
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    children: [
                      const TextSpan(text: 'Developed by Sam Joe in Flutter\n'),
                      TextSpan(
                        text: 'Instagram: ',
                        children: [
                          TextSpan(
                            text: '@samjoe.png\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    'https://www.instagram.com/samjoe.png/';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                      TextSpan(
                        text: 'Github: ',
                        children: [
                          TextSpan(
                            text: 'github.com/KingRain\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://github.com/KingRain';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                      TextSpan(
                        text: 'Website: ',
                        children: [
                          TextSpan(
                            text: 'samjoe.tech\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://samjoe.tech';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                      const TextSpan(text: 'UI/UX by Basil\n'),
                      TextSpan(
                        text: 'Instagram: ',
                        children: [
                          TextSpan(
                            text: '@basi__gar\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://instagram.com/basi__gar';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                      TextSpan(
                        text: 'Github: ',
                        children: [
                          TextSpan(
                            text: 'github.com/Basil-World\n\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://github.com/Basil-World';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                      const TextSpan(text: 'Web Dev: Lestlin Robins\n'),
                      TextSpan(
                        text: 'Instagram: ',
                        children: [
                          TextSpan(
                            text: '@lestlin_robins\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url =
                                    'https://instagram.com/lestlin_robins';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                      TextSpan(
                        text: 'Github: ',
                        children: [
                          TextSpan(
                            text: 'github.com/LestlinRobins\n',
                            style: const TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                const url = 'https://github.com/LestlinRobins';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(
                                    Uri.parse(url),
                                    mode: LaunchMode.externalApplication,
                                  );
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom Button Widget for Floors with Navigator Push to new page
class FloorButton extends StatelessWidget {
  final int floorNumber;
  final Widget routeWidget;

  const FloorButton({
    super.key,
    required this.floorNumber,
    required this.routeWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => routeWidget,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 28),
        side: const BorderSide(color: Colors.white, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        floorNumber.toString(),
        style: const TextStyle(
          fontSize: 28,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
