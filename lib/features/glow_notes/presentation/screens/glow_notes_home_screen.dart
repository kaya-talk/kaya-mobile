import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlowNotesHomeScreen extends StatefulWidget {
  const GlowNotesHomeScreen({super.key});

  @override
  State<GlowNotesHomeScreen> createState() => _GlowNotesHomeScreenState();
}

class _GlowNotesHomeScreenState extends State<GlowNotesHomeScreen> {
  String _selectedFilter = 'All Notes';

  final List<String> _filters = ['All Notes', 'Bright', 'Heavy', 'Quiet', 'Raw'];

  final List<GlowNote> _recentNotes = [
    GlowNote(
      date: 'May 8, 2025',
      content: 'The morning light through my window felt like a gentle hello.',
      tag: 'Bright',
      icon: '💡',
    ),
    GlowNote(
      date: 'May 7, 2025',
      content: 'Sometimes silence is the kindest answer.',
      tag: 'Quiet',
      icon: '☁️',
    ),
    GlowNote(
      date: 'May 5, 2025',
      content: 'Found myself humming today. It\'s been a while.',
      tag: 'Raw',
      icon: '💬',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: const Row(
                children: [
                  Text(
                    '✨ The light you left behind.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    const Text(
                      "Each Glow Note is a small moment you noticed — a flicker of truth, calm, ache, or gratitude. They don't have to be deep. They just have to be yours.",
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "You can look back on them, or write the next one as you are right now.",
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Statistics Cards
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B2170),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '12',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Glows saved',
                                  style: TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B2170),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '3 weeks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'since first glow',
                                  style: TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Filter Buttons
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters.map((filter) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _selectedFilter == filter 
                                  ? const Color(0xFF4B2996) 
                                  : const Color(0xFF3B2170),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Recent Glow Notes
                    const Text(
                      'Recent Glow Notes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Glow Note Cards
                    ..._recentNotes.map((note) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                note.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                note.date,
                                style: const TextStyle(
                                  color: Color(0xFFB6A9E5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            note.content,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4B2996),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              note.tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            
            // Add New Glow Note Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.pushNamed('glow-notes-compose'),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Add a New Glow Note →',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B2170),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF2E1065),
        currentIndex: 4, // Glow tab is selected
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
            // Glow button - already on glow notes
            // Do nothing, already selected
          } else if (index == 5) {
            // Profile button
            context.pushNamed('profile');
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

class GlowNote {
  final String date;
  final String content;
  final String tag;
  final String icon;

  GlowNote({
    required this.date,
    required this.content,
    required this.tag,
    required this.icon,
  });
} 