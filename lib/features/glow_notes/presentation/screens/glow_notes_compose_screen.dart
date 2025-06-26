import 'package:flutter/material.dart';
import 'package:kaya_app/core/theme/app_theme.dart';

class GlowNotesComposeScreen extends StatelessWidget {
  const GlowNotesComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Glow Note'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.favorite,
                size: 60,
                color: AppTheme.accentColor,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Glow Note Writing Coming Soon!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Share your positive moments\nand achievements with Kaya.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 