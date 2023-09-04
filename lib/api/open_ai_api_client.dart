import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:ulid/ulid.dart';

class OneChat2 {
  final bool isUser;
  final String message;

  OneChat2({required this.isUser, required this.message});
}

class Conversation2 {
  String id;
  List<OneChat2> chats;

  Conversation2({required this.id, required this.chats});

  factory Conversation2.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();
    return Conversation2(
      id: data?['conversationId'],
      chats: data?['chats']
          .map<OneChat2>((e) => OneChat2(
                isUser: e['isUser'],
                message: e['message'],
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'conversationId': id,
        'chats': chats
            .map((e) => {
                  'isUser': e.isUser,
                  'message': e.message,
                })
            .toList(),
      };

  void append(OneChat2 chat) => chats.add(chat);
}

class OpenAiApiClient {
  Future<void> getCompletionByHistories(String id, String message, List<ChatMessage> chats, Function callback) async {
    chats.add(ChatMessage(isUser: true, value: message));
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: chats
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
          role: e.isUser
              ? OpenAIChatMessageRole.user
              : OpenAIChatMessageRole.assistant,
          content: e.value))
          .toList(),
    );
    chatCompletion.choices.forEach((element) {
      print(element);
    });

    callback(chatCompletion.choices[0].message.content);
  }


  Future<void> getCompletion(
      String id, String message, Function callback) async {
    var future = FirebaseFirestore.instance
        .collection('conversations')
        .doc(id.isEmpty ? Ulid().toString() : id)
        .withConverter(
            fromFirestore: Conversation2.fromFirestore,
            toFirestore: (conversation, options) => conversation.toFirestore())
        .get();
    var result = await future;
    Conversation2 conversation = result.data() ??
        Conversation2(id: Ulid().toString(), chats: List.empty(growable: true));
    conversation.append(OneChat2(isUser: true, message: message));

    print("message: $message");
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: conversation.chats
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
              role: e.isUser
                  ? OpenAIChatMessageRole.user
                  : OpenAIChatMessageRole.assistant,
              content: e.message))
          .toList(),
    );
    chatCompletion.choices.forEach((element) {
      print(element);
    });

    callback(chatCompletion.choices[0].message.content);
  }

  Future<void> getCompletionStream(String message, Function callback) async {
    Stream<OpenAIStreamChatCompletionModel> chatStream =
        OpenAI.instance.chat.createStream(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: message,
          role: OpenAIChatMessageRole.user,
        )
      ],
    );

    chatStream.listen((streamChatCompletion) {
      final content = streamChatCompletion.choices.first.delta.content;
      callback(content);
    });
  }
}
