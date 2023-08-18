import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/api/conversation.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/widget/message_bar.dart';
import 'package:flutter_training_for_spajam/widget/message_container.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(this.title,
      {Key? key, required this.chat, required this.upsertChat})
      : super(key: key);

  final String title;
  final Chat chat;

  final Function(Chat chat) upsertChat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String _conversationId = '';
  List<ChatMessage> _messages = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _conversationId = widget.chat.conversationId;
    _messages = widget.chat.messages;
  }

  void setConversationId(String conversationId) =>
      setState(() => _conversationId = conversationId);

  void resetMessages(List<ChatMessage> messages) =>
      setState(() => _messages = messages);

  void appendMessage(ChatMessage message) =>
      setState(() => _messages.add(message));

  void callApi(String message) => ConversationApiClient()
          .fetchConversation(_conversationId, message)
          .then((value) {
        setConversationId(value.id);
        appendMessage(ChatMessage(isUser: false, value: value.reply));
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
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
                onPressed: () => showDialog(
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
        body: Center(
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
      );
}
