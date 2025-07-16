# Kaya Flutter App Authentication System

This document explains how the authentication system works in the Kaya Flutter app and how to integrate it with your backend.

## Overview

The authentication system uses Firebase Auth for client-side authentication and integrates with your Node.js backend for user data management. The system provides:

- User registration and login with Firebase Auth
- Backend verification and user data synchronization
- User profile management
- User preferences and settings
- User statistics tracking
- Feedback submission system

## Architecture

### Components

1. **AuthProvider** (`lib/core/providers/auth_provider.dart`)
   - Manages Firebase Auth state
   - Handles signup, login, logout
   - Verifies tokens with backend
   - Manages user authentication state

2. **UserProvider** (`lib/core/providers/user_provider.dart`)
   - Manages user data and preferences
   - Handles profile updates
   - Manages user statistics
   - Handles feedback submission

3. **ApiService** (`lib/core/services/api_service.dart`)
   - Handles all HTTP communication with backend
   - Manages authentication tokens
   - Provides error handling

4. **UserService** (`lib/core/services/user_service.dart`)
   - High-level user operations
   - Preference management
   - Feedback submission helpers

5. **User Models** (`lib/core/models/user_model.dart`)
   - Data models for user information
   - JSON serialization support

## Setup Instructions

### 1. Generate JSON Serialization Code

Run the following command to generate the JSON serialization code for the models:

```bash
flutter packages pub run build_runner build
```

### 2. Configure Backend URL

Update the backend URL in `lib/core/services/api_service.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:3000/api/v1';
```

For production, change this to your actual backend URL.

### 3. Firebase Configuration

Ensure your Firebase configuration is properly set up in `lib/main.dart` with the correct Firebase project details.

## Usage Examples

### Authentication Flow

#### 1. User Registration

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

await authProvider.signUp(
  email: 'user@example.com',
  password: 'SecurePassword123',
  displayName: 'John Doe',
);
```

#### 2. User Login

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

await authProvider.signIn(
  email: 'user@example.com',
  password: 'SecurePassword123',
);
```

#### 3. Check Authentication Status

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);

if (authProvider.isAuthenticated) {
  // User is logged in
  print('User: ${authProvider.user?.email}');
} else {
  // User is not logged in
}
```

### User Management

#### 1. Initialize User Data

```dart
final userProvider = Provider.of<UserProvider>(context, listen: false);

await userProvider.initializeUser();
```

#### 2. Update User Profile

```dart
final userProvider = Provider.of<UserProvider>(context, listen: false);

await userProvider.updateProfile(
  displayName: 'Jane Doe',
  photoURL: 'https://example.com/photo.jpg',
);
```

#### 3. Manage User Preferences

```dart
final userProvider = Provider.of<UserProvider>(context, listen: false);

// Update specific preference
await userProvider.updatePreference('theme', 'dark');

// Update multiple preferences
await userProvider.updatePreferences({
  'theme': 'dark',
  'notifications_enabled': true,
  'language': 'en',
});

// Get specific preference
String theme = userProvider.getPreference<String>('theme', defaultValue: 'system') ?? 'system';
```

#### 4. Submit Feedback

```dart
final userProvider = Provider.of<UserProvider>(context, listen: false);

// Submit general feedback
await userProvider.submitFeedback(
  feedbackType: 'general',
  content: 'Great app!',
  rating: 5,
  metadata: {'source': 'app'},
);

// Submit bug report
await userProvider.submitBugReport(
  description: 'App crashes on startup',
  steps: '1. Open app\n2. App crashes immediately',
  appVersion: '1.0.0',
  platform: 'android',
);

// Submit feature request
await userProvider.submitFeatureRequest(
  title: 'Dark Mode',
  description: 'Please add dark mode support',
  priority: 3,
);
```

### Error Handling

The system provides comprehensive error handling:

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final userProvider = Provider.of<UserProvider>(context, listen: false);

// Check for errors
if (authProvider.error != null) {
  print('Auth error: ${authProvider.error}');
}

if (userProvider.error != null) {
  print('User error: ${userProvider.error}');
}

// Clear errors
authProvider.clearError();
userProvider.clearError();
```

## Testing

### Auth Test Screen

A test screen is provided at `lib/features/auth/presentation/screens/auth_test_screen.dart` that demonstrates all the authentication and user management features.

To use it, add it to your app router or navigate to it directly:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const AuthTestScreen()),
);
```

### Manual Testing

1. **Signup Flow:**
   - Navigate to signup screen
   - Enter email, password, and display name
   - Submit form
   - Check that user is created in both Firebase and backend

2. **Login Flow:**
   - Navigate to login screen
   - Enter credentials
   - Submit form
   - Check that user is authenticated and data is loaded

3. **User Management:**
   - Use the test screen to update profile
   - Update preferences
   - Submit feedback
   - Check that changes are reflected in the backend

## Backend Integration

The Flutter app expects the following backend endpoints to be available:

### Authentication Endpoints
- `POST /api/v1/auth/signup` - User registration
- `POST /api/v1/auth/verify-token` - Token verification
- `POST /api/v1/auth/verify-email` - Email verification
- `POST /api/v1/auth/reset-password` - Password reset
- `GET /api/v1/auth/me` - Get current user
- `PUT /api/v1/auth/profile` - Update profile
- `DELETE /api/v1/auth/account` - Delete account

### User Management Endpoints
- `GET /api/v1/users/me` - Get user profile with statistics
- `PUT /api/v1/users/me` - Update user profile
- `GET /api/v1/users/preferences` - Get user preferences
- `PUT /api/v1/users/preferences` - Update user preferences
- `POST /api/v1/users/feedback` - Submit feedback
- `GET /api/v1/users/statistics` - Get user statistics

## Security Considerations

1. **Token Management:**
   - Firebase ID tokens are automatically managed
   - Tokens are stored securely in SharedPreferences
   - Tokens are refreshed automatically when needed

2. **Error Handling:**
   - All API errors are properly handled and displayed
   - Network errors are gracefully handled
   - Authentication failures trigger proper logout

3. **Data Validation:**
   - Input validation is performed on both client and server
   - Password requirements are enforced
   - Email format validation is implemented

## Troubleshooting

### Common Issues

1. **Backend Connection Failed:**
   - Check that the backend is running on the correct URL
   - Verify network connectivity
   - Check CORS settings on the backend

2. **Firebase Configuration Issues:**
   - Verify Firebase project configuration
   - Check that Firebase Auth is enabled
   - Ensure correct API keys are used

3. **Token Verification Failed:**
   - Check that Firebase Admin SDK is properly configured on backend
   - Verify that the Firebase project ID matches
   - Check that the service account key is valid

4. **User Data Not Loading:**
   - Check that the user is properly authenticated
   - Verify that the backend user endpoints are working
   - Check for any error messages in the console

### Debug Mode

Enable debug logging by checking the console output. The ApiService includes request/response logging that can help identify issues.

## Next Steps

1. **Generate Model Code:** Run `flutter packages pub run build_runner build`
2. **Test Authentication:** Use the test screen to verify all functionality
3. **Customize UI:** Update the auth screens to match your app's design
4. **Add Features:** Extend the user management system as needed
5. **Production Setup:** Configure proper backend URLs and Firebase settings for production 