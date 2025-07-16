// Temporary user models without JSON serialization
// TODO: Run 'flutter packages pub run build_runner build' to generate proper JSON serialization

class UserModel {
  final String id;
  final String uid;
  final String email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final Map<String, dynamic>? preferences;
  final String? createdAt;
  final String? updatedAt;
  final Map<String, dynamic>? stats;

  UserModel({
    required this.id,
    required this.uid,
    required this.email,
    this.displayName,
    this.photoURL,
    required this.emailVerified,
    this.preferences,
    this.createdAt,
    this.updatedAt,
    this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Ensure preferences is a proper Map
    Map<String, dynamic>? preferences;
    if (json['preferences'] != null) {
      if (json['preferences'] is Map<String, dynamic>) {
        preferences = json['preferences'];
      } else if (json['preferences'] is Map) {
        preferences = Map<String, dynamic>.from(json['preferences']);
      } else {
        print('Warning: preferences is not a Map, using empty object. Type: ${json['preferences'].runtimeType}');
        preferences = {};
      }
    }

    // Ensure stats is a proper Map
    Map<String, dynamic>? stats;
    if (json['stats'] != null) {
      if (json['stats'] is Map<String, dynamic>) {
        stats = json['stats'];
      } else if (json['stats'] is Map) {
        stats = Map<String, dynamic>.from(json['stats']);
      } else {
        print('Warning: stats is not a Map, using null. Type: ${json['stats'].runtimeType}');
        stats = null;
      }
    }

    // Robust id parsing (string or int)
    String idValue = '';
    if (json['id'] != null) {
      if (json['id'] is int) {
        idValue = json['id'].toString();
      } else if (json['id'] is String) {
        idValue = json['id'];
      } else {
        idValue = json['id'].toString();
      }
    }

    return UserModel(
      id: idValue,
      uid: json['uid']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString(),
      photoURL: json['photoURL']?.toString(),
      emailVerified: json['emailVerified'] == true,
      preferences: preferences,
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
      stats: stats,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'preferences': preferences,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'stats': stats,
    };
  }

  UserModel copyWith({
    String? id,
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    Map<String, dynamic>? preferences,
    String? createdAt,
    String? updatedAt,
    Map<String, dynamic>? stats,
  }) {
    return UserModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      stats: stats ?? this.stats,
    );
  }
}

class UserStatistics {
  final int chatMessagesCount;
  final int journalEntriesCount;
  final int glowNotesCount;
  final int lettersCount;
  final int calendarEventsCount;

  UserStatistics({
    required this.chatMessagesCount,
    required this.journalEntriesCount,
    required this.glowNotesCount,
    required this.lettersCount,
    required this.calendarEventsCount,
  });

  factory UserStatistics.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }
    return UserStatistics(
      chatMessagesCount: parseInt(json['chatMessagesCount']),
      journalEntriesCount: parseInt(json['journalEntriesCount']),
      glowNotesCount: parseInt(json['glowNotesCount']),
      lettersCount: parseInt(json['lettersCount']),
      calendarEventsCount: parseInt(json['calendarEventsCount']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatMessagesCount': chatMessagesCount,
      'journalEntriesCount': journalEntriesCount,
      'glowNotesCount': glowNotesCount,
      'lettersCount': lettersCount,
      'calendarEventsCount': calendarEventsCount,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final AuthData? data;
  final AuthError? error;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
      error: json['error'] != null ? AuthError.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'error': error?.toJson(),
    };
  }
}

class AuthData {
  final UserModel? user;
  final String? customToken;

  AuthData({
    this.user,
    this.customToken,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      customToken: json['customToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'customToken': customToken,
    };
  }
}

class AuthError {
  final String message;
  final String code;

  AuthError({
    required this.message,
    required this.code,
  });

  factory AuthError.fromJson(Map<String, dynamic> json) {
    return AuthError(
      message: json['message'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'code': code,
    };
  }
}

class UserPreferences {
  final String? theme;
  final bool? notifications;
  final String? language;
  final String? fontSize;
  final Map<String, dynamic>? custom;

  UserPreferences({
    this.theme,
    this.notifications,
    this.language,
    this.fontSize,
    this.custom,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      theme: json['theme'],
      notifications: json['notifications'],
      language: json['language'],
      fontSize: json['fontSize'],
      custom: json['custom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'notifications': notifications,
      'language': language,
      'fontSize': fontSize,
      'custom': custom,
    };
  }
}

class FeedbackModel {
  final String id;
  final String feedbackType;
  final String content;
  final int? rating;
  final Map<String, dynamic>? metadata;
  final String createdAt;

  FeedbackModel({
    required this.id,
    required this.feedbackType,
    required this.content,
    this.rating,
    this.metadata,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] ?? '',
      feedbackType: json['feedbackType'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'],
      metadata: json['metadata'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'feedbackType': feedbackType,
      'content': content,
      'rating': rating,
      'metadata': metadata,
      'createdAt': createdAt,
    };
  }
} 