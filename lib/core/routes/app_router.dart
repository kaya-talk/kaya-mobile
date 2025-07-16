import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaya_app/features/auth/presentation/screens/splash_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/intro_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/login_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/email_confirmation_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/auth_test_screen.dart';
import 'package:kaya_app/features/onboarding/presentation/screens/vibe_selector_screen.dart';
import 'package:kaya_app/features/home/presentation/screens/home_screen.dart';
import 'package:kaya_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:kaya_app/features/journal/presentation/screens/journal_home_screen.dart';
import 'package:kaya_app/features/journal/presentation/screens/journal_compose_screen.dart';
import 'package:kaya_app/features/journal/presentation/screens/journal_archive_screen.dart';
import 'package:kaya_app/features/glow_notes/presentation/screens/glow_notes_home_screen.dart';
import 'package:kaya_app/features/glow_notes/presentation/screens/glow_notes_compose_screen.dart';
import 'package:kaya_app/features/letters/presentation/screens/letters_home_screen.dart';
import 'package:kaya_app/features/letters/presentation/screens/letters_compose_screen.dart';
import 'package:kaya_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:kaya_app/features/hold_space/presentation/screens/hold_space_screen.dart';
import 'package:kaya_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:kaya_app/features/import_export/presentation/screens/import_export_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:kaya_app/features/auth/presentation/screens/reset_password_sent_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: '/intro',
        name: 'intro',
        builder: (context, state) => const IntroScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/email-confirmation',
        name: 'email-confirmation',
        builder: (context, state) => const EmailConfirmationScreen(),
      ),
      GoRoute(
        path: '/auth-test',
        name: 'auth-test',
        builder: (context, state) => const AuthTestScreen(),
      ),
      
      // Onboarding Routes
      GoRoute(
        path: '/vibe-selector',
        name: 'vibe-selector',
        builder: (context, state) => const VibeSelectorScreen(),
      ),
      
      // Main App Routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // Chat Routes
      GoRoute(
        path: '/chat',
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      
      // Journal Routes
      GoRoute(
        path: '/journal',
        name: 'journal',
        builder: (context, state) => const JournalHomeScreen(),
      ),
      GoRoute(
        path: '/journal/compose',
        name: 'journal-compose',
        builder: (context, state) => const JournalComposeScreen(),
      ),
      GoRoute(
        path: '/journal/archive',
        name: 'journal-archive',
        builder: (context, state) => const JournalArchiveScreen(),
      ),
      
      // Glow Notes Routes
      GoRoute(
        path: '/glow-notes',
        name: 'glow-notes',
        builder: (context, state) => const GlowNotesHomeScreen(),
      ),
      GoRoute(
        path: '/glow-notes/compose',
        name: 'glow-notes-compose',
        builder: (context, state) => const GlowNotesComposeScreen(),
      ),
      
      // Letters Routes
      // GoRoute(
      //   path: '/letters',
      //   name: 'letters',
      //   builder: (context, state) => const LettersHomeScreen(),
      // ),
      GoRoute(
        path: '/letters/compose',
        name: 'letters-compose',
        builder: (context, state) => const LettersComposeScreen(),
      ),
      
      // Calendar Routes
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      
      // Hold Space Routes
      GoRoute(
        path: '/hold-space',
        name: 'hold-space',
        builder: (context, state) => const HoldSpaceScreen(),
      ),
      
      // Settings Routes
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      
      // Import/Export Routes
      GoRoute(
        path: '/import-export',
        name: 'import-export',
        builder: (context, state) => const ImportExportScreen(),
      ),
      
      // Reset Password Routes
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password-sent',
        name: 'reset-password-sent',
        builder: (context, state) => const ResetPasswordSentScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
} 