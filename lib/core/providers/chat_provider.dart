import 'package:flutter/foundation.dart';
import 'package:kaya_app/core/models/chat_conversation.dart';
import 'package:kaya_app/core/models/chat_message.dart';
import 'package:kaya_app/core/models/kaya_model.dart';
import 'package:kaya_app/core/services/chat_api_service.dart';
import 'package:kaya_app/core/services/chat_storage_service.dart';

class ChatProvider extends ChangeNotifier {
  List<ChatConversation> _conversations = [];
  ChatConversation? _currentConversation;
  List<ChatMessage> _currentMessages = [];
  bool _isLoading = false;
  String? _error;
  bool _isOnline = true; // Track online/offline status

  // Getters
  List<ChatConversation> get conversations => _conversations;
  ChatConversation? get currentConversation => _currentConversation;
  List<ChatMessage> get currentMessages => _currentMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOnline => _isOnline;
  bool get hasConversations => _conversations.isNotEmpty;

  // Initialize the provider
  Future<void> initialize() async {
    _setLoading(true);
    try {
      // Try to load from local storage first
      await _loadFromLocalStorage();
      
      // If online, try to sync with API
      if (_isOnline) {
        await _syncWithAPI();
      }
    } catch (e) {
      _setError('Failed to initialize chat: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load conversations from local storage
  Future<void> _loadFromLocalStorage() async {
    try {
      _conversations = await ChatStorageService.getConversations();
      _conversations.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      notifyListeners();
    } catch (e) {
      print('Error loading from local storage: $e');
    }
  }

  // Sync with API
  Future<void> _syncWithAPI() async {
    try {
      final apiConversations = await ChatApiService.getConversations();
      
      // Merge API data with local data
      for (final apiConv in apiConversations) {
        final localIndex = _conversations.indexWhere((c) => c.id == apiConv.id);
        if (localIndex >= 0) {
          // Update existing conversation
          _conversations[localIndex] = apiConv;
        } else {
          // Add new conversation
          _conversations.add(apiConv);
        }
      }
      
      // Sort by last message time
      _conversations.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
      
      // Save to local storage
      await ChatStorageService.saveConversations(_conversations);
      notifyListeners();
    } catch (e) {
      print('Error syncing with API: $e');
      _isOnline = false;
    }
  }

  // Create a new conversation
  Future<ChatConversation?> createConversation({
    required String title,
    required String presence,
    required KayaModel guide,
  }) async {
    _setLoading(true);
    try {
      ChatConversation conversation;
      
      if (_isOnline) {
        // Create via API
        conversation = await ChatApiService.createConversation(
          title: title,
          presence: presence,
          guide: guide,
        );
      } else {
        // Create locally with generated ID
        conversation = ChatConversation(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          presence: presence,
          guide: guide,
          messageCount: 0,
          createdAt: DateTime.now(),
          lastMessageTime: DateTime.now(),
        );
      }
      
      // Add to local list and storage
      _conversations.insert(0, conversation);
      await ChatStorageService.saveConversations(_conversations);
      
      // Set as current conversation
      await setCurrentConversation(conversation.id);
      
      notifyListeners();
      return conversation;
    } catch (e) {
      _setError('Failed to create conversation: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Set current conversation
  Future<void> setCurrentConversation(String conversationId) async {
    try {
      _currentConversation = _conversations.firstWhere((c) => c.id == conversationId);
      await ChatStorageService.saveCurrentConversation(conversationId);
      
      // Load messages for this conversation
      await _loadConversationMessages(conversationId);
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to set current conversation: $e');
    }
  }

  // Load messages for a conversation
  Future<void> _loadConversationMessages(String conversationId) async {
    try {
      _currentMessages = await ChatStorageService.getConversationMessages(conversationId);
      
      // If online, try to sync messages with API
      if (_isOnline) {
        try {
          final apiMessages = await ChatApiService.getConversationMessages(conversationId);
          if (apiMessages.length > _currentMessages.length) {
            _currentMessages = apiMessages;
            await ChatStorageService.saveConversationMessages(conversationId, _currentMessages);
          }
        } catch (e) {
          print('Error syncing messages with API: $e');
        }
      }
      
      notifyListeners();
    } catch (e) {
      _setError('Failed to load messages: $e');
    }
  }

  // Send a message
  Future<bool> sendMessage(String text, {String? presence}) async {
    if (_currentConversation == null) return false;
    
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: _currentConversation!.id,
        text: text,
        isFromUser: true,
        timestamp: DateTime.now(),
        presence: presence,
      );
      
      // Add message locally first
      _currentMessages.add(message);
      await ChatStorageService.addMessage(_currentConversation!.id, message);
      
      // Update conversation metadata
      final updatedConversation = _currentConversation!.copyWith(
        lastMessage: text,
        lastMessageTime: DateTime.now(),
        messageCount: _currentMessages.length,
      );
      
      // Update in conversations list
      final index = _conversations.indexWhere((c) => c.id == _currentConversation!.id);
      if (index >= 0) {
        _conversations[index] = updatedConversation;
        _currentConversation = updatedConversation;
      }
      
      // Save to storage
      await ChatStorageService.saveConversations(_conversations);
      
      notifyListeners();
      
      // If online, send to API
      if (_isOnline) {
        try {
          await ChatApiService.sendMessage(
            conversationId: _currentConversation!.id,
            text: text,
            isFromUser: true,
            presence: presence,
          );
        } catch (e) {
          print('Error sending message to API: $e');
        }
      }
      
      return true;
    } catch (e) {
      _setError('Failed to send message: $e');
      return false;
    }
  }

  // Add AI response message
  Future<void> addAIResponse(String text, {String? presence}) async {
    if (_currentConversation == null) return;
    
    try {
      final message = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        conversationId: _currentConversation!.id,
        text: text,
        isFromUser: false,
        timestamp: DateTime.now(),
        presence: presence,
      );
      
      _currentMessages.add(message);
      await ChatStorageService.addMessage(_currentConversation!.id, message);
      
      // Update conversation metadata
      final updatedConversation = _currentConversation!.copyWith(
        lastMessage: text,
        lastMessageTime: DateTime.now(),
        messageCount: _currentMessages.length,
      );
      
      // Update in conversations list
      final index = _conversations.indexWhere((c) => c.id == _currentConversation!.id);
      if (index >= 0) {
        _conversations[index] = updatedConversation;
        _currentConversation = updatedConversation;
      }
      
      await ChatStorageService.saveConversations(_conversations);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add AI response: $e');
    }
  }

  // Delete conversation
  Future<bool> deleteConversation(String conversationId) async {
    try {
      // Remove from local list
      _conversations.removeWhere((c) => c.id == conversationId);
      
      // Clear current conversation if it's the one being deleted
      if (_currentConversation?.id == conversationId) {
        _currentConversation = null;
        _currentMessages.clear();
        await ChatStorageService.clearCurrentConversation();
      }
      
      // Delete from storage
      await ChatStorageService.deleteConversation(conversationId);
      
      // If online, delete from API
      if (_isOnline) {
        try {
          await ChatApiService.deleteConversation(conversationId);
        } catch (e) {
          print('Error deleting conversation from API: $e');
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete conversation: $e');
      return false;
    }
  }

  // Search conversations
  Future<List<ChatConversation>> searchConversations(String query) async {
    if (query.isEmpty) return _conversations;
    
    try {
      if (_isOnline) {
        return await ChatApiService.searchConversations(query);
      } else {
        return await ChatStorageService.searchConversations(query);
      }
    } catch (e) {
      // Fallback to local search
      return await ChatStorageService.searchConversations(query);
    }
  }

  // Refresh conversations
  Future<void> refreshConversations() async {
    if (_isOnline) {
      await _syncWithAPI();
    }
  }

  // Set online/offline status
  void setOnlineStatus(bool isOnline) {
    _isOnline = isOnline;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // Get conversation by ID
  ChatConversation? getConversationById(String id) {
    try {
      return _conversations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get conversation statistics
  Future<Map<String, dynamic>> getStats() async {
    try {
      if (_isOnline) {
        return await ChatApiService.getConversationStats();
      } else {
        return await ChatStorageService.getConversationStats();
      }
    } catch (e) {
      return await ChatStorageService.getConversationStats();
    }
  }
}
