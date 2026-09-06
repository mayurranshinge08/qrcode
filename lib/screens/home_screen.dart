import 'package:flutter/material.dart';

import 'document_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/Evidence TV Interactive LED aw - 1.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Please save the image as "assets/images/home_bg.jpg"\nand restart the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),

          // Centered Button
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 725.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DocumentListScreen(),
                    ),
                  );
                },
                child: Image.asset(
                  'assets/images/Lets Explore.png',
                  height: 60, // approximate height for a nice button
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
