part of 'chatbot_cubit.dart';

class ChatbotState {
  final List<ChatMessage> chatMessages;
  static ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  static ChatUser geminiUser = ChatUser(id: "1", firstName: "Mika");

  ChatbotState({required this.chatMessages});
}

getInitialDiagnosticMessages(String diagnosticName) => [
      ChatMessage(
        text: "Hey, could you help me with the issue **$diagnosticName**.",
        isMarkdown: true,
        user: ChatbotState.currentUser,
        createdAt: DateTime.now(),
      )
    ];
