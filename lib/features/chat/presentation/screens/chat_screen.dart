import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;
  
  const ChatScreen({super.key, this.extra});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  String? _selectedPresence;

  @override
  void initState() {
    super.initState();
    _selectedPresence = widget.extra?['presence'];
    
    // Add initial messages based on presence
    _addInitialMessages();
  }

  void _addInitialMessages() {
    String initialMessage = "Hi there, What's on your mind right now?";
    
    if (_selectedPresence != null) {
      switch (_selectedPresence) {
        case 'listener':
          initialMessage = "Hi there. I'm here to listen. What's on your mind right now?";
          break;
        case 'friend':
          initialMessage = "Hey! How are you doing? What's on your mind right now?";
          break;
        case 'therapist':
          initialMessage = "Hello. I'm here to support you. What would you like to explore today?";
          break;
        case 'coach':
          initialMessage = "Hi! I'm here to help you move forward. What's on your mind right now?";
          break;
      }
    }
    
    _messages.add(ChatMessage(
      text: initialMessage,
      isFromUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    _messages.add(ChatMessage(
      text: message,
      isFromUser: true,
      timestamp: DateTime.now(),
    ));

    _messageController.clear();
    setState(() {});

    // Simulate Kaya's response
    _simulateKayaResponse(message);
  }

  void _simulateKayaResponse(String userMessage) {
    Future.delayed(const Duration(seconds: 1), () {
      String response = "I understand. Tell me more about that.";
      
      if (userMessage.toLowerCase().contains('tough day') || 
          userMessage.toLowerCase().contains('bad day')) {
        response = "I'm really sorry to hear that. Want to tell me what happened?";
      } else if (userMessage.toLowerCase().contains('happy') || 
                 userMessage.toLowerCase().contains('good')) {
        response = "That's wonderful! I'm glad to hear that. What made it special?";
      } else if (userMessage.toLowerCase().contains('sad') || 
                 userMessage.toLowerCase().contains('upset')) {
        response = "I'm here for you. It's okay to feel that way. What's going on?";
      }

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isFromUser: false,
          timestamp: DateTime.now(),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with avatar and back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Kaya avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4B2996),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Kaya',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // Back button
                  GestureDetector(
                    onTap: () => context.pushNamed('chat-history'),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            
            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: message.isFromUser 
                          ? MainAxisAlignment.end 
                          : MainAxisAlignment.start,
                      children: [
                        if (!message.isFromUser) ...[
                          // Kaya avatar for their messages
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF4B2996),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        
                        // Message bubble
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: message.isFromUser 
                                  ? const Color(0xFF4B2996)
                                  : const Color(0xFF3B2170),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Message input
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B2170),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(color: Color(0xFFB6A9E5)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B2996),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Send',
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

class ChatMessage {
  final String text;
  final bool isFromUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });
} 