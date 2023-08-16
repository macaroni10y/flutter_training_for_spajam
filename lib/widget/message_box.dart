import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

import '../data/chat_message.dart';

class MessageBox extends StatelessWidget {
  final ChatMessage message;

  const MessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context) => ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      child: BubbleSpecialOne(
        text: message.value,
        isSender: message.isUser,
        textStyle: const TextStyle(
          fontSize: 14,
        ),
        color: message.isUser
            ? const Color.fromARGB(255, 152, 255, 152)
            : const Color.fromARGB(255, 238, 238, 238),
      ));
}
