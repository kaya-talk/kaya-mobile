import 'package:flutter/material.dart';
import 'package:kaya_app/core/services/user_service.dart';
import 'package:kaya_app/core/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  
  UserModel? _user;
  Map<String, dynamic> _preferences = {};
  UserStatistics? _statistics;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  Map<String, dynamic> get preferences => _preferences;
  UserStatistics? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize user data
  Future<void> initializeUser() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        _loadUserProfile(),
        _loadUserPreferences(),
        _loadUserStatistics(),
      ]);
    } catch (e) {
      _error = 'Failed to initialize user data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load user profile
  Future<void> _loadUserProfile() async {
    try {
      final user = await _userService.getUserProfile();
      if (user != null) {
        _user = user;
      }
    } catch (e) {
      _error = 'Failed to load user profile: ${e.toString()}';
    }
  }

  // Load user preferences
  Future<void> _loadUserPreferences() async {
    try {
      final preferences = await _userService.getUserPreferences();
      _preferences = preferences;
    } catch (e) {
      _error = 'Failed to load user preferences: ${e.toString()}';
    }
  }

  // Load user statistics
  Future<void> _loadUserStatistics() async {
    try {
      final statistics = await _userService.getUserStatistics();
      if (statistics != null) {
        _statistics = statistics;
      }
    } catch (e) {
      _error = 'Failed to load user statistics: ${e.toString()}';
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedUser = await _userService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      if (updatedUser != null) {
        _user = updatedUser;
      } else {
        _error = 'Failed to update profile';
      }
    } catch (e) {
      _error = 'Failed to update profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update user preferences
  Future<void> updatePreferences(Map<String, dynamic> newPreferences) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedPreferences = await _userService.updateUserPreferences(newPreferences);
      _preferences = updatedPreferences;
    } catch (e) {
      _error = 'Failed to update preferences: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update specific preference
  Future<void> updatePreference(String key, dynamic value) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updatedPreferences = await _userService.updatePreference(key, value);
      _preferences = updatedPreferences;
    } catch (e) {
      _error = 'Failed to update preference: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get specific preference
  T? getPreference<T>(String key, {T? defaultValue}) {
    return _preferences[key] as T? ?? defaultValue;
  }

  // Submit feedback
  Future<void> submitFeedback({
    required String feedbackType,
    required String content,
    int? rating,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.submitFeedback(
        feedbackType: feedbackType,
        content: content,
        rating: rating,
        metadata: metadata,
      );
    } catch (e) {
      _error = 'Failed to submit feedback: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit bug report
  Future<void> submitBugReport({
    required String description,
    required String steps,
    String? appVersion,
    String? platform,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.submitBugReport(
        description: description,
        steps: steps,
        appVersion: appVersion,
        platform: platform,
        additionalData: additionalData,
      );
    } catch (e) {
      _error = 'Failed to submit bug report: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit feature request
  Future<void> submitFeatureRequest({
    required String title,
    required String description,
    int? priority,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _userService.submitFeatureRequest(
        title: title,
        description: description,
        priority: priority,
        additionalData: additionalData,
      );
    } catch (e) {
      _error = 'Failed to submit feature request: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh user data
  Future<void> refreshUserData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await Future.wait([
        _loadUserProfile(),
        _loadUserPreferences(),
        _loadUserStatistics(),
      ]);
    } catch (e) {
      _error = 'Failed to refresh user data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear user data (for logout)
  void clearUserData() {
    _user = null;
    _preferences = {};
    _statistics = null;
    _error = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Check if user has completed onboarding
  bool get hasCompletedOnboarding {
    return getPreference<bool>('onboarding_completed', defaultValue: false) ?? false;
  }

  // Mark onboarding as completed
  Future<void> completeOnboarding() async {
    await updatePreference('onboarding_completed', true);
  }

  // Get theme preference
  String get theme {
    return getPreference<String>('theme', defaultValue: 'system') ?? 'system';
  }

  // Set theme preference
  Future<void> setTheme(String theme) async {
    await updatePreference('theme', theme);
  }

  // Get notification preference
  bool get notificationsEnabled {
    return getPreference<bool>('notifications_enabled', defaultValue: true) ?? true;
  }

  // Set notification preference
  Future<void> setNotificationsEnabled(bool enabled) async {
    await updatePreference('notifications_enabled', enabled);
  }

  // Get language preference
  String get language {
    return getPreference<String>('language', defaultValue: 'en') ?? 'en';
  }

  // Set language preference
  Future<void> setLanguage(String language) async {
    await updatePreference('language', language);
  }
} 