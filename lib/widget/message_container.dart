import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/widget/message_box.dart';

class MessageContainer extends StatelessWidget {
  final List<ChatMessage> messages;

  MessageContainer({super.key, required this.messages});

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
        child: ListView.builder(
          controller: _controller,
          itemCount: messages.length,
          itemBuilder: (BuildContext context, int index) => MessageBox(message: messages[index]),
        ),
      ),
    );
  }
}
