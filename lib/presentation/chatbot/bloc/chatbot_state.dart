part of 'chatbot_cubit.dart';

class ChatbotState {
  final List<ChatMessage> chatMessages;
  final bool aiTyping;
  static ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  static ChatUser geminiUser = ChatUser(id: "1", firstName: "Mika");

  ChatbotState({
    required this.aiTyping,
    required this.chatMessages,
  });
}

getInitialDiagnosticMessages(String diagnosticName) => [
      ChatMessage(
        text: "Hey, could you help me with the issue **$diagnosticName**.",
        isMarkdown: true,
        user: ChatbotState.currentUser,
        createdAt: DateTime.now(),
        quickReplies: [
          QuickReply(
            title: "Testing the quick reply",
            value: diagnosticName,
          ),
        ],
      )
    ];
