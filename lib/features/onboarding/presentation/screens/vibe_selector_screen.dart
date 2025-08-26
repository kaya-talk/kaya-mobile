import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaya_app/core/theme/app_theme.dart';
import 'package:kaya_app/core/models/kaya_model.dart';
import 'package:kaya_app/core/providers/guide_provider.dart';
import 'package:provider/provider.dart';

class VibeSelectorScreen extends StatefulWidget {
  const VibeSelectorScreen({super.key});

  @override
  State<VibeSelectorScreen> createState() => _VibeSelectorScreenState();
}

class _VibeSelectorScreenState extends State<VibeSelectorScreen> {
  int _step = 0;
  String? _selectedVibe;

  // For guide selection (placeholder)
  String? _selectedGuide;

  // For personality, gender, etc. (placeholder)
  // ...

  void _nextStep() {
    setState(() {
      _step++;
    });
  }

  void _prevStep() {
    setState(() {
      if (_step > 0) _step--;
    });
  }

  void _finishOnboarding() {
    // TODO: Save onboarding data
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    Widget stepWidget;
    switch (_step) {
      case 0:
        stepWidget = _WelcomeStep(onNext: _nextStep);
        break;
      case 1:
        stepWidget = _TrustStep(onNext: _nextStep, onBack: _prevStep);
        break;
      case 2:
        stepWidget = _GuideStep(onNext: _nextStep, onBack: _prevStep);
        break;
      case 3:
      default:
        stepWidget = _VibeStep(
          onFinish: _finishOnboarding,
          onBack: _prevStep,
          selectedVibe: _selectedVibe,
          onSelectVibe: (v) => setState(() => _selectedVibe = v),
        );
        break;
    }
    return Scaffold(
      backgroundColor: const Color(0xFF2E1065),
      body: SafeArea(child: stepWidget),
    );
  }
}

// --- Step 1: Welcome ---
class _WelcomeStep extends StatelessWidget {
  final VoidCallback onNext;
  const _WelcomeStep({required this.onNext});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          // Kaya logo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/kaya-logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome to Kaya',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xFF4B2996),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Silence needs company',
              style: TextStyle(
                color: Color(0xFFB6A9E5),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Intro video section (placeholder)
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFF3B2170),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF4B2996)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4B2996),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Watch our introduction',
                  style: TextStyle(
                    color: Color(0xFFB6A9E5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Get Started button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 0,
              ),
              child: const Text('Get Started'),
            ),
          ),
          const SizedBox(height: 16),
          // Watch Tutorials button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tutorials'),
                    content: const Text('Tutorial videos coming soon!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.play_circle_outline, color: Color(0xFFB6A9E5)),
              label: const Text('Watch Tutorials'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: const Color(0xFF4B2996),
                foregroundColor: const Color(0xFFB6A9E5),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 0,
              ),
            ),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(bottom: 24.0),
            child: Text(
              'A safe space for your thoughts',
              style: TextStyle(
                color: Color(0xFFB6A9E5),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step 2: Trust ---
class _TrustStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TrustStep({required this.onNext, required this.onBack});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          // Moon icon and headline
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Icon(Icons.nightlight_round, color: Color(0xFFB6A9E5), size: 28),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  "Before we continue, let's build trust.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Kaya is here to support you — safely, gently, and privately.',
            style: TextStyle(
              color: Color(0xFFB6A9E5),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 8),
          const Text(
            'Your reflections, messages, and moods stay between you and Kaya.',
            style: TextStyle(
              color: Color(0xFFB6A9E5),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 32),
          // Info card 1
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B2170),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFFB6A9E5)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We store your data securely to help you track patterns and feelings over time.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.delete_outline, color: Color(0xFFB6A9E5)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can delete anything, anytime.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Info card 2
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF3B2170),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFFB6A9E5)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Kaya isn't a therapist and doesn't replace professional help.",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.volunteer_activism, color: Color(0xFFB6A9E5)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "In a crisis, we'll gently guide you to real-world support.",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Agree button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: const Color(0xFF8B5CF6),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 0,
              ),
              child: const Text('I understand & agree'),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              // TODO: Open privacy policy
            },
            child: const Text(
              'Review full privacy policy',
              style: TextStyle(
                color: Color(0xFFB6A9E5),
                fontSize: 15,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Step 3: Guide ---
class _GuideStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _GuideStep({required this.onNext, required this.onBack});
  @override
  State<_GuideStep> createState() => _GuideStepState();
}

class _GuideStepState extends State<_GuideStep> {
  int _selectedGuide = 0;
  String _selectedGender = 'Female';
  double _age = 30;
  final List<String> _personalities = [
    'Empathetic', 'Analytical', 'Creative', 'Nurturing', 'Practical', 'Calm'
  ];
  final Set<String> _selectedPersonalities = {};
  final TextEditingController _nameController = TextEditingController(text: 'Maya');

  final List<_GuideOption> _guides = [
    _GuideOption('Maya', 'Empathetic listener, 35', 'assets/images/guide_maya.png'),
    _GuideOption('David', 'Thoughtful guide, 42', 'assets/images/guide_david.png'),
    _GuideOption('Zoe', 'Creative mentor, 28', 'assets/images/guide_zoe.png'),
    _GuideOption('Thomas', 'Wise counselor, 58', 'assets/images/guide_thomas.png'),
  ];

  void _finishOnboarding() async {
    // Create the guide
    final guide = KayaModel(
      name: _nameController.text.trim().isEmpty ? _guides[_selectedGuide].name : _nameController.text.trim(),
      age: _age.round(),
      sex: _selectedGender,
      personalityTraits: _selectedPersonalities.isEmpty 
          ? ['Empathetic', 'Understanding'] 
          : _selectedPersonalities.toList(),
      customDescription: _guides[_selectedGuide].role,
    );
    
    // Save the guide using the provider
    final guideProvider = Provider.of<GuideProvider>(context, listen: false);
    await guideProvider.updateGuide(guide);
    
    // Navigate to home
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Choose Your Guide',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a guide you feel comfortable sharing with',
            style: TextStyle(
              color: Color(0xFFB6A9E5),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Who would you like to talk to?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Guide selection grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.95,
            ),
            itemCount: _guides.length,
            itemBuilder: (context, index) {
              final guide = _guides[index];
              final isSelected = _selectedGuide == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedGuide = index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF4B2996) : const Color(0xFF3B2170),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(guide.avatar),
                        radius: 32,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        guide.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        guide.role,
                        style: const TextStyle(
                          color: Color(0xFFB6A9E5),
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Customize your guide',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Gender selection
          Row(
            children: [
              for (final gender in ['Female', 'Male', 'Non-binary'])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(gender),
                    selected: _selectedGender == gender,
                    onSelected: (_) => setState(() => _selectedGender = gender),
                    selectedColor: const Color(0xFF8B5CF6),
                    backgroundColor: const Color(0xFF3B2170),
                    labelStyle: TextStyle(
                      color: _selectedGender == gender ? Colors.white : const Color(0xFFB6A9E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Age slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('20s', style: TextStyle(color: Color(0xFFB6A9E5))),
              Text('30s', style: TextStyle(color: Color(0xFFB6A9E5))),
              Text('40s', style: TextStyle(color: Color(0xFFB6A9E5))),
              Text('50s', style: TextStyle(color: Color(0xFFB6A9E5))),
              Text('60s+', style: TextStyle(color: Color(0xFFB6A9E5))),
            ],
          ),
          Slider(
            value: _age,
            min: 20,
            max: 65,
            divisions: 4,
            label: _age.round().toString(),
            onChanged: (value) => setState(() => _age = value),
            activeColor: const Color(0xFF8B5CF6),
            inactiveColor: const Color(0xFF3B2170),
          ),
          const SizedBox(height: 8),
          // Personality chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final p in _personalities)
                FilterChip(
                  label: Text(p),
                  selected: _selectedPersonalities.contains(p),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        if (_selectedPersonalities.length < 3) {
                          _selectedPersonalities.add(p);
                        }
                      } else {
                        _selectedPersonalities.remove(p);
                      }
                    });
                  },
                  selectedColor: const Color(0xFF8B5CF6),
                  backgroundColor: const Color(0xFF3B2170),
                  labelStyle: TextStyle(
                    color: _selectedPersonalities.contains(p) ? Colors.white : const Color(0xFFB6A9E5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Guide name input
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Give your guide a name',
              labelStyle: const TextStyle(color: Color(0xFFB6A9E5)),
              filled: true,
              fillColor: const Color(0xFF3B2170),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Create My Guide button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _finishOnboarding,
              icon: const Icon(Icons.check_circle_outline, color: Colors.black),
              label: const Text('Create My Guide', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: const Color(0xFFD6C7F7),
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                elevation: 0,
              ),
            ),
          ),
          // Skip button
          Center(
            child: TextButton(
              onPressed: _finishOnboarding,
              child: const Text(
                'Skip for now and use default guide',
                style: TextStyle(
                  color: Color(0xFFB6A9E5),
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuideOption {
  final String name;
  final String role;
  final String avatar;
  _GuideOption(this.name, this.role, this.avatar);
}

// --- Step 4: Vibe Selector (original) ---
class _VibeStep extends StatelessWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  final String? selectedVibe;
  final ValueChanged<String> onSelectVibe;
  const _VibeStep({required this.onFinish, required this.onBack, required this.selectedVibe, required this.onSelectVibe});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Vibe Selector Step (UI to be implemented)'));
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