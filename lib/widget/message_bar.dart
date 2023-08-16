import 'package:flutter/material.dart';

class MessageBar extends StatelessWidget {
  final _controller = TextEditingController();

  /// action when input text is submitted
  final Function(String message) onSubmit;

  MessageBar({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) => Container(
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
              ),
            ),
            IconButton(
              onPressed: () {
                onSubmit(_controller.text);
                _controller.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      );
}
