import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/data/chat_message.dart';
import 'package:flutter_training_for_spajam/page/chat_page.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  Chats chats = Chats(List.empty(growable: true));

  void upsertChat(Chat chat) => setState(() => chats.upsert(chat));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('chat list'),
      ),
      body: ListView.builder(
          itemCount: chats.value.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: ObjectKey(chats.value[index]),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  chats.value.removeAt(index);
                });
              },
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ChatPage('chat app',
                            chat: chats.value[index], upsertChat: (chat) => upsertChat(chat)))),
                title: Text(
                  chats.value[index].messages.first.value,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ChatPage('chat app',
                    chat: Chat.empty(), upsertChat: (chat) => upsertChat(chat)))),
        child: const Icon(Icons.add),
      ),
    );
  }
}
