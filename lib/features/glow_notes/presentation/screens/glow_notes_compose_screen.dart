import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlowNotesComposeScreen extends StatefulWidget {
  const GlowNotesComposeScreen({super.key});

  @override
  State<GlowNotesComposeScreen> createState() => _GlowNotesComposeScreenState();
}

class _GlowNotesComposeScreenState extends State<GlowNotesComposeScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _noteController.text = "You're doing better than you think...";
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text('Back to Dashboard', style: TextStyle(color: Colors.white, fontSize: 16)),
                      ],
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
                      'GLOW NOTES',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description text
                    const Text(
                      'A Glow Note is a quick note from your future self that will be delivered to you in future.',
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Imagine yourself in the future, having overcome today\'s challenges.',
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 16,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'What wisdom or note of support would you share with your present self?',
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 16,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Text input field
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 8,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "You're doing better than you think...",
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Delivery options
                    GestureDetector(
                      onTap: () {
                        // Handle random delivery option
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2170),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.help_outline,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Deliver Back at Random',
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
                    const SizedBox(height: 12),
                    
                    GestureDetector(
                      onTap: () {
                        // Handle schedule delivery option
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B2170),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Schedule Delivery',
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
                    const SizedBox(height: 32),
                    
                    // Footer text
                    const Text(
                      'Your message will return to you as a gentle reminder of your journey ahead.',
                      style: TextStyle(
                        color: Color(0xFFB6A9E5),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 