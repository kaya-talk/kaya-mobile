import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/providers/auth_provider.dart';
import 'package:kaya_app/core/theme/app_theme.dart';
import 'package:kaya_app/core/providers/guide_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _selectedMood; // Track selected mood
  
  // Handle Talk to Kaya action
  void _handleTalkToKaya() {
    // Navigate directly to presence selection
    // The guide will be loaded from the provider
    context.pushNamed('presence-selection');
  }

  final List<_NavItem> _navItems = [
    _NavItem(Icons.home, 'Home'),
    _NavItem(Icons.chat_bubble_outline, 'Talk'),
    _NavItem(Icons.edit_note, 'Journal'),
    _NavItem(Icons.mail_outline, 'Letters'),
    _NavItem(Icons.favorite_border, 'Glow'),
    _NavItem(Icons.person_outline, 'Profile'),
  ];

  final List<_MoodData> _moodOptions = [
    _MoodData(icon: Icons.self_improvement, label: 'Calm', value: 'calm'),
    _MoodData(icon: Icons.sentiment_neutral, label: 'Neutral', value: 'neutral'),
    _MoodData(icon: Icons.sentiment_dissatisfied, label: 'Sad', value: 'sad'),
    _MoodData(icon: Icons.sentiment_very_dissatisfied, label: 'Angry', value: 'angry'),
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
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Expanded(
                     child: Consumer<AuthProvider>(
                       builder: (context, authProvider, child) {
                         final name = authProvider.user?.displayName ?? '';
                         return Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text(
                               'Hi $name', 
                               style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(height: 2),
                             Consumer<GuideProvider>(
                               builder: (context, guideProvider, child) {
                                 final guide = guideProvider.currentGuide;
                                 if (guide != null) {
                                   return Text(
                                     guideProvider.getPersonalizedGreeting('welcome'),
                                     style: const TextStyle(color: Color(0xFFB6A9E5), fontSize: 14),
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 2,
                                   );
                                 }
                                 return const Text(
                                   'Welcome back',
                                   style: const TextStyle(color: Color(0xFFB6A9E5), fontSize: 14),
                                   overflow: TextOverflow.ellipsis,
                                 );
                               },
                             ),
                           ],
                         );
                       },
                     ),
                   ),
                   const SizedBox(width: 8),
                   IconButton(
                     icon: const Icon(Icons.notifications_none, color: Colors.white),
                     onPressed: () {},
                     constraints: const BoxConstraints(
                       minWidth: 48,
                       minHeight: 48,
                     ),
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
                  children: _moodOptions.map((mood) => _SelectableMoodOption(
                    icon: mood.icon,
                    label: mood.label,
                    value: mood.value,
                    isSelected: _selectedMood == mood.value,
                    onTap: () {
                      setState(() {
                        _selectedMood = _selectedMood == mood.value ? null : mood.value;
                      });
                    },
                  )).toList(),
                ),
              ),
                             const SizedBox(height: 28),
               
                               // Guide Info Section
                Consumer<GuideProvider>(
                  builder: (context, guideProvider, child) {
                    final guide = guideProvider.currentGuide;
                    if (guide != null) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4B2996),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFB6A9E5), width: 1),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E1065),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                guide.sex == 'Female' ? Icons.person : Icons.person_outline,
                                color: const Color(0xFFB6A9E5),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Guide: ${guide.name}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    guide.description,
                                    style: const TextStyle(
                                      color: Color(0xFFB6A9E5),
                                      fontSize: 14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () {
                                // TODO: Navigate to guide settings/profile
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: Color(0xFFB6A9E5),
                                size: 20,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
               
               // Quick actions
               const Text('Would you like to...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2, // Slightly reduced to prevent overflow
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _QuickAction(icon: Icons.chat_bubble_outline, label: 'Talk to Kaya', onTap: _handleTalkToKaya),
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
                  onPressed: () => context.pushNamed('hold-space'),
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
                Consumer<GuideProvider>(
                  builder: (context, guideProvider, child) {
                    final guide = guideProvider.currentGuide;
                    String insight = '"Take a deep breath. Remember that each moment is a chance to begin again. You\'re doing better than you think."';
                    
                    if (guide != null) {
                      final style = guideProvider.getResponseStyle('insight');
                      switch (style) {
                        case 'empathetic':
                          insight = '"I want you to know that your feelings are valid, and it\'s okay to not be okay sometimes. You\'re doing better than you think."';
                          break;
                        case 'analytical':
                          insight = '"Every challenge you face is an opportunity to grow. Let\'s break down what\'s happening and find a way forward together."';
                          break;
                        case 'creative':
                          insight = '"Sometimes we need to look at things from a different angle. What if we approached this situation with curiosity instead of fear?"';
                          break;
                        case 'practical':
                          insight = '"Let\'s focus on one small step you can take today. Progress happens one moment at a time."';
                          break;
                      }
                    }
                    
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: const Color(0xFFB6A9E5)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              insight,
                              style: const TextStyle(color: Colors.white, fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
                    Expanded(
                      child: Text(
                        'Your Mood Journey', 
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
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

class _MoodData {
  final IconData icon;
  final String label;
  final String value;
  
  const _MoodData({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _SelectableMoodOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _SelectableMoodOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFB6A9E5) : const Color(0xFF4B2996),
              borderRadius: BorderRadius.circular(12),
              border: isSelected 
                ? Border.all(color: Colors.white, width: 2)
                : null,
            ),
            child: Icon(
              icon, 
              color: isSelected ? const Color(0xFF2E1065) : const Color(0xFFB6A9E5), 
              size: 28
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label, 
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFFB6A9E5), 
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            )
          ),
        ],
      ),
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