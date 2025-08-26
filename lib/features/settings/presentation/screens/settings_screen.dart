import 'package:flutter/material.dart';
import 'package:kaya_app/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: const Icon(
                Icons.settings,
                size: 60,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Settings Coming Soon!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Manage your preferences,\nprivacy, and notifications.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E1065),
        currentIndex: 5, // Profile tab is selected (since settings is accessed from profile)
        onTap: (index) {
          if (index == 0) {
            // Home button
            context.goNamed('home');
          } else if (index == 1) {
            // Talk button
            context.pushNamed('chat-history');
          } else if (index == 2) {
            // Journal button
            context.pushNamed('journal');
          } else if (index == 3) {
            // Letters button
            context.pushNamed('letters');
          } else if (index == 4) {
            // Glow button
            context.pushNamed('glow-notes');
          } else if (index == 5) {
            // Profile button
            context.goNamed('profile');
          }
        },
        selectedItemColor: const Color(0xFFB6A9E5),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Talk'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'Letters'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Glow'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
} 