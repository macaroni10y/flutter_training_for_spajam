import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/widget/message_box.dart';

class MessageContainer extends StatelessWidget {
  final List<ChatMessage> messages;

  const MessageContainer({super.key, required this.messages});

  @override
  Widget build(BuildContext context) => Flexible(
        child: ListView(
          children:
              messages.map((message) => MessageBox(message: message)).toList(),
        ),
      );
}
