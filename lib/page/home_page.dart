// create stateless widget

import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/api/conversation.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.title, this.counter, this._incrementCounter, {Key? key})
      : super(key: key);

  final String title;
  final int counter;
  final void Function() _incrementCounter;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _latestReply = '';
  String _conversationId = '';
  String _message = '';

  void setLatestReply(String reply) => setState(() {
        _latestReply = reply;
      });

  void setConversationId(String conversationId) => setState(() {
        _conversationId = conversationId;
      });

  void setMessage(String message) => setState(() {
        _message = message;
      });

  void callApi(String message) {
    print('callApi');
    ConversationApiClient()
        .fetchConversation(_conversationId, message)
        .then((value) {
      setLatestReply(value.reply);
      setConversationId(value.id);
    });
  }
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'id: $_conversationId',
            ),
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
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                _latestReply,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 画面リセット
          setConversationId('');
          setLatestReply('');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.clear),
      ),
    );
  }
}
