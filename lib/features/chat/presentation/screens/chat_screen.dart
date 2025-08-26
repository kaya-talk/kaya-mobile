import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/models/kaya_model.dart';
import 'package:kaya_app/core/services/kaya_response_service.dart';
import 'package:kaya_app/core/providers/guide_provider.dart';
import 'package:kaya_app/core/providers/chat_provider.dart';
import 'package:kaya_app/core/models/chat_conversation.dart';
import 'package:kaya_app/core/models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;
  
  const ChatScreen({super.key, this.extra});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _conversationId;
  String? _selectedPresence;
  bool _isNewConversation = false;

  @override
  void initState() {
    super.initState();
    _conversationId = widget.extra?['conversationId'];
    _selectedPresence = widget.extra?['presence'];
    
    // Use post frame callback to avoid calling setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_conversationId != null) {
        // Load existing conversation
        _loadConversation();
      } else if (_selectedPresence != null) {
        // Create new conversation
        _createNewConversation();
      }
    });
  }

  Future<void> _loadConversation() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.setCurrentConversation(_conversationId!);
  }

  Future<void> _createNewConversation() async {
    final guideProvider = Provider.of<GuideProvider>(context, listen: false);
    final currentGuide = guideProvider.currentGuide;
    
    if (currentGuide == null) return;
    
    // Generate conversation title based on presence
    String title = 'New Conversation';
    switch (_selectedPresence) {
      case 'listener':
        title = 'Listening Session';
        break;
      case 'friend':
        title = 'Friendly Chat';
        break;
      case 'therapist':
        title = 'Therapeutic Session';
        break;
      case 'coach':
        title = 'Coaching Session';
        break;
    }
    
    final chatProvider = context.read<ChatProvider>();
    final conversation = await chatProvider.createConversation(
      title: title,
      presence: _selectedPresence!,
      guide: currentGuide,
    );
    
    if (conversation != null) {
      print('Conversation created, adding initial greeting...');
      // Add initial greeting BEFORE updating the UI state
      await _addInitialGreeting();
      print('Initial greeting added, updating UI state...');
      
      // Don't call setCurrentConversation again as it will overwrite the messages we just added
      print('Messages should now be available in the provider');
      
      // Now update the UI state after the greeting is added
      setState(() {
        _conversationId = conversation.id;
        _isNewConversation = true;
      });
      print('UI state updated, conversation ID: $_conversationId');
    }
  }

  Future<void> _addInitialGreeting() async {
    final guideProvider = Provider.of<GuideProvider>(context, listen: false);
    final currentGuide = guideProvider.currentGuide;
    
    if (currentGuide == null || _selectedPresence == null) return;
    
    String initialMessage = "Hi there, What's on your mind right now?";
    
    if (currentGuide != null && _selectedPresence != null) {
      initialMessage = currentGuide.getGreeting(_selectedPresence!);
    } else if (_selectedPresence != null) {
      // Fallback if guide is not available
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
    
    print('Adding initial greeting: $initialMessage');
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.addAIResponse(initialMessage, presence: _selectedPresence);
    print('Initial greeting added successfully');
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _conversationId == null) return;

    _messageController.clear();

    // Send message via chat provider
    final chatProvider = context.read<ChatProvider>();
    final success = await chatProvider.sendMessage(message, presence: _selectedPresence);
    
    if (success) {
      // Generate AI response
      await _generateKayaResponse(message);
    }
  }

  Future<void> _generateKayaResponse(String userMessage) async {
    await Future.delayed(const Duration(seconds: 1));
    
    String response;
    
    // Always use the current guide from the provider
    final guideProvider = Provider.of<GuideProvider>(context, listen: false);
    final currentGuide = guideProvider.currentGuide;
    
    if (currentGuide != null && _selectedPresence != null) {
      // Use the new response service for tailored responses
      response = KayaResponseService.generateResponse(
        userMessage: userMessage,
        presence: _selectedPresence!,
        kaya: currentGuide,
      );
    } else {
      // Fallback to simple responses if guide is not available
      response = _getFallbackResponse(userMessage);
    }

    // Add AI response via chat provider
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.addAIResponse(response, presence: _selectedPresence);
  }

  String _getFallbackResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('tough day') || lowerMessage.contains('bad day')) {
      return "I'm really sorry to hear that. Want to tell me what happened?";
    } else if (lowerMessage.contains('happy') || lowerMessage.contains('good')) {
      return "That's wonderful! I'm glad to hear that. What made it special?";
    } else if (lowerMessage.contains('sad') || lowerMessage.contains('upset')) {
      return "I'm here for you. It's okay to feel that way. What's going on?";
    }
    
    return "I understand. Tell me more about that.";
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
                  Expanded(
                    child: Consumer<GuideProvider>(
                      builder: (context, guideProvider, child) {
                        final currentGuide = guideProvider.currentGuide;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentGuide?.name ?? 'Kaya',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (currentGuide != null)
                              Text(
                                currentGuide.description,
                                style: const TextStyle(
                                  color: Color(0xFFB6A9E5),
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        );
                      },
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
               child: Consumer<ChatProvider>(
                 builder: (context, chatProvider, child) {
                   final messages = chatProvider.currentMessages;
                   final isLoading = chatProvider.isLoading;
                   
                   print('ChatScreen build - Messages count: ${messages.length}, Loading: $isLoading, Conversation ID: $_conversationId');
                    
                   if (messages.isEmpty && isLoading) {
                     return const Center(
                       child: CircularProgressIndicator(
                         color: Color(0xFFB6A9E5),
                       ),
                     );
                   }
                   
                   if (messages.isEmpty && !isLoading) {
                     return const Center(
                       child: Text(
                         'Starting conversation...',
                         style: TextStyle(
                           color: Color(0xFFB6A9E5),
                           fontSize: 16,
                         ),
                       ),
                     );
                   }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
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

 