import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaya_app/core/theme/app_theme.dart';

class ResetPasswordSentScreen extends StatelessWidget {
  const ResetPasswordSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Container(
                width: double.infinity,
                color: const Color(0xFF2E1065),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Row(
                        children: const [
                          Icon(Icons.email_outlined, color: Color(0xFFB6A9E5), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Check your inbox',
                            style: TextStyle(
                              color: Color(0xFFB6A9E5),
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "We've sent a reset link to your email.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "It might take a moment to arrive — and sometimes it hides in your spam folder.\n\nWe'll be right here when you're ready to come back.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFA78BFA), Color(0xFFF9A8D4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(25, -30),
                            child: Transform.rotate(
                              angle: -0.785, // about -45 degrees in radians
                              child: const Icon(
                                Icons.send,
                                size: 64,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // const Spacer(),
                    const SizedBox(height: 96),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                            SizedBox(width: 4),
                            Text(
                              'Return to login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32.0),
                      child: Center(
                        child: Text(
                          "Need help? We're here for you.",
                          style: TextStyle(
                            color: Color(0xFFB6A9E5),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 