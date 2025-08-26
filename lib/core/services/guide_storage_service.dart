import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaya_app/core/models/kaya_model.dart';

class GuideStorageService {
  static const String _guideKey = 'user_guide';
  
  // Save the user's guide to local storage
  static Future<void> saveGuide(KayaModel guide) async {
    final prefs = await SharedPreferences.getInstance();
    final guideJson = jsonEncode(guide.toJson());
    await prefs.setString(_guideKey, guideJson);
  }
  
  // Get the user's guide from local storage
  static Future<KayaModel?> getGuide() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final guideJson = prefs.getString(_guideKey);
      
      if (guideJson != null) {
        final guideMap = jsonDecode(guideJson) as Map<String, dynamic>;
        return KayaModel.fromJson(guideMap);
      }
      
      return null;
    } catch (e) {
      print('Error retrieving guide: $e');
      return null;
    }
  }
  
  // Check if user has a guide
  static Future<bool> hasGuide() async {
    final guide = await getGuide();
    return guide != null;
  }
  
  // Clear the stored guide
  static Future<void> clearGuide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_guideKey);
  }
  
  // Get default guide if none exists
  static KayaModel getDefaultGuide() {
    return KayaModel(
      name: 'Kaya',
      age: 30,
      sex: 'Female',
      personalityTraits: ['Empathetic', 'Understanding', 'Patient'],
      customDescription: 'Your AI wellness companion',
    );
  }
  
  // Update guide properties
  static Future<void> updateGuide(KayaModel guide) async {
    await saveGuide(guide);
  }
  
  // Get guide with fallback to default
  static Future<KayaModel> getGuideOrDefault() async {
    final guide = await getGuide();
    return guide ?? getDefaultGuide();
  }
}
