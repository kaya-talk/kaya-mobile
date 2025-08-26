import 'package:flutter/foundation.dart';
import 'package:kaya_app/core/models/kaya_model.dart';
import 'package:kaya_app/core/services/guide_storage_service.dart';

class GuideProvider extends ChangeNotifier {
  KayaModel? _currentGuide;
  bool _isLoading = false;
  bool _hasInitialized = false;

  // Getters
  KayaModel? get currentGuide => _currentGuide;
  bool get isLoading => _isLoading;
  bool get hasInitialized => _hasInitialized;
  bool get hasGuide => _currentGuide != null;

  // Initialize the provider
  Future<void> initialize() async {
    if (_hasInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      // Try to load the stored guide
      final storedGuide = await GuideStorageService.getGuide();
      if (storedGuide != null) {
        _currentGuide = storedGuide;
      } else {
        // Use default guide if none exists
        _currentGuide = GuideStorageService.getDefaultGuide();
      }
    } catch (e) {
      print('Error initializing guide provider: $e');
      // Fallback to default guide
      _currentGuide = GuideStorageService.getDefaultGuide();
    } finally {
      _isLoading = false;
      _hasInitialized = true;
      notifyListeners();
    }
  }

  // Update the current guide
  Future<void> updateGuide(KayaModel newGuide) async {
    try {
      await GuideStorageService.saveGuide(newGuide);
      _currentGuide = newGuide;
      notifyListeners();
    } catch (e) {
      print('Error updating guide: $e');
      rethrow;
    }
  }

  // Refresh guide from storage
  Future<void> refreshGuide() async {
    try {
      final storedGuide = await GuideStorageService.getGuide();
      if (storedGuide != null) {
        _currentGuide = storedGuide;
        notifyListeners();
      }
    } catch (e) {
      print('Error refreshing guide: $e');
    }
  }

  // Clear the current guide
  Future<void> clearGuide() async {
    try {
      await GuideStorageService.clearGuide();
      _currentGuide = null;
      notifyListeners();
    } catch (e) {
      print('Error clearing guide: $e');
      rethrow;
    }
  }

  // Get guide with fallback
  KayaModel getGuideOrDefault() {
    return _currentGuide ?? GuideStorageService.getDefaultGuide();
  }

  // Check if guide has specific personality trait
  bool hasPersonalityTrait(String trait) {
    if (_currentGuide == null) return false;
    return _currentGuide!.personalityTraits
        .any((t) => t.toLowerCase().contains(trait.toLowerCase()));
  }

  // Get guide's age group
  String getAgeGroup() {
    if (_currentGuide == null) return 'adult';
    
    final age = _currentGuide!.age;
    if (age < 25) return 'young adult';
    if (age < 35) return 'adult';
    if (age < 50) return 'mature adult';
    if (age < 65) return 'experienced adult';
    return 'wise elder';
  }

  // Get personalized greeting based on context
  String getPersonalizedGreeting(String context) {
    if (_currentGuide == null) {
      return "Hi there! How can I help you today?";
    }

    final guide = _currentGuide!;
    final name = guide.name;
    
    switch (context.toLowerCase()) {
      case 'morning':
        return "Good morning! I'm $name, ready to start the day with you.";
      case 'evening':
        return "Good evening! I'm $name, here to wind down with you.";
      case 'welcome':
        return "Welcome back! I'm $name, your AI wellness companion.";
      case 'chat':
        return "Hi! I'm $name. What's on your mind right now?";
      case 'journal':
        return "Hello! I'm $name. Ready to reflect together?";
      case 'mood':
        return "Hi there! I'm $name. How are you feeling today?";
      default:
        return "Hi! I'm $name. How can I support you today?";
    }
  }

  // Get guide's response style based on context
  String getResponseStyle(String context) {
    if (_currentGuide == null) return 'neutral';
    
    final guide = _currentGuide!;
    final traits = guide.personalityTraits.map((t) => t.toLowerCase()).toList();
    
    if (traits.contains('empathetic') || traits.contains('caring')) {
      return 'empathetic';
    } else if (traits.contains('analytical') || traits.contains('thoughtful')) {
      return 'analytical';
    } else if (traits.contains('creative') || traits.contains('inspiring')) {
      return 'creative';
    } else if (traits.contains('practical') || traits.contains('grounded')) {
      return 'practical';
    }
    
    return 'neutral';
  }

  // Get guide's preferred communication style
  String getCommunicationStyle() {
    if (_currentGuide == null) return 'balanced';
    
    final guide = _currentGuide!;
    final age = guide.age;
    
    if (age < 25) return 'casual';
    if (age < 40) return 'friendly';
    if (age < 60) return 'professional';
    return 'wise';
  }

  // Check if guide is suitable for specific content
  bool isSuitableForContent(String contentType) {
    if (_currentGuide == null) return true;
    
    final guide = _currentGuide!;
    final traits = guide.personalityTraits.map((t) => t.toLowerCase()).toList();
    
    switch (contentType.toLowerCase()) {
      case 'emotional':
        return traits.contains('empathetic') || traits.contains('caring') || traits.contains('nurturing');
      case 'analytical':
        return traits.contains('analytical') || traits.contains('thoughtful') || traits.contains('practical');
      case 'creative':
        return traits.contains('creative') || traits.contains('inspiring') || traits.contains('energetic');
      case 'practical':
        return traits.contains('practical') || traits.contains('grounded') || traits.contains('experienced');
      default:
        return true;
    }
  }
}
