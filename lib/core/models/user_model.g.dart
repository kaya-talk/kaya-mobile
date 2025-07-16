// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      emailVerified: json['emailVerified'] as bool,
      preferences: json['preferences'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      stats: json['stats'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'emailVerified': instance.emailVerified,
      'preferences': instance.preferences,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'stats': instance.stats,
    };

UserStatistics _$UserStatisticsFromJson(Map<String, dynamic> json) =>
    UserStatistics(
      chatMessagesCount: (json['chatMessagesCount'] as num).toInt(),
      journalEntriesCount: (json['journalEntriesCount'] as num).toInt(),
      glowNotesCount: (json['glowNotesCount'] as num).toInt(),
      lettersCount: (json['lettersCount'] as num).toInt(),
      calendarEventsCount: (json['calendarEventsCount'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatisticsToJson(UserStatistics instance) =>
    <String, dynamic>{
      'chatMessagesCount': instance.chatMessagesCount,
      'journalEntriesCount': instance.journalEntriesCount,
      'glowNotesCount': instance.glowNotesCount,
      'lettersCount': instance.lettersCount,
      'calendarEventsCount': instance.calendarEventsCount,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AuthData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] == null
          ? null
          : AuthError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
      'error': instance.error,
    };

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      customToken: json['customToken'] as String?,
    );

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
      'user': instance.user,
      'customToken': instance.customToken,
    };

AuthError _$AuthErrorFromJson(Map<String, dynamic> json) => AuthError(
      message: json['message'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$AuthErrorToJson(AuthError instance) => <String, dynamic>{
      'message': instance.message,
      'code': instance.code,
    };

UserPreferences _$UserPreferencesFromJson(Map<String, dynamic> json) =>
    UserPreferences(
      theme: json['theme'] as String?,
      notifications: json['notifications'] as bool?,
      language: json['language'] as String?,
      fontSize: json['fontSize'] as String?,
      custom: json['custom'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserPreferencesToJson(UserPreferences instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'notifications': instance.notifications,
      'language': instance.language,
      'fontSize': instance.fontSize,
      'custom': instance.custom,
    };

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) =>
    FeedbackModel(
      id: json['id'] as String,
      feedbackType: json['feedbackType'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$FeedbackModelToJson(FeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'feedbackType': instance.feedbackType,
      'content': instance.content,
      'rating': instance.rating,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt,
    };
