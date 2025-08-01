import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/providers/auth_provider.dart';
import 'package:kaya_app/core/providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back arrow and settings
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Back to Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pushNamed('settings'),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Avatar and description
                    const SizedBox(height: 20),
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB6A9E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF2E1065),
                        size: 60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This is you, quietly.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No bios. No followers. Just a place to hold your tone, your pace, and the parts of you Kaya knows.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Profile Information Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProfileItem('Display Name', 'Just Me'),
                          const SizedBox(height: 16),
                          _buildProfileItem('Chosen Vibe', 'Listener'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Journey Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Journey Statistics
                          Row(
                            children: [
                              Expanded(
                                child: _buildJourneyStat('14', 'Days Present'),
                              ),
                              Expanded(
                                child: _buildJourneyStat('6', 'Glow Notes'),
                              ),
                              Expanded(
                                child: _buildJourneyStat('3', 'Letters'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Recent Achievements
                          const Text(
                            'Recent Achievements',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildAchievement(
                            'First Step Taken',
                            'Your first journal entry.',
                            Icons.edit_note,
                          ),
                          const SizedBox(height: 12),
                          _buildAchievement(
                            'Stayed With It',
                            '7 days of showing up.',
                            Icons.nightlight_round,
                          ),
                          const SizedBox(height: 12),
                          _buildAchievement(
                            'Glow Collected',
                            '5 Glow Notes added.',
                            Icons.help_outline,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Action Buttons
                    _buildActionButton('Edit Details', () {
                      // TODO: Navigate to edit details
                    }),
                    const SizedBox(height: 12),
                    _buildActionButton('Export My Journey', () {
                      context.pushNamed('import-export');
                    }),
                    const SizedBox(height: 12),
                    _buildActionButton('Log Out', () async {
                      // Get providers
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                      
                      // Perform logout
                      await authProvider.signOut();
                      userProvider.clearUserData();
                      
                      // Navigate to login page
                      if (context.mounted) {
                        context.goNamed('login');
                      }
                    }),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB6A9E5),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildJourneyStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB6A9E5),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievement(String title, String description, IconData icon) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF4B2996),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFB6A9E5),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFB6A9E5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B2170),
          foregroundColor: const Color(0xFFB6A9E5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 