import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/api/conversation.dart';
import 'package:flutter_training_for_spajam/data/message.dart';
import 'package:flutter_training_for_spajam/widget/message_container.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _conversationId = '';
  String _message = '';
  List<Message> _messages = List.empty(growable: true);

  void setConversationId(String conversationId) =>
      setState(() => _conversationId = conversationId);

  void setMessage(String message) => setState(() => _message = message);

  void resetMessages(List<Message> messages) =>
      setState(() => _messages = messages);

  void appendMessage(Message message) => setState(() => _messages.add(message));

  void callApi(String message) {
    ConversationApiClient()
        .fetchConversation(_conversationId, message)
        .then((value) {
      setConversationId(value.id);
      appendMessage(Message(isUser: false, message: value.reply));
    });
  }

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
                onPressed: () {
                  // 画面リセット
                  setConversationId('');
                  resetMessages(List.empty(growable: true));
                },
                icon: const Icon(Icons.clear))
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'id: $_conversationId',
              ),
              MessageContainer(messages: _messages),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      enableSuggestions: true,
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message',
                      ),
                      onChanged: (value) {
                        setMessage(value);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _controller.clear();
                      callApi(_message);
                      appendMessage(Message(isUser: true, message: _message));
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
