import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaya_app/core/models/chat_conversation.dart';
import 'package:kaya_app/core/models/chat_message.dart';

class ChatStorageService {
  static const String _conversationsKey = 'chat_conversations';
  static const String _messagesPrefix = 'chat_messages_';
  static const String _currentConversationKey = 'current_conversation';

  // Save conversations list
  static Future<void> saveConversations(List<ChatConversation> conversations) async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsJson = conversations.map((c) => c.toJson()).toList();
    await prefs.setString(_conversationsKey, jsonEncode(conversationsJson));
  }

  // Get conversations list
  static Future<List<ChatConversation>> getConversations() async {
    final prefs = await SharedPreferences.getInstance();
    final conversationsString = prefs.getString(_conversationsKey);
    
    if (conversationsString == null) return [];
    
    try {
      final List<dynamic> conversationsJson = jsonDecode(conversationsString);
      return conversationsJson.map((json) => ChatConversation.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing conversations: $e');
      return [];
    }
  }

  // Save a single conversation
  static Future<void> saveConversation(ChatConversation conversation) async {
    final conversations = await getConversations();
    final existingIndex = conversations.indexWhere((c) => c.id == conversation.id);
    
    if (existingIndex >= 0) {
      conversations[existingIndex] = conversation;
    } else {
      conversations.add(conversation);
    }
    
    await saveConversations(conversations);
  }

  // Get a single conversation by ID
  static Future<ChatConversation?> getConversation(String conversationId) async {
    final conversations = await getConversations();
    try {
      return conversations.firstWhere((c) => c.id == conversationId);
    } catch (e) {
      return null;
    }
  }

  // Delete a conversation
  static Future<void> deleteConversation(String conversationId) async {
    final conversations = await getConversations();
    conversations.removeWhere((c) => c.id == conversationId);
    await saveConversations(conversations);
    
    // Also delete associated messages
    await deleteConversationMessages(conversationId);
  }

  // Save messages for a conversation
  static Future<void> saveConversationMessages(String conversationId, List<ChatMessage> messages) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = messages.map((m) => m.toJson()).toList();
    await prefs.setString('$_messagesPrefix$conversationId', jsonEncode(messagesJson));
  }

  // Get messages for a conversation
  static Future<List<ChatMessage>> getConversationMessages(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    final messagesString = prefs.getString('$_messagesPrefix$conversationId');
    
    if (messagesString == null) return [];
    
    try {
      final List<dynamic> messagesJson = jsonDecode(messagesString);
      return messagesJson.map((json) => ChatMessage.fromJson(json)).toList();
    } catch (e) {
      print('Error parsing messages: $e');
      return [];
    }
  }

  // Add a message to a conversation
  static Future<void> addMessage(String conversationId, ChatMessage message) async {
    final messages = await getConversationMessages(conversationId);
    messages.add(message);
    await saveConversationMessages(conversationId, messages);
    
    // Update conversation metadata
    final conversation = await getConversation(conversationId);
    if (conversation != null) {
      final updatedConversation = conversation.copyWith(
        lastMessage: message.text,
        lastMessageTime: message.timestamp,
        messageCount: messages.length,
      );
      await saveConversation(updatedConversation);
    }
  }

  // Delete messages for a conversation
  static Future<void> deleteConversationMessages(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_messagesPrefix$conversationId');
  }

  // Save current conversation ID
  static Future<void> saveCurrentConversation(String conversationId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentConversationKey, conversationId);
  }

  // Get current conversation ID
  static Future<String?> getCurrentConversation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentConversationKey);
  }

  // Clear current conversation
  static Future<void> clearCurrentConversation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentConversationKey);
  }

  // Search conversations locally
  static Future<List<ChatConversation>> searchConversations(String query) async {
    final conversations = await getConversations();
    if (query.isEmpty) return conversations;
    
    final lowercaseQuery = query.toLowerCase();
    return conversations.where((conversation) {
      return conversation.title.toLowerCase().contains(lowercaseQuery) ||
             (conversation.lastMessage?.toLowerCase().contains(lowercaseQuery) ?? false) ||
             conversation.guide.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get conversation statistics
  static Future<Map<String, dynamic>> getConversationStats() async {
    final conversations = await getConversations();
    final activeConversations = conversations.where((c) => c.isActive).length;
    final totalMessages = conversations.fold(0, (sum, c) => sum + c.messageCount);
    
    return {
      'totalConversations': conversations.length,
      'activeConversations': activeConversations,
      'totalMessages': totalMessages,
      'averageMessagesPerConversation': conversations.isEmpty ? 0 : totalMessages / conversations.length,
    };
  }

  // Clear all chat data
  static Future<void> clearAllChatData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get all conversation IDs to remove their messages
    final conversations = await getConversations();
    for (final conversation in conversations) {
      await deleteConversationMessages(conversation.id);
    }
    
    // Remove conversations and current conversation
    await prefs.remove(_conversationsKey);
    await prefs.remove(_currentConversationKey);
  }

  // Export chat data
  static Future<Map<String, dynamic>> exportChatData() async {
    final conversations = await getConversations();
    final exportData = <String, dynamic>{
      'exportDate': DateTime.now().toIso8601String(),
      'conversations': [],
    };
    
    for (final conversation in conversations) {
      final messages = await getConversationMessages(conversation.id);
      exportData['conversations'].add({
        'conversation': conversation.toJson(),
        'messages': messages.map((m) => m.toJson()).toList(),
      });
    }
    
    return exportData;
  }

  // Import chat data
  static Future<void> importChatData(Map<String, dynamic> importData) async {
    try {
      final conversationsData = importData['conversations'] as List;
      
      for (final convData in conversationsData) {
        final conversation = ChatConversation.fromJson(convData['conversation']);
        final messages = (convData['messages'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList();
        
        await saveConversation(conversation);
        await saveConversationMessages(conversation.id, messages);
      }
    } catch (e) {
      throw Exception('Error importing chat data: $e');
    }
  }
}
