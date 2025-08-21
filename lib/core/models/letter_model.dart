class LetterModel {
  final String id;
  final String? mood;
  final String? subject;
  final String content;
  final bool isDraft;
  final String createdAt;
  final String updatedAt;

  LetterModel({
    required this.id,
    this.mood,
    this.subject,
    required this.content,
    this.isDraft = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LetterModel.fromJson(Map<String, dynamic> json) {
    return LetterModel(
      id: json['id']?.toString() ?? '',
      mood: json['mood']?.toString(),
      subject: json['subject']?.toString(),
      content: json['content']?.toString() ?? '',
      isDraft: json['is_draft'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mood': mood,
      'subject': subject,
      'content': content,
      'is_draft': isDraft,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  LetterModel copyWith({
    String? id,
    String? mood,
    String? subject,
    String? content,
    bool? isDraft,
    String? createdAt,
    String? updatedAt,
  }) {
    return LetterModel(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      subject: subject ?? this.subject,
      content: content ?? this.content,
      isDraft: isDraft ?? this.isDraft,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to format date for display
  String get formattedDate {
    if (createdAt.isEmpty) return '';
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return createdAt;
    }
  }

  // Get display title
  String get displayTitle {
    if (subject != null && subject!.isNotEmpty) {
      return subject!;
    }
    if (mood != null && mood!.isNotEmpty) {
      return 'Mood: $mood';
    }
    return 'Untitled Letter';
  }
} 