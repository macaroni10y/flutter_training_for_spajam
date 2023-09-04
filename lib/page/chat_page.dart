import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/api/conversation.dart';
import 'package:flutter_training_for_spajam/api/open_ai_api_client.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/widget/message_bar.dart';
import 'package:flutter_training_for_spajam/widget/message_container.dart';
import 'package:ulid/ulid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.title,
      {Key? key, required this.conversationId, required this.upsertChat})
      : super(key: key);

  final String title;
  final String conversationId;

  final Function(Chat chat) upsertChat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String _conversationId = '';
  List<ChatMessage> _messages = List.empty(growable: true);

  @override
  Future<void> initState() async {
    super.initState();
    _conversationId = widget.conversationId.isEmpty
        ? Ulid().toString()
        : widget.conversationId;

    var future = FirebaseFirestore.instance
        .collection('conversations')
        .doc(_conversationId.isEmpty ? Ulid().toString() : _conversationId)
        .withConverter(
            fromFirestore: Conversation2.fromFirestore,
            toFirestore: (conversation, options) => conversation.toFirestore())
        .get();
    var result = await future;
    Conversation2 conversation = result.data() ??
        Conversation2(id: Ulid().toString(), chats: List.empty(growable: true));
    _messages = conversation.chats
        .map<ChatMessage>((e) => ChatMessage(
              isUser: e.isUser,
              value: e.message,
            ))
        .toList();
  }

  void setConversationId(String conversationId) =>
      setState(() => _conversationId = conversationId);

  void resetMessages(List<ChatMessage> messages) =>
      setState(() => _messages = messages);

  void appendMessage(ChatMessage message) =>
      setState(() => _messages.add(message));

  void callApi(String message) =>
      OpenAiApiClient().getCompletionByHistories(_conversationId, message, _messages, (value) {
        appendMessage(ChatMessage(isUser: false, value: value));
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(_conversationId),
          leading: Builder(
            builder: (BuildContext context) => IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.upsertChat(Chat(_conversationId, _messages));
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            IconButton(
                onPressed: _messages.isEmpty
                    ? null
                    : () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('confirmation'),
                              content: const Text(
                                  'Are you sure you want to delete chat history?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      widget.upsertChat(Chat(_conversationId,
                                          List.empty(growable: true)));
                                      setConversationId('');
                                      resetMessages(List.empty(growable: true));
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Yes")),
                                TextButton(
                                    onPressed: () => {Navigator.pop(context)},
                                    child: const Text("No")),
                              ],
                            )),
                icon: const Icon(Icons.delete))
          ],
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MessageContainer(messages: _messages),
                MessageBar(
                  onSubmit: (message) {
                    callApi(message);
                    appendMessage(ChatMessage(isUser: true, value: message));
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
