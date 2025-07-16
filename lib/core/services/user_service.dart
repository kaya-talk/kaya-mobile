import 'package:kaya_app/core/services/api_service.dart';
import 'package:kaya_app/core/models/user_model.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Get user profile with statistics
  Future<UserModel?> getUserProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      
      if (response['success']) {
        final userData = response['data']['user'];
        return UserModel.fromJson(userData);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  // Update user profile
  Future<UserModel?> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final response = await _apiService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      
      if (response['success']) {
        final userData = response['data']['user'];
        return UserModel.fromJson(userData);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }

  // Get user preferences
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final response = await _apiService.getUserPreferences();
      
      if (response['success']) {
        return response['data']['preferences'] ?? {};
      }
      
      return {};
    } catch (e) {
      throw Exception('Failed to get user preferences: ${e.toString()}');
    }
  }

  // Update user preferences
  Future<Map<String, dynamic>> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final response = await _apiService.updateUserPreferences(preferences);
      
      if (response['success']) {
        return response['data']['preferences'] ?? {};
      }
      
      return {};
    } catch (e) {
      throw Exception('Failed to update user preferences: ${e.toString()}');
    }
  }

  // Submit feedback
  Future<FeedbackModel?> submitFeedback({
    required String feedbackType,
    required String content,
    int? rating,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await _apiService.submitFeedback(
        feedbackType: feedbackType,
        content: content,
        rating: rating,
        metadata: metadata,
      );
      
      if (response['success']) {
        final feedbackData = response['data']['feedback'];
        return FeedbackModel.fromJson(feedbackData);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to submit feedback: ${e.toString()}');
    }
  }

  // Get user statistics
  Future<UserStatistics?> getUserStatistics() async {
    try {
      final response = await _apiService.getUserStatistics();
      
      if (response['success']) {
        final statsData = response['data']['statistics'];
        return UserStatistics.fromJson(statsData);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get user statistics: ${e.toString()}');
    }
  }

  // Update specific preference
  Future<Map<String, dynamic>> updatePreference(String key, dynamic value) async {
    try {
      // Get current preferences
      final currentPreferences = await getUserPreferences();
      
      // Update the specific preference
      currentPreferences[key] = value;
      
      // Save updated preferences
      return await updateUserPreferences(currentPreferences);
    } catch (e) {
      throw Exception('Failed to update preference: ${e.toString()}');
    }
  }

  // Get specific preference
  Future<T?> getPreference<T>(String key, {T? defaultValue}) async {
    try {
      final preferences = await getUserPreferences();
      return preferences[key] as T? ?? defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }

  // Submit bug report
  Future<FeedbackModel?> submitBugReport({
    required String description,
    required String steps,
    String? appVersion,
    String? platform,
    Map<String, dynamic>? additionalData,
  }) async {
    final metadata = {
      'type': 'bug_report',
      'steps': steps,
      if (appVersion != null) 'appVersion': appVersion,
      if (platform != null) 'platform': platform,
      if (additionalData != null) ...additionalData,
    };

    return await submitFeedback(
      feedbackType: 'bug_report',
      content: description,
      metadata: metadata,
    );
  }

  // Submit feature request
  Future<FeedbackModel?> submitFeatureRequest({
    required String title,
    required String description,
    int? priority,
    Map<String, dynamic>? additionalData,
  }) async {
    final metadata = {
      'type': 'feature_request',
      'title': title,
      if (priority != null) 'priority': priority,
      if (additionalData != null) ...additionalData,
    };

    return await submitFeedback(
      feedbackType: 'feature_request',
      content: description,
      rating: priority,
      metadata: metadata,
    );
  }

  // Submit general feedback
  Future<FeedbackModel?> submitGeneralFeedback({
    required String content,
    int? rating,
    Map<String, dynamic>? metadata,
  }) async {
    return await submitFeedback(
      feedbackType: 'general',
      content: content,
      rating: rating,
      metadata: metadata,
    );
  }
} 