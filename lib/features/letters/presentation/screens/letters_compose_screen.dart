import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LettersComposeScreen extends StatefulWidget {
  const LettersComposeScreen({super.key});

  @override
  State<LettersComposeScreen> createState() => _LettersComposeScreenState();
}

class _LettersComposeScreenState extends State<LettersComposeScreen> {
  final TextEditingController _textController = TextEditingController();
  String? _selectedEmotion;

  final List<String> _emotions = [
    'Angry',
    'Grateful',
    'Heartbroken',
    'Hopeful',
  ];

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _saveLetter() {
    // TODO: Implement save functionality
    // For now, just navigate to letters home
    context.goNamed('letters');
  }

  void _letItGo() {
    // TODO: Implement let it go functionality
    // For now, just navigate to letters home
    context.goNamed('letters');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Header with navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.goNamed('letters'),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Back to Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    'See Unsent Letters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
                    // Main title
                    const Text(
                      'Unsent Letters',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Write something you're not ready to say out loud.",
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Emotion buttons
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _emotions.map((emotion) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedEmotion = _selectedEmotion == emotion ? null : emotion;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedEmotion == emotion 
                              ? const Color(0xFF4B2996) 
                              : const Color(0xFF3B2170),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            emotion,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 16),
                    
                    // More emotions link
                    GestureDetector(
                      onTap: () {
                        // TODO: Show more emotions
                      },
                      child: const Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Color(0xFFB6A9E5),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'More emotions',
                            style: TextStyle(
                              color: Color(0xFFB6A9E5),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Text input area
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _textController,
                        maxLines: 8,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Start with 'Dear...' or say whatever.",
                          hintStyle: TextStyle(
                            color: Color(0xFFB6A9E5),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Action buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveLetter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B2170),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save as Unsent',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _letItGo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4B2996),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Let it Go',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 