# Testing the Kaya Authentication System

## 🚀 Quick Start

The Flutter authentication system is now ready to test! Here's how to get started:

### 1. Prerequisites

- ✅ Backend server running on `http://10.0.2.2:3000/api/v1`
- ✅ Firebase project configured
- ✅ Flutter app dependencies installed

### 2. Start the Backend Server

**Option 1: Using the batch file (Windows)**
```bash
# Double-click start_backend.bat or run:
start_backend.bat
```

**Option 2: Manual start**
```bash
cd backend
npm install  # If not already installed
npm start
```

**Verify backend is running:**
- Open http://10.0.2.2:3000/health in your browser
- Should return: `{"status":"OK","timestamp":"...","uptime":...}`

### 3. Run the Flutter App

```bash
cd mobile
flutter run
```

### 4. Test the Authentication System

1. **Launch the app** - You should see the splash screen
2. **Navigate to Home** - Look for the orange "Auth Test" card
3. **Click "Open Auth Test"** - This will take you to the authentication test screen
4. **Check Connection Status** - The test screen will show if backend is connected

## 🔧 Troubleshooting Network Issues

### Common "Failed to verify with server" Errors

If you see "failed to verify with server, please check internet connection":

1. **Check Backend Status**
   - Ensure backend is running on port 3000
   - Test: http://10.0.2.2:3000/health
   - Should return JSON with status "OK"

2. **Check Network Connectivity**
   - Flutter app uses `http://10.0.2.2:3000` for backend
   - Ensure no firewall blocking localhost connections
   - Check if antivirus is blocking the connection

3. **Check Backend Logs**
   - Look at backend console for error messages
   - Check if Firebase Admin SDK is properly configured
   - Verify environment variables are set

4. **Test API Endpoints**
   ```bash
   # Test health endpoint
   curl http://10.0.2.2:3000/health
   
   # Test auth endpoint
   curl http://10.0.2.2:3000/api/v1/auth/signup
   ```

5. **Flutter Network Issues**
   - Android emulator: localhost should work
   - iOS simulator: localhost should work
   - Physical device: Use your computer's IP address instead of localhost

### Fix for Physical Devices

If testing on a physical device, update the API service:

```dart
// In mobile/lib/core/services/api_service.dart
static const String baseUrl = 'http://YOUR_COMPUTER_IP:3000/api/v1';
// Example: 'http://192.168.1.100:3000/api/v1'
```

## 🧪 Testing Features

### Authentication Test Screen

The auth test screen provides:

- **Connection Status**: Shows if backend is reachable
- **Real-time Status**: Shows Firebase and backend authentication status
- **User Data Display**: Shows user information from both Firebase and database
- **User Statistics**: Displays activity counts from the database
- **User Preferences**: Shows stored user preferences
- **Error Display**: Shows any authentication or API errors
- **Troubleshooting Guide**: Helpful tips when connection fails
- **Action Buttons**: Test various features

### Available Test Actions

1. **Test Connection** - Check if backend is reachable
2. **Refresh User Data** - Reload user profile, preferences, and statistics
3. **Update Profile** - Change display name and photo URL
4. **Update Preferences** - Modify theme and notification settings
5. **Submit Feedback** - Send test feedback to the backend
6. **Sign Out** - Test the logout functionality

## 🔄 Testing Flow

### 1. Initial State
- App starts with no authentication
- Firebase and backend show "Not signed in"
- All user data is empty
- Connection status shows backend connectivity

### 2. Connection Test
1. Open auth test screen
2. Check "Backend Connection" status
3. If not connected, follow troubleshooting steps
4. Click "Test Connection" to verify

### 3. Sign Up Process
1. Navigate to signup screen (`/signup`)
2. Enter valid email and password
3. Optionally add display name
4. Submit the form
5. Check that:
   - User is created in Firebase
   - User is created in backend database
   - Custom token is received
   - User is automatically signed in

### 4. Sign In Process
1. Navigate to login screen (`/login`)
2. Enter credentials
3. Submit the form
4. Check that:
   - Firebase authentication succeeds
   - Backend token verification works
   - User data is loaded from database

### 5. User Management
1. Use the auth test screen to:
   - View user profile and statistics
   - Update user preferences
   - Submit feedback
   - Test all user management features

## 🐛 Troubleshooting

### Backend Connection Issues

1. **Backend Not Starting**
   - Check Node.js is installed: `node --version`
   - Check dependencies: `cd backend && npm install`
   - Check environment variables in `.env` file
   - Check port 3000 is not in use

2. **Firebase Configuration Issues**
   - Check Firebase project settings
   - Verify API keys in `main.dart`
   - Ensure Firebase Auth is enabled
   - Check service account key in backend

3. **Token Verification Failed**
   - Check Firebase Admin SDK configuration
   - Verify service account key is valid
   - Check Firebase project ID matches
   - Check backend logs for detailed errors

4. **User Data Not Loading**
   - Check authentication status
   - Verify backend user endpoints
   - Check console for error messages
   - Verify database connection

### Debug Information

The auth test screen shows:
- Backend connection status
- Firebase user status
- Backend user status
- Authentication state
- Loading states
- Error messages
- User data from database

## 📱 Testing on Different Platforms

### Android
- Use Android emulator or physical device
- Ensure network connectivity
- Check Android permissions
- For physical device, use computer's IP instead of localhost

### iOS
- Use iOS simulator or physical device
- Ensure network connectivity
- Check iOS permissions
- For physical device, use computer's IP instead of localhost

### Web
- Use Chrome or Firefox
- Check browser console for errors
- Verify CORS settings
- Check network tab for failed requests

## 🔧 Manual API Testing

You can also test the backend directly:

```bash
# Test health endpoint
curl http://10.0.2.2:3000/health

# Test signup
curl -X POST http://10.0.2.2:3000/api/v1/auth/signup \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"TestPass123","displayName":"Test User"}'

# Test user profile (with valid token)
curl -X GET http://10.0.2.2:3000/api/v1/users/me \
  -H "Authorization: Bearer your-firebase-id-token"
```

## 📊 Expected Results

### Successful Connection
- ✅ Backend Connection: Connected
- ✅ Health endpoint returns status "OK"
- ✅ API endpoints respond correctly

### Successful Authentication
- ✅ Firebase user shows email
- ✅ Backend user shows database ID
- ✅ Is Authenticated: true
- ✅ User data loads from database
- ✅ Statistics show activity counts
- ✅ Preferences can be updated

### Error Handling
- ❌ Network errors show user-friendly messages
- ❌ Authentication failures trigger proper logout
- ❌ Invalid tokens are handled gracefully
- ❌ Backend errors are displayed clearly
- ❌ Connection failures show troubleshooting guide

## 🎯 Next Steps

1. **Test Connection**: Use the auth test screen to verify backend connectivity
2. **Test All Features**: Use the auth test screen to verify everything works
3. **Customize UI**: Update the auth screens to match your design
4. **Add Features**: Extend the user management system
5. **Production Setup**: Configure proper URLs and settings
6. **Generate JSON Code**: Run `flutter packages pub run build_runner build` for proper JSON serialization

## 📞 Support

If you encounter issues:
1. Check the connection status in the auth test screen
2. Follow the troubleshooting guide
3. Check the console for error messages
4. Verify backend is running and accessible
5. Check Firebase configuration
6. Review the auth test screen for detailed status

The authentication system is now fully integrated with improved error handling and troubleshooting! 🎉 