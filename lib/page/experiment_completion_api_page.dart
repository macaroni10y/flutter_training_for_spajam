import 'package:flutter/material.dart';
import 'package:flutter_training_for_spajam/api/open_ai_api_client.dart';
import 'package:flutter_training_for_spajam/widget/message_bar.dart';

class ExperimentCompletionApiPage extends StatefulWidget {
  const ExperimentCompletionApiPage({super.key});

  @override
  State<StatefulWidget> createState() => _ExperimentCompletionApiPageState();
}

class _ExperimentCompletionApiPageState
    extends State<ExperimentCompletionApiPage> {
  String reply = '';
  String input = '';


  void setInput(String input) => setState(() => this.input = input);
  void setReply(String reply) => setState(() => this.reply = reply);

  void onSubmit(String data) {
    setReply('');
    setInput(data);
    OpenAiApiClient().getCompletionStream(data, (reply) => setReply(this.reply + reply));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
  appBar: AppBar(
  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  title: const Text('experimental page'),),
        body: SafeArea(
          child: Column(children: [
            Expanded(
              child: ListView(
                children: [
                  Card(child: Text(input)),
                  Card(child: Text(reply)),
                ],
              ),
            ),
            MessageBar(onSubmit: onSubmit),
          ]),
        ),
      );
}
