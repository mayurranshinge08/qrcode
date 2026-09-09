import 'package:flutter/material.dart';

import 'document_list_screen.dart';
import 'poster_list_screen.dart';

class PublicationScreen extends StatelessWidget {
  const PublicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/publication_image.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Theme.of(context).scaffoldBackgroundColor),
          ),

          // Hitbox for PUBLICATION
          Align(
            alignment: const Alignment(
              -0.55,
              0.35,
            ), // Positioned over the left button
            child: FractionallySizedBox(
              widthFactor: 0.35,
              heightFactor: 0.20,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DocumentListScreen(),
                    ),
                  );
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Hitbox for POSTER
          Align(
            alignment: const Alignment(
              0.55,
              0.35,
            ), // Positioned over the right button
            child: FractionallySizedBox(
              widthFactor: 0.35,
              heightFactor: 0.20,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PosterListScreen()),
                  );
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                offset: const Offset(0, -2),
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // BACK
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Image.asset('assets/images/Back.png', height: 40),
              ),
              // HOME
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: Image.asset('assets/images/Home.png', height: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
