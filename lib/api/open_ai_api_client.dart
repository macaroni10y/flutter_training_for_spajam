import 'package:dart_openai/dart_openai.dart';

class OpenAiApiClient {
  Future<void> getCompletion(String message, Function callback) async {
    print("message: $message");
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-3.5-turbo",
      messages: [
        OpenAIChatCompletionChoiceMessageModel(
          content: message,
          role: OpenAIChatMessageRole.user,
        ),
      ],
    );
    chatCompletion.choices.forEach((element) {print(element);});

    callback(chatCompletion.choices[0].message.content);
  }
}
