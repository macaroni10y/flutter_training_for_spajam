import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class Conversation {
  final String id;
  final String reply;

  Conversation({required this.id, required this.reply});

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(id: map['conversationId'] ?? '', reply: map['responseFromAi'] ?? '');
  }

  factory Conversation.fromJsonBite(Uint8List source) =>
      Conversation.fromMap(json.decode(utf8.decode(source)));
}

class ConversationApiClient {
  Future<Conversation> fetchConversation(String id, String message) async {
    var response = await http.post(
        Uri.http(Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080', '/conversation'),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body:
            json.encode({"prompt": '$message please reply about 30 words.', "conversationId": id}));

    var conversation = Conversation.fromJsonBite(response.bodyBytes);
    return conversation;
  }
}
