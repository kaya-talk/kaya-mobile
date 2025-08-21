import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/letters_service.dart';
import '../../../../core/models/letter_model.dart';

class LettersComposeScreen extends StatefulWidget {
  const LettersComposeScreen({super.key});

  @override
  State<LettersComposeScreen> createState() => _LettersComposeScreenState();
}

class _LettersComposeScreenState extends State<LettersComposeScreen> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final LettersService _lettersService = LettersService();
  String? _selectedEmotion;
  bool _isSaving = false;

  final List<String> _emotions = [
    'Angry',
    'Grateful',
    'Heartbroken',
    'Hopeful',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveLetter() async {
    // Validate input
    if (_textController.text.trim().isEmpty) {
      _showErrorSnackBar('Please write something in your letter');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _lettersService.createLetter(
        mood: _selectedEmotion,
        subject: _titleController.text.trim().isEmpty ? null : _titleController.text.trim(),
        content: _textController.text.trim(),
      );

      if (mounted) {
        _showSuccessSnackBar('Letter saved successfully!');
        // Navigate back to letters home
        context.goNamed('letters');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to save letter: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _letItGo() {
    // TODO: Implement let it go functionality
    // For now, just navigate to letters home
    context.goNamed('letters');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                    
                    // Letter Title Input
                    const Text(
                      'Title (Optional)',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _titleController,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: const Color(0xFFB6A9E5),
                        decoration: const InputDecoration(
                          hintText: "Give your letter a title...",
                          hintStyle: TextStyle(
                            color: Color(0xFFB6A9E5),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
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
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        cursorColor: const Color(0xFFB6A9E5),
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
                      onPressed: _isSaving ? null : _saveLetter,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSaving 
                          ? const Color(0xFF6B7280) 
                          : const Color(0xFF3B2170),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isSaving
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Saving...'),
                            ],
                          )
                        : const Text(
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
                      onPressed: _isSaving ? null : _letItGo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isSaving 
                          ? const Color(0xFF6B7280) 
                          : const Color(0xFF4B2996),
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