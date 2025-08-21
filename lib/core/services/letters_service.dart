import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/letter_model.dart';
import 'api_service.dart';

class LettersService {
  final ApiService _apiService = ApiService();
  
  // Get current Firebase ID token
  Future<String?> _getFirebaseToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await user.getIdToken(true);
      }
      return null;
    } catch (e) {
      print('Error getting Firebase token: $e');
      return null;
    }
  }
  
  // Create a new letter
  Future<LetterModel> createLetter({
    String? mood,
    String? subject,
    required String content,
  }) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.post(
        '/letters',
        data: {
          'mood': mood,
          'subject': subject?.isEmpty == true ? null : subject,
          'content': content,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return LetterModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create letter: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating letter: $e');
    }
  }

  // Get all letters with optional mood filtering
  Future<List<LetterModel>> getLetters({String? mood}) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      String url = '/letters';
      if (mood != null && mood.isNotEmpty && mood != 'All') {
        url += '?mood=$mood';
      }

      final response = await _apiService.dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> lettersJson = response.data;
        return lettersJson.map((json) => LetterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch letters: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching letters: $e');
    }
  }

  // Get specific letter
  Future<LetterModel> getLetter(String id) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.get(
        '/letters/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LetterModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch letter: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching letter: $e');
    }
  }

  // Update a letter
  Future<LetterModel> updateLetter({
    required String id,
    String? mood,
    String? subject,
    String? content,
    bool? isDraft,
  }) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.put(
        '/letters/$id',
        data: {
          if (mood != null) 'mood': mood,
          if (subject != null) 'subject': subject,
          if (content != null) 'content': content,
          if (isDraft != null) 'is_draft': isDraft,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LetterModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update letter: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating letter: $e');
    }
  }

  // Delete a letter
  Future<void> deleteLetter(String id) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.delete(
        '/letters/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete letter: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting letter: $e');
    }
  }

  // Send a letter (mark as not draft)
  Future<LetterModel> sendLetter(String id) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.put(
        '/letters/$id',
        data: {
          'is_draft': false,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LetterModel.fromJson(response.data);
      } else {
        throw Exception('Failed to send letter: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error sending letter: $e');
    }
  }
} 