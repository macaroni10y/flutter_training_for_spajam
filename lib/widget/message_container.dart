import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/widget/message_box.dart';

class MessageContainer extends StatelessWidget {
  final _controller = ScrollController();
  final List<ChatMessage> messages;

  MessageContainer({super.key, required this.messages});

  @override
  Widget build(BuildContext context) => Flexible(
        child: Scrollbar(
          controller: _controller,
          interactive: true,
          child: ListView(
            controller: _controller,
            children: messages
                .map((message) => MessageBox(message: message))
                .toList(),
          ),
        ),
      );
}
