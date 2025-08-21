class JournalEntryModel {
  final String id;
  final String title;
  final String content;
  final String? mood;
  final List<String>? tags;
  final bool isArchived;
  final String createdAt;
  final String updatedAt;

  JournalEntryModel({
    required this.id,
    required this.title,
    required this.content,
    this.mood,
    this.tags,
    this.isArchived = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntryModel.fromJson(Map<String, dynamic> json) {
    return JournalEntryModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      mood: json['mood']?.toString(),
      tags: json['tags'] != null 
          ? List<String>.from(json['tags'])
          : null,
      isArchived: json['is_archived'] == true,
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'mood': mood,
      'tags': tags,
      'is_archived': isArchived,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  JournalEntryModel copyWith({
    String? id,
    String? title,
    String? content,
    String? mood,
    List<String>? tags,
    bool? isArchived,
    String? createdAt,
    String? updatedAt,
  }) {
    return JournalEntryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      tags: tags ?? this.tags,
      isArchived: isArchived ?? this.isArchived,
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
} 