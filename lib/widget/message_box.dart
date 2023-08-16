import 'package:flutter/material.dart';

import '../data/chat_message.dart';

class MessageBox extends StatelessWidget {
  final ChatMessage message;

  const MessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Container(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Card(
                color: message.isUser ? const Color.fromARGB(255, 152, 255, 152) : Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      message.value,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    )))),
      );
}
