import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/journal_entry_model.dart';
import 'api_service.dart';

class JournalService {
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
  
  // Create a new journal entry
  Future<JournalEntryModel> createEntry({
    required String title,
    required String content,
    String? mood,
    List<String>? tags,
  }) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.post(
        '/journal',
        data: {
          'title': title.isEmpty ? null : title,
          'content': content,
          'mood': mood,
          'tags': tags,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return JournalEntryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to create journal entry: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error creating journal entry: $e');
    }
  }

  // Get all journal entries
  Future<List<JournalEntryModel>> getEntries() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.get(
        '/journal',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> entriesJson = response.data;
        return entriesJson.map((json) => JournalEntryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch journal entries: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching journal entries: $e');
    }
  }

  // Get archived journal entries
  Future<List<JournalEntryModel>> getArchivedEntries() async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.get(
        '/journal/archive',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> entriesJson = response.data;
        return entriesJson.map((json) => JournalEntryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch archived entries: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error fetching archived entries: $e');
    }
  }

  // Update a journal entry
  Future<JournalEntryModel> updateEntry({
    required String id,
    String? title,
    String? content,
    String? mood,
    List<String>? tags,
    bool? isArchived,
  }) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.put(
        '/journal/$id',
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
          if (mood != null) 'mood': mood,
          if (tags != null) 'tags': tags,
          if (isArchived != null) 'is_archived': isArchived,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return JournalEntryModel.fromJson(response.data);
      } else {
        throw Exception('Failed to update journal entry: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error updating journal entry: $e');
    }
  }

  // Delete a journal entry
  Future<void> deleteEntry(String id) async {
    try {
      final token = await _getFirebaseToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await _apiService.dio.delete(
        '/journal/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete journal entry: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error deleting journal entry: $e');
    }
  }
} 