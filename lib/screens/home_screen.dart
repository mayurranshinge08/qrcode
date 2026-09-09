import 'package:flutter/material.dart';

import 'publication_screen.dart';

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
            'assets/images/backgroundss.jpeg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Please save the image as "assets/images/backgroundss.jpeg"\nand restart the app.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
          // Hitbox for LETS EXPLORE button
          Align(
            alignment: const Alignment(0.0, 0.78),
            child: FractionallySizedBox(
              widthFactor: 0.15,
              heightFactor: 0.20,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PublicationScreen(),
                    ),
                  );
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
