import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/providers/auth_provider.dart';
import 'package:kaya_app/core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.chat_bubble_outline, 'Talk'),
    _NavItem(Icons.edit_note, 'Journal'),
    _NavItem(Icons.mail_outline, 'Letters'),
    _NavItem(Icons.favorite_border, 'Glow'),
    _NavItem(Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final name = authProvider.user?.displayName ?? '';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi $name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          const Text('Welcome back', style: TextStyle(color: Color(0xFFB6A9E5), fontSize: 14)),
                        ],
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Mood check-in
              const Text('How are you feeling?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              const Text('Take a moment to check in with yourself', style: TextStyle(color: Color(0xFFB6A9E5), fontSize: 15)),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2170),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    _MoodOption(icon: Icons.self_improvement, label: 'Calm'),
                    _MoodOption(icon: Icons.sentiment_neutral, label: 'Neutral'),
                    _MoodOption(icon: Icons.sentiment_dissatisfied, label: 'Sad'),
                    _MoodOption(icon: Icons.sentiment_very_dissatisfied, label: 'Angry'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Quick actions
              const Text('Would you like to...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _QuickAction(icon: Icons.chat_bubble_outline, label: 'Talk to Kaya', onTap: () => context.pushNamed('presence-selection')),
                  _QuickAction(icon: Icons.edit_note, label: 'Write Journal', onTap: () => context.pushNamed('journal-compose')),
                  _QuickAction(icon: Icons.favorite_border, label: 'Write Glow Note', onTap: () => context.pushNamed('glow-notes-compose')),
                  _QuickAction(icon: Icons.mail_outline, label: 'Write Letter', onTap: () => context.pushNamed('letters-compose')),
                ],
              ),
              const SizedBox(height: 16),
              // Hold Space button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.nightlight_round, color: Color(0xFFB6A9E5)),
                  label: const Text('Hold Space', style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B2170),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                ),
              ),
              // Today's Insight
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2170),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.lightbulb_outline, color: Color(0xFFB6A9E5)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '"Take a deep breath. Remember that each moment is a chance to begin again. You\'re doing better than you think."',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
              // Mood Journey
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B2170),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('Your Mood Journey', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (i) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Icon(Icons.circle, size: 12, color: Color(0xFFB6A9E5)),
                      )),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: Color(0xFFB6A9E5)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E1065),
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // Talk button - navigate to chat history
            context.pushNamed('chat-history');
          } else if (index == 2) {
            // Journal button - navigate to journal history
            context.pushNamed('journal');
          } else if (index == 3) {
            // Letters button - navigate to letters home
            context.pushNamed('letters');
          } else if (index == 4) {
            // Glow button - navigate to glow notes home
            context.pushNamed('glow-notes');
          } else if (index == 5) {
            // Profile button - navigate to profile page
            context.pushNamed('profile');
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedItemColor: const Color(0xFFB6A9E5),
        unselectedItemColor: Colors.white,
        showUnselectedLabels: true,
        items: _navItems.map((item) => BottomNavigationBarItem(icon: Icon(item.icon), label: item.label)).toList(),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MoodOption({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF4B2996),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Color(0xFFB6A9E5), size: 28),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Color(0xFFB6A9E5), fontSize: 13)),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF3B2170),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFFB6A9E5), size: 28),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
} 