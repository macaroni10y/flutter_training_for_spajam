class ChatMessage {
  final bool isUser;
  final String value;

  ChatMessage({required this.isUser, required this.value});
}

class Chat {
  String conversationId;
  List<ChatMessage> messages;

  Chat(this.conversationId, this.messages);

  factory Chat.empty() => Chat('', List.empty(growable: true));
}

class Chats {
  List<Chat> value;

  Chats(this.value);

  /// ただし中身のないチャットなら保存しないし一覧からも削除する
  void upsert(Chat chat) {
    if (chat.conversationId == '' || chat.messages.isEmpty) {
      value.removeWhere(
          (element) => element.conversationId == chat.conversationId);
      return;
    }
    var index = value
        .indexWhere((element) => element.conversationId == chat.conversationId);
    if (index == -1) {
      value.add(chat);
    } else {
      value[index] = chat;
    }
  }
}
