import 'package:kaya_app/core/models/kaya_model.dart';

class ChatConversation {
  final String id;
  final String title;
  final String? lastMessage;
  final DateTime lastMessageTime;
  final String presence;
  final KayaModel guide;
  final int messageCount;
  final DateTime createdAt;
  final bool isActive;

  ChatConversation({
    required this.id,
    required this.title,
    this.lastMessage,
    required this.lastMessageTime,
    required this.presence,
    required this.guide,
    required this.messageCount,
    required this.createdAt,
    this.isActive = true,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      lastMessage: json['last_message'] ?? json['lastMessage'],
      lastMessageTime: DateTime.parse(json['last_message_time'] ?? json['lastMessageTime'] ?? DateTime.now().toIso8601String()),
      presence: json['presence'] ?? '',
      guide: KayaModel.fromJson(json['guide_data'] ?? json['guide']),
      messageCount: json['message_count'] ?? json['messageCount'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
      isActive: json['is_active'] ?? json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'presence': presence,
      'guide_data': guide.toJson(),
      'message_count': messageCount,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  ChatConversation copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? presence,
    KayaModel? guide,
    int? messageCount,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      presence: presence ?? this.presence,
      guide: guide ?? this.guide,
      messageCount: messageCount ?? this.messageCount,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}


