class ChatMessage {
  final String id;
  final String conversationId;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final String? presence;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.presence,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? json['conversationId'] ?? '',
      text: json['text'] ?? '',
      isFromUser: json['is_from_user'] ?? json['isFromUser'] ?? false,
      timestamp: DateTime.parse(json['created_at'] ?? json['timestamp'] ?? DateTime.now().toIso8601String()),
      presence: json['presence'],
      metadata: json['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'text': text,
      'is_from_user': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'presence': presence,
      'metadata': metadata,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? text,
    bool? isFromUser,
    DateTime? timestamp,
    String? presence,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      text: text ?? this.text,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      presence: presence ?? this.presence,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage &&
        other.id == id &&
        other.conversationId == conversationId &&
        other.text == text &&
        other.isFromUser == isFromUser &&
        other.timestamp == timestamp &&
        other.presence == presence;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        conversationId.hashCode ^
        text.hashCode ^
        isFromUser.hashCode ^
        timestamp.hashCode ^
        presence.hashCode;
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, conversationId: $conversationId, text: $text, isFromUser: $isFromUser, timestamp: $timestamp, presence: $presence)';
  }
}
