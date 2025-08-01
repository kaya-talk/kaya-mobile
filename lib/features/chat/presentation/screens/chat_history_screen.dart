import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  String _selectedFilter = 'All Chats';

  final List<String> _filters = ['All Chats', 'Grief', 'Uncertainty', 'Clarity'];
  
  final List<ChatPreview> _conversations = [
    ChatPreview(
      title: 'When I spiralled',
      preview: 'I needed to breathe. The walls were closing in...',
      timeAgo: '2h ago',
      tags: ['Anxiety', 'Processing'],
    ),
    ChatPreview(
      title: 'Before the flight',
      preview: 'Trying to ground myself before takeoff...',
      timeAgo: '1d ago',
      tags: ['Fear', 'Grounding'],
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
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Your open conversations.',
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
                      'These are the spaces you\'ve spoken into — in fragments, in full, or just to breathe. Some chats stay open. Some close on their own. You don\'t have to finish anything. You just have to show up.',
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Stats cards
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
                              children: [
                                const Text(
                                  'Active Conversations',
                                  style: TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '4',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
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
                              children: [
                                const Text(
                                  'Last Check-in',
                                  style: TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  '2 days ago',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Filter buttons
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = filter == _selectedFilter;
                          return Padding(
                            padding: EdgeInsets.only(right: index < _filters.length - 1 ? 12 : 0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilter = filter;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF4B2996) : const Color(0xFF3B2170),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  filter,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFFB6A9E5),
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Conversation previews
                    ..._conversations.map((conversation) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2170),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    conversation.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Text(
                                  conversation.timeAgo,
                                  style: const TextStyle(
                                    color: Color(0xFFB6A9E5),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              conversation.preview,
                              style: const TextStyle(
                                color: Color(0xFFB6A9E5),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: conversation.tags.map((tag) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4B2996),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              )).toList(),
                            ),
                          ],
                        ),
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
            
            // Start new conversation button
            Container(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () => context.pushNamed('presence-selection'),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B2996),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start a New Conversation',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
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
        currentIndex: 1, // Talk tab is selected
        onTap: (index) {
          if (index == 0) {
            // Home button
            context.goNamed('home');
          } else if (index == 1) {
            // Talk button - already on chat history
            // Do nothing, already selected
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

class ChatPreview {
  final String title;
  final String preview;
  final String timeAgo;
  final List<String> tags;

  ChatPreview({
    required this.title,
    required this.preview,
    required this.timeAgo,
    required this.tags,
  });
} 