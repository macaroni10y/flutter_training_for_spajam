import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class Conversation {
  String id;
  List<OneChat> chats;

  Conversation({required this.id, required this.chats});

  void append(OneChat chat) => chats.add(chat);
}

class OneChat {
  final String id;
  final String reply;

  OneChat({required this.id, required this.reply});

  factory OneChat.fromMap(Map<String, dynamic> map) {
    return OneChat(
        id: map['conversationId'] ?? '', reply: map['responseFromAi'] ?? '');
  }

  factory OneChat.fromJsonBite(Uint8List source) =>
      OneChat.fromMap(json.decode(utf8.decode(source)));
}

class ConversationApiClient {
  Future<OneChat> fetchConversation(String id, String message) async {
    var response = await http.post(
        Uri.http(Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080',
            '/conversation'),
        headers: {HttpHeaders.contentTypeHeader: "application/json"},
        body: json.encode({
          "prompt": '$message please reply about 30 words.',
          "conversationId": id
        }));

    var conversation = OneChat.fromJsonBite(response.bodyBytes);
    return conversation;
  }
}
