import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
  static const String authUrl = '$baseUrl/auth';
  static const String usersUrl = '$baseUrl/users';
  
  late final Dio _dio;
  
  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
    
    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('API: $obj'),
    ));
  }
  
  // Test connection to backend
  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  // Test email configuration
  Future<Map<String, dynamic>> testEmailConfig(String testEmail) async {
    try {
      final response = await _dio.post(
        '/auth/test-email-config',
        data: {
          'testEmail': testEmail,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Test minimal signup (for debugging)
  Future<Map<String, dynamic>> testMinimalSignup({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/test-signup',
        data: {
          'email': email,
          'password': password,
          if (displayName != null) 'displayName': displayName,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // Get auth token from shared preferences
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Set auth token in shared preferences
  Future<void> _setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  // Clear auth token from shared preferences
  Future<void> _clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  // Add auth token to request headers
  Future<void> _addAuthHeader() async {
    final token = await _getAuthToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }
  
  // Authentication endpoints
  Future<Map<String, dynamic>> signUp({
    required String idToken,
    String? displayName,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          'idToken': idToken,
          if (displayName != null) 'displayName': displayName,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> verifyToken(String idToken) async {
    try {
      final response = await _dio.post(
        '/auth/verify-token',
        data: {
          'idToken': idToken,
        },
      );
      
      if (response.data['success']) {
        // Store the verified token
        await _setAuthToken(idToken);
      }
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> sendEmailVerification(String email) async {
    try {
      final response = await _dio.post(
        '/auth/verify-email',
        data: {
          'email': email,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      final response = await _dio.post(
        '/auth/reset-password',
        data: {
          'email': email,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      await _addAuthHeader();
      final response = await _dio.get('/auth/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _addAuthHeader();
      final response = await _dio.put(
        '/auth/profile',
        data: {
          if (displayName != null) 'displayName': displayName,
          if (photoURL != null) 'photoURL': photoURL,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> deleteAccount() async {
    try {
      await _addAuthHeader();
      final response = await _dio.delete('/auth/account');
      
      // Clear auth token after account deletion
      await _clearAuthToken();
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // User management endpoints
  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      await _addAuthHeader();
      final response = await _dio.get('/users/me');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _addAuthHeader();
      final response = await _dio.put(
        '/users/me',
        data: {
          if (displayName != null) 'displayName': displayName,
          if (photoURL != null) 'photoURL': photoURL,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      await _addAuthHeader();
      final response = await _dio.get('/users/preferences');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await _addAuthHeader();
      final response = await _dio.put(
        '/users/preferences',
        data: {
          'preferences': preferences,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> submitFeedback({
    required String feedbackType,
    required String content,
    int? rating,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _addAuthHeader();
      final response = await _dio.post(
        '/users/feedback',
        data: {
          'feedbackType': feedbackType,
          'content': content,
          if (rating != null) 'rating': rating,
          if (metadata != null) 'metadata': metadata,
        },
      );
      
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      await _addAuthHeader();
      final response = await _dio.get('/users/statistics');
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
  
  // Error handling
  String _handleDioError(DioException e) {
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
  
  // Clear auth token (for logout)
  Future<void> clearAuthToken() async {
    await _clearAuthToken();
  }
} 