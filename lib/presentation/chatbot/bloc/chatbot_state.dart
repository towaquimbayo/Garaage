part of 'chatbot_cubit.dart';

/// A class representing the state of the chatbot.
class ChatbotState {
  /// A list of chat messages.
  final List<ChatMessage> chatMessages;

  /// A boolean flag indicating if the AI is currently typing.
  final bool aiTyping;

  /// A static instance representing the current user interacting with the chatbot.
  static ChatUser currentUser = ChatUser(id: "0", firstName: "User");

  /// A static instance representing the AI or chatbot user.
  static ChatUser geminiUser = ChatUser(id: "1", firstName: "Mika");

  /// Constructor for initializing the ChatbotState with required parameters.
  ChatbotState({
    required this.aiTyping, // Indicates if the AI is currently typing.
    required this.chatMessages, // List of chat messages in the conversation.
  });
}

/// A function that returns the initial diagnostic messages for a given diagnostic name.
getInitialDiagnosticMessages(String diagnosticName) => [
      ChatMessage(
        text: "Hey, could you help me with the issue **$diagnosticName**?",
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
