import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaya_app/core/services/api_service.dart';
import 'package:kaya_app/core/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ApiService _apiService = ApiService();
  
  User? _firebaseUser;
  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  bool _isInitialized = false;

  User? get firebaseUser => _firebaseUser;
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _firebaseUser != null && _user != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((User? user) async {
      _firebaseUser = user;
      
      if (user != null) {
        // User is signed in with Firebase
        // (No backend verification)
      } else {
        // User is signed out
        _user = null;
        await _apiService.clearAuthToken();
      }
      
      _isInitialized = true;
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Create user in Firebase Auth
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Send email verification
      if (!result.user!.emailVerified) {
        await result.user!.sendEmailVerification();
      }

      // 3. Get ID token from Firebase user
      final idToken = await result.user!.getIdToken();
      if (idToken == null) {
        _error = 'Failed to get ID token from Firebase.';
        notifyListeners();
        return;
      }

      // 4. Call backend to store user info in DB
      final response = await _apiService.signUp(
        idToken: idToken!,
        displayName: displayName,
      );

      // 5. Handle backend response as needed
      if (response['success']) {
        final userData = response['data']['user'];
        _user = UserModel.fromJson(userData);
        await _saveUserData();
      } else {
        _error = response['error']?['message'] ?? 'Signup failed';
        await result.user!.delete();
      }
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseErrorMessage(e.code);
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Checks and reloads the user's email verification status
  Future<bool> checkEmailVerified() async {
    if (_firebaseUser != null) {
      await _firebaseUser!.reload();
      _firebaseUser = _auth.currentUser;
      notifyListeners();
      return _firebaseUser!.emailVerified;
    }
    return false;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Sign in with Firebase Auth
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // No backend verification
      // Optionally, set _user to null or fetch from local storage if needed
      _user = null;
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseErrorMessage(e.code);
    } catch (e) {
      _error = 'An unexpected error occurred: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _auth.signOut();
      await _apiService.clearAuthToken();
      await _clearUserData();
      
      _user = null;
    } catch (e) {
      _error = 'Error signing out: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Use Firebase Auth to send reset password email
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      _error = _getFirebaseErrorMessage(e.code);
    } catch (e) {
      _error = 'An unexpected error occurred:  [${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      if (_firebaseUser != null && !_firebaseUser!.emailVerified) {
        await _firebaseUser!.sendEmailVerification();
      }
    } catch (e) {
      _error = 'Error sending email verification: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> resendEmailVerification(String email) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.sendEmailVerification(email);
      
      if (!response['success']) {
        _error = response['error']?['message'] ?? 'Failed to send verification email';
      }
    } catch (e) {
      _error = 'Error sending email verification: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Update in Firebase Auth
      if (_firebaseUser != null) {
        if (displayName != null) {
          await _firebaseUser!.updateDisplayName(displayName);
        }
        if (photoURL != null) {
          await _firebaseUser!.updatePhotoURL(photoURL);
        }
      }

      // Update in backend
      final response = await _apiService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      if (response['success']) {
        final userData = response['data']['user'];
        _user = UserModel.fromJson(userData);
        await _saveUserData();
      } else {
        _error = response['error']?['message'] ?? 'Failed to update profile';
      }
    } catch (e) {
      _error = 'Error updating profile: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Delete from backend first
      final response = await _apiService.deleteAccount();
      
      if (response['success']) {
        // Delete from Firebase Auth
        if (_firebaseUser != null) {
          await _firebaseUser!.delete();
        }
        
        _user = null;
        await _clearUserData();
      } else {
        _error = response['error']?['message'] ?? 'Failed to delete account';
      }
    } catch (e) {
      _error = 'Error deleting account: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    try {
      if (_firebaseUser != null) {
        final response = await _apiService.getCurrentUser();
        
        if (response['success']) {
          final userData = response['data']['user'];
          _user = UserModel.fromJson(userData);
          await _saveUserData();
          notifyListeners();
        }
      }
    } catch (e) {
      _error = 'Error refreshing user data: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<bool> testBackendConnection() async {
    try {
      return await _apiService.testConnection();
    } catch (e) {
      _error = 'Connection test failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<Map<String, dynamic>> testEmailConfiguration(String testEmail) async {
    try {
      return await _apiService.testEmailConfig(testEmail);
    } catch (e) {
      _error = 'Email configuration test failed: ${e.toString()}';
      notifyListeners();
      return {
        'success': false,
        'error': {
          'message': _error,
          'code': 'EMAIL_CONFIG_TEST_FAILED'
        }
      };
    }
  }

  Future<Map<String, dynamic>> testSignupProcess({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      print('Testing signup process...'); // Debug log
      
      // Test minimal signup endpoint first
      final minimalResponse = await _apiService.testMinimalSignup(
        email: email,
        password: password,
        displayName: displayName,
      );

      print('Minimal signup response: $minimalResponse'); // Debug log
      
      if (minimalResponse['success']) {
        final userData = minimalResponse['data']['user'];
        print('Minimal user data: $userData'); // Debug log
        print('Minimal user data type: ${userData.runtimeType}'); // Debug log
        
        // Try to parse the user data
        try {
          final userModel = UserModel.fromJson(userData);
          print('Minimal user model created successfully'); // Debug log
          return {
            'success': true,
            'message': 'Minimal signup test successful',
            'user': userModel.toJson()
          };
        } catch (parseError) {
          print('Minimal parse error: $parseError'); // Debug log
          return {
            'success': false,
            'error': {
              'message': 'Failed to parse minimal user data: ${parseError.toString()}',
              'code': 'PARSE_ERROR',
              'userData': userData
            }
          };
        }
      } else {
        return {
          'success': false,
          'error': minimalResponse['error'] ?? { 'message': 'Minimal signup failed' }
        };
      }
    } catch (e) {
      print('Test signup error: $e'); // Debug log
      return {
        'success': false,
        'error': {
          'message': 'Test signup failed: ${e.toString()}',
          'code': 'TEST_SIGNUP_FAILED'
        }
      };
    }
  }

  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_user != null) {
        await prefs.setString('user_id', _user!.id);
        await prefs.setString('user_email', _user!.email);
        if (_user!.displayName != null) {
          await prefs.setString('user_name', _user!.displayName!);
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('user_email');
      await prefs.remove('user_name');
    } catch (e) {
      // Handle error silently
    }
  }

  String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'invalid-credential':
        return 'Invalid credentials.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address but different sign-in credentials.';
      case 'requires-recent-login':
        return 'This operation is sensitive and requires recent authentication.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 