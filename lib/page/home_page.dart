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
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text('confirmation'),
                          content: const Text(
                              'Are you sure you want to delete chat history?'),
                          actions: [
                            TextButton(
                                onPressed: () {
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
              buildMessageBar(),
            ],
          ),
        ),
      );

  Container buildMessageBar() => Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey))),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enableSuggestions: true,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'send a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onChanged: setMessage,
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
      );
}
