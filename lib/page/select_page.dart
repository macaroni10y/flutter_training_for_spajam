import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<String> _conversationIds = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('conversations').get().then(
            (querySnapshot) => _conversationIds = querySnapshot.docs.map((doc) => doc.id).toList());
  }

  void upsertChat(Chat chat) => setState(() => chats.upsert(chat));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('chat list'),
        ),
        body: buildBody(),
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ChatPage('chat app',
                      conversationId: '',
                      upsertChat: (chat) => upsertChat(chat)))),
          child: const Icon(Icons.add),
        ),
      );

  /// 会話がないときはメッセージを出す
  Widget buildBody() => chats.value.isEmpty
      ? Container(
          alignment: Alignment.center,
          child: const Text(
            'create new chat',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
        )
      : ListView.builder(
          itemCount: _conversationIds.length,
          itemBuilder: (BuildContext context, int index) => Dismissible(
                key: ObjectKey(_conversationIds[index]),
                direction: DismissDirection.endToStart,
                onDismissed: (DismissDirection direction) =>
                    setState(() => _conversationIds.removeAt(index)),
                background: Container(
                  margin: const EdgeInsets.all(3),
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(
                    Icons.delete_outline,
                    size: 40,
                  ),
                ),
                child: Card(
                  child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ChatPage(
                                'chat app',
                                conversationId: _conversationIds[index],
                                upsertChat: (chat) => upsertChat(chat)))),
                    title: Text(
                      chats.value[index].messages.first.value,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ));
}
