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
    //print("Changing to json");
    final elt = Message(
      msgId: json['msgId'] as String,
      text: json['text'] as String,
      isMine: json['mine'],
      chatId: json['chatId'],
    );

    //print("Elt");
    //print(elt);

    return elt;
  }

  factory Message.fromDb(Map<String, dynamic> row) {
    return Message(
      msgId: row['msgId'] as String,
      text: row['text'] as String,
      chatId: row['chatId'] as String,
      // FIX: SQLite gives you a 1 or 0. Turn it back into true/false for Dart.
      isMine: row['isMine'] == 1,
    );
  }

  // Convert Dart Message object to SQLite map
  Map<String, dynamic> toDb() {
    return {
      'msgId': msgId,
      'text': text,
      'chatId': chatId,
      // FIX: Turn true into 1 and false into 0 so SQLite can safely save it
      'isMine': isMine ? 1 : 0,
    };
  }
}
