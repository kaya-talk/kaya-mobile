import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaya_app/core/theme/app_theme.dart';

class VibeSelectorScreen extends StatefulWidget {
  const VibeSelectorScreen({super.key});

  @override
  State<VibeSelectorScreen> createState() => _VibeSelectorScreenState();
}

class _VibeSelectorScreenState extends State<VibeSelectorScreen> {
  String? _selectedVibe;

  final List<VibeOption> _vibeOptions = [
    VibeOption(
      id: 'happy',
      title: 'Happy',
      description: 'Feeling joyful and content',
      icon: Icons.sentiment_very_satisfied,
      color: AppTheme.successColor,
      emoji: '😊',
    ),
    VibeOption(
      id: 'calm',
      title: 'Calm',
      description: 'Peaceful and relaxed',
      icon: Icons.sentiment_satisfied,
      color: AppTheme.infoColor,
      emoji: '😌',
    ),
    VibeOption(
      id: 'excited',
      title: 'Excited',
      description: 'Energetic and enthusiastic',
      icon: Icons.sentiment_very_satisfied,
      color: AppTheme.accentColor,
      emoji: '🤩',
    ),
    VibeOption(
      id: 'thoughtful',
      title: 'Thoughtful',
      description: 'Reflective and contemplative',
      icon: Icons.psychology,
      color: AppTheme.secondaryColor,
      emoji: '🤔',
    ),
    VibeOption(
      id: 'stressed',
      title: 'Stressed',
      description: 'Feeling overwhelmed',
      icon: Icons.sentiment_dissatisfied,
      color: AppTheme.warningColor,
      emoji: '😰',
    ),
    VibeOption(
      id: 'sad',
      title: 'Sad',
      description: 'Feeling down or blue',
      icon: Icons.sentiment_very_dissatisfied,
      color: AppTheme.errorColor,
      emoji: '😔',
    ),
    VibeOption(
      id: 'neutral',
      title: 'Neutral',
      description: 'Just okay, nothing special',
      icon: Icons.sentiment_neutral,
      color: Colors.grey,
      emoji: '😐',
    ),
    VibeOption(
      id: 'grateful',
      title: 'Grateful',
      description: 'Appreciative and thankful',
      icon: Icons.favorite,
      color: AppTheme.primaryColor,
      emoji: '🙏',
    ),
  ];

  void _selectVibe(String vibeId) {
    setState(() {
      _selectedVibe = vibeId;
    });
  }

  void _continueToApp() {
    if (_selectedVibe != null) {
      // TODO: Save selected vibe to user preferences
      context.go('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select how you\'re feeling'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling?'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Choose Your Vibe',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  const Text(
                    'This helps Kaya understand your current state and provide better support',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Vibe options grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: _vibeOptions.length,
                    itemBuilder: (context, index) {
                      final vibe = _vibeOptions[index];
                      final isSelected = _selectedVibe == vibe.id;
                      
                      return GestureDetector(
                        onTap: () => _selectVibe(vibe.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? vibe.color.withOpacity(0.1)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                  ? vibe.color
                                  : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: vibe.color.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Emoji
                                Text(
                                  vibe.emoji,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Title
                                Text(
                                  vibe.title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? vibe.color : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                const SizedBox(height: 4),
                                
                                // Description
                                Text(
                                  vibe.description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected ? vibe.color.withOpacity(0.8) : Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Selected vibe display
                if (_selectedVibe != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _vibeOptions
                          .firstWhere((v) => v.id == _selectedVibe)
                          .color
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _vibeOptions
                              .firstWhere((v) => v.id == _selectedVibe)
                              .emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You selected: ${_vibeOptions.firstWhere((v) => v.id == _selectedVibe).title}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _vibeOptions
                                    .firstWhere((v) => v.id == _selectedVibe)
                                    .description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continueToApp,
                    child: const Text(
                      'Continue to Kaya',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VibeOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String emoji;

  VibeOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.emoji,
  });
} 