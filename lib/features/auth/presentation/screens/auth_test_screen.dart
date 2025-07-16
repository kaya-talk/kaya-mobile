import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/providers/auth_provider.dart';
import 'package:kaya_app/core/providers/user_provider.dart';
import 'package:kaya_app/core/models/user_model.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  bool _isTestingConnection = false;
  bool _backendConnected = false;

  @override
  void initState() {
    super.initState();
    // Initialize user data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.initializeUser();
      _testBackendConnection();
    });
  }

  Future<void> _testBackendConnection() async {
    setState(() {
      _isTestingConnection = true;
    });
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isConnected = await authProvider.testBackendConnection();
    
    setState(() {
      _backendConnected = isConnected;
      _isTestingConnection = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Test'),
        backgroundColor: const Color(0xFF2E1065),
        foregroundColor: Colors.white,
      ),
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, authProvider, userProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Auth Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Authentication Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Firebase User: ${authProvider.firebaseUser?.email ?? 'Not signed in'}'),
                        Text('Backend User: ${authProvider.user?.email ?? 'Not verified'}'),
                        Text('Is Authenticated: ${authProvider.isAuthenticated}'),
                        Text('Is Initialized: ${authProvider.isInitialized}'),
                        if (authProvider.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: LinearProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Connection Status Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Backend Connection',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              _backendConnected ? Icons.check_circle : Icons.error,
                              color: _backendConnected ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _backendConnected ? 'Connected' : 'Not Connected',
                              style: TextStyle(
                                color: _backendConnected ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Backend URL: http://10.0.2.2:3000'),
                        if (_isTestingConnection)
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: LinearProgressIndicator(),
                          ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _isTestingConnection ? null : _testBackendConnection,
                          child: Text(_isTestingConnection ? 'Testing...' : 'Test Connection'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Troubleshooting Card
                if (!_backendConnected)
                  Card(
                    color: Colors.orange.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Troubleshooting',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Backend connection failed. Please check:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          const Text('• Backend server is running on http://10.0.2.2:3000'),
                          const Text('• No firewall blocking the connection'),
                          const Text('• Network connectivity is working'),
                          const Text('• Backend health endpoint is accessible'),
                          const SizedBox(height: 8),
                          const Text(
                            'To start the backend server:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'cd backend\nnpm start',
                              style: TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // User Data Card
                if (authProvider.user != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('ID: ${authProvider.user!.id}'),
                          Text('UID: ${authProvider.user!.uid}'),
                          Text('Email: ${authProvider.user!.email}'),
                          Text('Display Name: ${authProvider.user!.displayName ?? 'Not set'}'),
                          Text('Email Verified: ${authProvider.user!.emailVerified}'),
                          Text('Created At: ${authProvider.user!.createdAt ?? 'Unknown'}'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // User Statistics Card
                if (userProvider.statistics != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text('Chat Messages: ${userProvider.statistics!.chatMessagesCount}'),
                          Text('Journal Entries: ${userProvider.statistics!.journalEntriesCount}'),
                          Text('Glow Notes: ${userProvider.statistics!.glowNotesCount}'),
                          Text('Letters: ${userProvider.statistics!.lettersCount}'),
                          Text('Calendar Events: ${userProvider.statistics!.calendarEventsCount}'),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // User Preferences Card
                if (userProvider.preferences.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Preferences',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...userProvider.preferences.entries.map(
                            (entry) => Text('${entry.key}: ${entry.value}'),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Error Display
                if (authProvider.error != null || userProvider.error != null)
                  Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Errors',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (authProvider.error != null)
                            Text(
                              'Auth Error: ${authProvider.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          if (userProvider.error != null)
                            Text(
                              'User Error: ${userProvider.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                // Action Buttons
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Actions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Refresh User Data
                        ElevatedButton(
                          onPressed: userProvider.isLoading ? null : () {
                            userProvider.refreshUserData();
                          },
                          child: const Text('Refresh User Data'),
                        ),
                        const SizedBox(height: 8),

                        // Update Profile
                        ElevatedButton(
                          onPressed: userProvider.isLoading ? null : () {
                            _showUpdateProfileDialog(context, userProvider);
                          },
                          child: const Text('Update Profile'),
                        ),
                        const SizedBox(height: 8),

                        // Update Preferences
                        ElevatedButton(
                          onPressed: userProvider.isLoading ? null : () {
                            _showUpdatePreferencesDialog(context, userProvider);
                          },
                          child: const Text('Update Preferences'),
                        ),
                        const SizedBox(height: 8),

                        // Submit Feedback
                        ElevatedButton(
                          onPressed: userProvider.isLoading ? null : () {
                            _showSubmitFeedbackDialog(context, userProvider);
                          },
                          child: const Text('Submit Feedback'),
                        ),
                        const SizedBox(height: 8),

                        // Sign Out
                        ElevatedButton(
                          onPressed: authProvider.isLoading ? null : () {
                            authProvider.signOut();
                            userProvider.clearUserData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Sign Out'),
                        ),
                        const SizedBox(height: 8),

                        // Test Email Configuration
                        ElevatedButton(
                          onPressed: () {
                            _showTestEmailConfigDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Email Config'),
                        ),
                        const SizedBox(height: 8),

                        // Test Signup Process
                        ElevatedButton(
                          onPressed: () {
                            _showTestSignupDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Signup Process'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showUpdateProfileDialog(BuildContext context, UserProvider userProvider) {
    final displayNameController = TextEditingController(
      text: userProvider.user?.displayName ?? '',
    );
    final photoURLController = TextEditingController(
      text: userProvider.user?.photoURL ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                hintText: 'Enter display name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: photoURLController,
              decoration: const InputDecoration(
                labelText: 'Photo URL',
                hintText: 'Enter photo URL',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userProvider.updateProfile(
                displayName: displayNameController.text.trim().isEmpty 
                    ? null 
                    : displayNameController.text.trim(),
                photoURL: photoURLController.text.trim().isEmpty 
                    ? null 
                    : photoURLController.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showUpdatePreferencesDialog(BuildContext context, UserProvider userProvider) {
    final themeController = TextEditingController(
      text: userProvider.getPreference<String>('theme', defaultValue: 'system') ?? 'system',
    );
    final notificationsController = TextEditingController(
      text: (userProvider.getPreference<bool>('notifications_enabled', defaultValue: true) ?? true).toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Preferences'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: themeController,
              decoration: const InputDecoration(
                labelText: 'Theme',
                hintText: 'light, dark, or system',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notificationsController,
              decoration: const InputDecoration(
                labelText: 'Notifications Enabled',
                hintText: 'true or false',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newPreferences = {
                'theme': themeController.text.trim(),
                'notifications_enabled': notificationsController.text.trim().toLowerCase() == 'true',
              };
              userProvider.updatePreferences(newPreferences);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showSubmitFeedbackDialog(BuildContext context, UserProvider userProvider) {
    final contentController = TextEditingController();
    final ratingController = TextEditingController(text: '5');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                labelText: 'Feedback',
                hintText: 'Enter your feedback',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ratingController,
              decoration: const InputDecoration(
                labelText: 'Rating (1-5)',
                hintText: 'Enter rating',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final rating = int.tryParse(ratingController.text.trim());
              userProvider.submitFeedback(
                feedbackType: 'general',
                content: contentController.text.trim(),
                rating: rating,
                metadata: {
                  'source': 'test_screen',
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feedback submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showTestEmailConfigDialog(BuildContext context) {
    final emailController = TextEditingController(
      text: 'test@example.com',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Email Configuration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This will test the backend email configuration and Firebase setup.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Test Email',
                hintText: 'Enter email to test configuration',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final response = await authProvider.testEmailConfiguration(emailController.text.trim());
                
                if (response['success']) {
                  final data = response['data'];
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Email Configuration Test Results'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildConfigItem('Firebase', data['firebase']['status'], data['firebase']['message']),
                            const SizedBox(height: 8),
                            _buildConfigItem('Email', data['email']['status'], data['email']['message']),
                            const SizedBox(height: 16),
                            const Text('Environment Variables:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            _buildConfigItem('SMTP Host', data['environment']['smtpHost']),
                            _buildConfigItem('SMTP User', data['environment']['smtpUser']),
                            _buildConfigItem('SMTP Pass', data['environment']['smtpPass']),
                            _buildConfigItem('Email From', data['environment']['emailFrom']),
                            _buildConfigItem('Frontend URL', data['environment']['frontendUrl']),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Test failed: ${response['error']?['message'] ?? 'Unknown error'}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Test failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }

  void _showTestSignupDialog(BuildContext context) {
    final emailController = TextEditingController(
      text: 'test.signup@example.com',
    );
    final passwordController = TextEditingController(
      text: 'test123',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Test Signup Process'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email for signup',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password for signup',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              
              try {
                final authProvider = Provider.of<AuthProvider>(context, listen: false);
                final response = await authProvider.testSignupProcess(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                );
                
                if (response['success']) {
                  final user = response['user'];
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Signup Test Successful'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('User ID: ${user['id']}'),
                            Text('UID: ${user['uid']}'),
                            Text('Email: ${user['email']}'),
                            Text('Display Name: ${user['displayName'] ?? 'Not set'}'),
                            Text('Email Verified: ${user['emailVerified']}'),
                            Text('Created At: ${user['createdAt'] ?? 'Unknown'}'),
                            const SizedBox(height: 16),
                            const Text(
                              'Note: This was a test signup. The user was created in the backend but not in Firebase Auth.',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Signup test failed: ${response['error']?['message'] ?? 'Unknown error'}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Signup test failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String label, String status, [String? message]) {
    final isConfigured = status == 'configured' || status == 'user_exists' || status == 'user_not_found';
    final color = isConfigured ? Colors.green : Colors.red;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isConfigured ? Icons.check_circle : Icons.error,
            color: color,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label: $status',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                if (message != null)
                  Text(
                    message,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 