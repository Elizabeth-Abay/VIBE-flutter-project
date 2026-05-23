/// Domain + data model for a single chat message.
class Message {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final DateTime createdAt;
  final bool isSaved;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.isSaved = false,
  });

  bool isFromMe(String currentUserId) => senderId == currentUserId;

  String get displayTime {
    final h = createdAt.hour;
    final m = createdAt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final hour12 = h % 12 == 0 ? 12 : h % 12;
    return '$hour12:$m $period';
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    required String conversationId,
    required String currentUserId,
  }) {
    final senderId = json['sender_id'] as String;
    return Message(
      id: json['id'] as String,
      conversationId: conversationId,
      senderId: senderId,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isSaved: json['is_saved'] == true || json['is_saved'] == 1,
    );
  }

  factory Message.fromDb(Map<String, dynamic> row) {
    return Message(
      id: row['id'] as String,
      conversationId: row['conversation_id'] as String,
      senderId: row['sender_id'] as String,
      text: row['text'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      isSaved: (row['is_saved'] as int) == 1,
    );
  }

  Map<String, dynamic> toDb() => {
    'id': id,
    'conversation_id': conversationId,
    'sender_id': senderId,
    'text': text,
    'created_at': createdAt.toIso8601String(),
    'is_saved': isSaved ? 1 : 0,
    'cached_at': DateTime.now().toIso8601String(),
  };
}
