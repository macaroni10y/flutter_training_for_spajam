import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/widget/message_box.dart';

class MessageContainer extends StatefulWidget {
  final List<ChatMessage> messages;

  const MessageContainer({super.key, required this.messages});

  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  final _controller = ScrollController();

  void goToLast() async {
    await Future.delayed(const Duration(milliseconds: 350));
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    goToLast();
    return Flexible(
      child: Scrollbar(
        controller: _controller,
        interactive: true,
        child: ListView(
          controller: _controller,
          children: widget.messages.map((message) => MessageBox(message: message)).toList(),
        ),
      ),
    );
  }
}
