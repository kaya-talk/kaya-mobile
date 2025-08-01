import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PresenceSelectionScreen extends StatefulWidget {
  const PresenceSelectionScreen({super.key});

  @override
  State<PresenceSelectionScreen> createState() => _PresenceSelectionScreenState();
}

class _PresenceSelectionScreenState extends State<PresenceSelectionScreen> {
  String? _selectedPresence;

  final List<PresenceOption> _presenceOptions = [
    PresenceOption(
      id: 'listener',
      title: 'The Listener',
      description: 'silent, spacious, softly reflective',
      icon: Icons.help_outline,
    ),
    PresenceOption(
      id: 'friend',
      title: 'The Friend',
      description: 'warm, casual, light emotional support',
      icon: Icons.favorite_border,
    ),
    PresenceOption(
      id: 'therapist',
      title: 'The Therapist',
      description: 'grounded, observant, gently probing',
      icon: Icons.chat_bubble_outline,
    ),
    PresenceOption(
      id: 'coach',
      title: 'The Coach',
      description: 'forward-facing, encouraging, clarity-seeking',
      icon: Icons.explore_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed back button section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Row(
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
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
              ),
            ),
            
            // Scrollable content - everything together
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'What kind of presence do you need right now?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    const Text(
                      'Kaya can meet you in different ways — like a quiet listener, a kind friend, a thoughtful guide, or a gentle coach. Pick the voice that feels most comforting today. You can always change it later.',
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Presence options
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _presenceOptions.length,
                      itemBuilder: (context, index) {
                        final option = _presenceOptions[index];
                        final isSelected = _selectedPresence == option.id;
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPresence = option.id;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF4B2996) 
                                    : const Color(0xFF3B2170),
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected 
                                    ? Border.all(color: const Color(0xFFB6A9E5), width: 2)
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E1065),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      option.icon,
                                      color: const Color(0xFFB6A9E5),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          option.description,
                                          style: const TextStyle(
                                            color: Color(0xFFB6A9E5),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Bottom buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          // "This feels right" button - always active
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_selectedPresence != null) {
                                  _navigateToChat(_selectedPresence);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4B2996),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'This feels right',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _selectedPresence != null 
                                      ? Colors.white 
                                      : const Color(0xFFC7B2DE),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Skip option
                          GestureDetector(
                            onTap: () => _navigateToChat(null),
                            child: const Text(
                              "I'm not sure, I just need to chat",
                              style: TextStyle(
                                color: Color(0xFFC7B2DE),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToChat(String? presence) {
    // Navigate to chat screen with the selected presence
    context.pushNamed('chat', extra: {'presence': presence});
  }
}

class PresenceOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  PresenceOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
} 