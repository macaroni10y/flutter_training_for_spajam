import 'package:flutter/material.dart';

class MessageBar extends StatelessWidget {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

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
                focusNode: _focusNode,
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
                if (_controller.text.isEmpty) return;
                onSubmit(_controller.text);
                _controller.clear();
                _focusNode.unfocus(
                    disposition: UnfocusDisposition.previouslyFocusedChild);
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      );
}
