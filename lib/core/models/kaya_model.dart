class KayaModel {
  final String name;
  final int age;
  final String sex;
  final List<String> personalityTraits;
  final String? customDescription;

  KayaModel({
    required this.name,
    required this.age,
    required this.sex,
    required this.personalityTraits,
    this.customDescription,
  });

  factory KayaModel.fromJson(Map<String, dynamic> json) {
    return KayaModel(
      name: json['name'] ?? 'Kaya',
      age: json['age'] ?? 30,
      sex: json['sex'] ?? 'Female',
      personalityTraits: json['personalityTraits'] != null 
          ? List<String>.from(json['personalityTraits'])
          : ['Empathetic', 'Understanding'],
      customDescription: json['customDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'sex': sex,
      'personalityTraits': personalityTraits,
      'customDescription': customDescription,
    };
  }

  KayaModel copyWith({
    String? name,
    int? age,
    String? sex,
    List<String>? personalityTraits,
    String? customDescription,
  }) {
    return KayaModel(
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      customDescription: customDescription ?? this.customDescription,
    );
  }

  // Get a formatted description of Kaya
  String get description {
    if (customDescription != null && customDescription!.isNotEmpty) {
      return customDescription!;
    }
    
    final ageGroup = _getAgeGroup();
    final personality = personalityTraits.take(2).join(', ');
    return '$personality $ageGroup';
  }

  String _getAgeGroup() {
    if (age < 25) return 'young adult';
    if (age < 35) return 'adult';
    if (age < 50) return 'mature adult';
    if (age < 65) return 'experienced adult';
    return 'wise elder';
  }

  // Get personality-based greeting
  String getGreeting(String presence) {
    switch (presence) {
      case 'listener':
        return "Hi there. I'm $name, and I'm here to listen. What's on your mind right now?";
      case 'friend':
        return "Hey! I'm $name. How are you doing? What's on your mind right now?";
      case 'therapist':
        return "Hello. I'm $name, and I'm here to support you. What would you like to explore today?";
      case 'coach':
        return "Hi! I'm $name, and I'm here to help you move forward. What's on your mind right now?";
      default:
        return "Hi there, I'm $name. What's on your mind right now?";
    }
  }

  // Get personality-based response patterns
  Map<String, List<String>> getResponsePatterns() {
    final basePatterns = {
      'empathy': [
        "I can really feel what you're going through.",
        "That sounds really challenging.",
        "I understand how difficult this must be for you.",
        "Your feelings are completely valid.",
      ],
      'encouragement': [
        "You're doing better than you think.",
        "I believe in your strength.",
        "You have what it takes to get through this.",
        "Every step forward, no matter how small, counts.",
      ],
      'reflection': [
        "It sounds like...",
        "What I'm hearing is...",
        "It seems like you're saying...",
        "Let me make sure I understand...",
      ],
      'support': [
        "I'm here for you.",
        "You don't have to face this alone.",
        "I'm listening.",
        "Take your time, I'm not going anywhere.",
      ],
    };

    // Customize patterns based on personality traits
    final customizedPatterns = <String, List<String>>{};
    
    for (final trait in personalityTraits) {
      final lowerTrait = trait.toLowerCase();
      if (lowerTrait.contains('empathetic') || lowerTrait.contains('caring')) {
        customizedPatterns['empathy'] = basePatterns['empathy']!;
      }
      if (lowerTrait.contains('encouraging') || lowerTrait.contains('motivational')) {
        customizedPatterns['encouragement'] = basePatterns['encouragement']!;
      }
      if (lowerTrait.contains('analytical') || lowerTrait.contains('thoughtful')) {
        customizedPatterns['reflection'] = basePatterns['reflection']!;
      }
      if (lowerTrait.contains('supportive') || lowerTrait.contains('nurturing')) {
        customizedPatterns['support'] = basePatterns['support']!;
      }
    }

    // Add default patterns if none were customized
    if (customizedPatterns.isEmpty) {
      customizedPatterns['empathy'] = basePatterns['empathy']!;
      customizedPatterns['support'] = basePatterns['support']!;
    }

    return customizedPatterns;
  }
}
