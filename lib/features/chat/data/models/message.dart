/// Domain + data model for a single chat message.
class Message {
  final String msgId;
  final String text;
  final bool isMine;
  final String chatId;

  const Message({
    required this.msgId,
    required this.text,
    required this.isMine,
    required this.chatId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msgId: json['msgId'] as String,
      text: json['text'] as String,
      isMine: json['mine'],
      chatId: json['chatId'],
    );
  }

  factory Message.fromDb(Map<String, dynamic> row) {
    return Message(
      msgId: row['msgId'] as String,
      text: row['text'] as String,
      isMine: (row['mine']),
      chatId: row['chatId'],
    );
  }

  Map<String, dynamic> toDb() => {
    'msgId': msgId,
    'text': text,
    'mine': isMine,
    chatId: chatId,
    'cached_at': DateTime.now().toIso8601String(),
  };
}
