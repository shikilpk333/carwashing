import 'package:flutter/material.dart';


class Splash extends StatelessWidget {
  Splash({Key? key}) : super(key: key);

  final Color backgroundColor = const Color(0xFF0D111C); // Deep navy
  final Color overlayBoxColor = const Color.fromARGB(26, 33, 43, 100); // Slightly lighter box color
  final Color accentBlue = const Color(0xFF00C8FF); // Aqua blue

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Rounded square background decorations
          Positioned(
            top: 0,
            left: -30,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: overlayBoxColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            top: 150,
            right: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: overlayBoxColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 40,
            right: 40,
           // left: 20,
            child: Container(
              width: 300,
              height: 220,
              child: Center(child:    // Loading bar
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    color: accentBlue,
                    backgroundColor: Colors.grey.shade800,
                    minHeight: 4,
                  ),
                )),
              decoration: BoxDecoration(
                color: overlayBoxColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),

          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                // App icon container
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: accentBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // App name
                const Text(
                  'AquaShine',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                const Text(
                  'Clean car, happier drive',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 60),

                // Loading bar
              /*  SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    color: accentBlue,
                    backgroundColor: Colors.grey.shade800,
                    minHeight: 4,
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}