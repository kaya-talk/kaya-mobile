import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:provider/provider.dart';
import 'package:kaya_app/core/routes/app_router.dart';
import 'package:kaya_app/core/theme/app_theme.dart';
import 'package:kaya_app/core/providers/auth_provider.dart';
import 'package:kaya_app/core/providers/theme_provider.dart';
import 'package:kaya_app/core/providers/user_provider.dart';
import 'package:kaya_app/core/providers/guide_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with custom options
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCAxXT41Pg1TRGwqjCWBcNuLFS0EiSre_w',
      appId: '1:631496909582:android:06fa0ff3c08563ec8f2d5f',
      messagingSenderId: '631496909582',
      projectId: 'kaya-d866f',
      storageBucket: 'kaya-d866f.firebasestorage.app',
    ),
  );
  
  // Initialize Firebase Analytics
  // await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  
  runApp(const KayaApp());
}

class KayaApp extends StatelessWidget {
  const KayaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GuideProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'Kaya',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            builder: (context, child) {
              // Initialize guide provider when the app builds
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final guideProvider = Provider.of<GuideProvider>(context, listen: false);
                guideProvider.initialize();
              });
              
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
} 