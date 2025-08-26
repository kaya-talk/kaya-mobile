import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kaya_app/core/models/chat_conversation.dart';
import 'package:kaya_app/core/models/chat_message.dart';
import 'package:kaya_app/core/models/kaya_model.dart';

class ChatApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1'; // Same as main ApiService
  static Dio? _dio;
  
  static Dio get dio {
    print('Dio getter called, _dio is: $_dio');
    _dio ??= Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    print('Dio instance created/retrieved: $_dio');
    return _dio!;
  }
  
  // Get Firebase ID token for authentication
  static Future<String?> _getAuthToken() async {
    try {
      print('Getting Firebase auth token...');
      final user = FirebaseAuth.instance.currentUser;
      print('Current Firebase user: ${user?.uid ?? 'null'}');
      if (user != null) {
        final token = await user.getIdToken(true);
        print('Token obtained: ${token != null ? 'yes' : 'no'}');
        return token;
      }
      print('No Firebase user found');
      return null;
    } catch (e) {
      print('Error getting auth token: $e');
      return null;
    }
  }
  
  // Add auth header to request
  static Future<void> _addAuthHeader() async {
    try {
      print('Adding auth header...');
      final token = await _getAuthToken();
      if (token != null) {
        print('Token obtained, setting header...');
        // Ensure dio is initialized before setting headers
        final dioInstance = dio;
        dioInstance.options.headers['Authorization'] = 'Bearer $token';
        print('Auth header set successfully');
      } else {
        print('No token available');
      }
    } catch (e) {
      print('Error adding auth header: $e');
    }
  }

  /// Create a new conversation
  static Future<ChatConversation> createConversation({
    required String title,
    required String presence,
    required KayaModel guide,
  }) async {
    try {
      await _addAuthHeader();
      final response = await dio.post(
        '/chat/conversations',
        data: {
          'title': title,
          'presence': presence,
          'guideData': guide.toJson(),
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return ChatConversation.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to create conversation');
        }
      } else {
        throw Exception('Failed to create conversation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error creating conversation: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error creating conversation: $e');
    }
  }

  /// Get all conversations for the user
  static Future<List<ChatConversation>> getConversations() async {
    try {
      await _addAuthHeader();
      final response = await dio.get('/chat/conversations');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((json) => ChatConversation.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to get conversations');
        }
      } else {
        throw Exception('Failed to get conversations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error getting conversations: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error getting conversations: $e');
    }
  }

  /// Get a specific conversation by ID
  static Future<ChatConversation> getConversation(String conversationId) async {
    try {
      await _addAuthHeader();
      final response = await dio.get('/chat/conversations/$conversationId');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return ChatConversation.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to get conversation');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Conversation not found');
      } else {
        throw Exception('Failed to get conversation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error getting conversation: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error getting conversation: $e');
    }
  }

  /// Get messages for a specific conversation
  static Future<List<ChatMessage>> getConversationMessages(String conversationId) async {
    try {
      await _addAuthHeader();
      final response = await dio.get('/chat/conversations/$conversationId/messages');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((json) => ChatMessage.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to get messages');
        }
      } else {
        throw Exception('Failed to get messages: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error getting messages: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error getting messages: $e');
    }
  }

  /// Send a message to a conversation
  static Future<ChatMessage> sendMessage({
    required String conversationId,
    required String text,
    required bool isFromUser,
    String? presence,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _addAuthHeader();
      final response = await dio.post(
        '/chat/conversations/$conversationId/messages',
        data: {
          'text': text,
          'presence': presence,
          'metadata': metadata,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return ChatMessage.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to send message');
        }
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error sending message: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  /// Add AI response to a conversation
  static Future<ChatMessage> addAIResponse({
    required String conversationId,
    required String text,
    String? presence,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _addAuthHeader();
      final response = await dio.post(
        '/chat/conversations/$conversationId/ai-response',
        data: {
          'text': text,
          'presence': presence,
          'metadata': metadata,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true) {
          return ChatMessage.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to add AI response');
        }
      } else {
        throw Exception('Failed to add AI response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error adding AI response: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error adding AI response: $e');
    }
  }

  /// Update conversation metadata
  static Future<ChatConversation> updateConversation({
    required String conversationId,
    String? title,
    String? lastMessage,
    int? messageCount,
    bool? isActive,
  }) async {
    try {
      await _addAuthHeader();
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (lastMessage != null) updates['lastMessage'] = lastMessage;
      if (messageCount != null) updates['messageCount'] = messageCount;
      if (isActive != null) updates['isActive'] = isActive;

      final response = await dio.put(
        '/chat/conversations/$conversationId',
        data: updates,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return ChatConversation.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to update conversation');
        }
      } else {
        throw Exception('Failed to update conversation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error updating conversation: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error updating conversation: $e');
    }
  }

  /// Delete a conversation
  static Future<bool> deleteConversation(String conversationId) async {
    try {
      await _addAuthHeader();
      final response = await dio.delete('/chat/conversations/$conversationId');

      if (response.statusCode == 200) {
        final data = response.data;
        return data['success'] == true;
      } else {
        throw Exception('Failed to delete conversation: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error deleting conversation: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error deleting conversation: $e');
    }
  }

  /// Search conversations
  static Future<List<ChatConversation>> searchConversations(String query) async {
    try {
      await _addAuthHeader();
      final response = await dio.get('/chat/search?q=${Uri.encodeComponent(query)}');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((json) => ChatConversation.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to search conversations');
        }
      } else {
        throw Exception('Failed to search conversations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error searching conversations: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error searching conversations: $e');
    }
  }

  /// Get conversation statistics
  static Future<Map<String, dynamic>> getConversationStats() async {
    try {
      await _addAuthHeader();
      final response = await dio.get('/chat/stats');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return data['data'];
        } else {
          throw Exception(data['message'] ?? 'Failed to get stats');
        }
      } else {
        throw Exception('Failed to get stats: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error getting stats: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error getting stats: $e');
    }
  }

  /// Get recent conversations with message previews
  static Future<List<ChatConversation>> getRecentConversations({int limit = 10}) async {
    try {
      await _addAuthHeader();
      final response = await dio.get('/chat/recent?limit=$limit');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((json) => ChatConversation.fromJson(json))
              .toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to get recent conversations');
        }
      } else {
        throw Exception('Failed to get recent conversations: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error getting recent conversations: ${_handleDioError(e)}');
    } catch (e) {
      throw Exception('Error getting recent conversations: $e');
    }
  }
  
  // Error handling for Dio exceptions
  static String _handleDioError(DioException e) {
    print('DioError: ${e.type} - ${e.message}');
    
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic> && data['error'] != null) {
        return data['error']['message'] ?? 'Server error occurred';
      }
      return 'Server error: ${e.response!.statusCode}';
    } else if (e.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout. Please check your internet connection and try again.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return 'Request timeout. The server is taking too long to respond.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Connection error. Please check your internet connection and ensure the backend server is running.';
    } else if (e.type == DioExceptionType.badResponse) {
      return 'Bad response from server. Please try again.';
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request was cancelled.';
    } else {
      return 'Network error: ${e.message}';
    }
  }
}
