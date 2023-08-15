import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/data/message.dart';

class MessageContainer extends StatelessWidget {
  final List<Message> messages;

  const MessageContainer({super.key, required this.messages});

  @override
  Widget build(BuildContext context) => Flexible(
        child: ListView(
          children: messages.map((e) => buildMessageCard(e, context)).toList(),
        ),
      );

  Container buildMessageCard(Message e, BuildContext context) => Container(
        alignment: e.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Card(
                color: e.isUser
                    ? const Color.fromARGB(255, 152, 255, 152)
                    : Colors.white,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      e.message,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    )))),
      );
}
