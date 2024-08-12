import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import '../../../core/error/failures.dart';

import '../../../data/models/chat/ai_message_request.dart';
import '../../../data/models/chat/ai_message_response.dart';
import '../../../domain/usecases/chat/get_ai_message.dart';
import '../../../service_locator.dart';

part 'chatbot_state.dart';

/// A Cubit class that manages the state of the chatbot.
class ChatbotCubit extends Cubit<ChatbotState> {
  /// Constructor to initialize the ChatbotCubit with an empty state.
  ChatbotCubit()
      : super(
          ChatbotState(
            chatMessages: [],
            aiTyping: false,
          ),
        );

  /// Instance of the use case to get AI messages.
  final gemini = sl<GetAiMessage>();

  /// Method to add a chat message to the state and process it.
  void addChatMessage(
    ChatMessage message,
  ) {
    final messages = state.chatMessages;
    emit(ChatbotState(chatMessages: [
      message,
      ...messages,
    ], aiTyping: true));

    try {
      String question = message.text;
      List<Uint8List>? images;

      // Check if there are any media files attached to the message and read their bytes.
      if (message.medias?.isNotEmpty ?? false) {
        images = message.medias!
            .map((file) => File(file.url).readAsBytesSync())
            .toList();
      }

      // Call the AI message use case with the request parameters.
      gemini
          .call(
        params: AiMessageRequest(
          requestMessageText: question,
          images: images,
          chatHistory: state.chatMessages,
        ),
      )
          .then((event) {
        event.fold(
          (l) => _onSuccess(l, state.chatMessages), // Handle success.
          (r) => _onFail(r), // Handle failure.
        );
      });
    } catch (e) {
      // Emit a new state in case of an error.
      emit(
        ChatbotState(chatMessages: [
          message,
          ...messages,
        ], aiTyping: false),
      );
      print(e);
    }
  }

  /// Method to start a diagnostic chat with initial messages.
  void startDiagnosticChat(Map<String, Object> diagnosticIssue) {
    List<ChatMessage> initialChatMessages =
        getInitialDiagnosticMessages(diagnosticIssue['code'] as String);
    emit(
      ChatbotState(chatMessages: initialChatMessages, aiTyping: true),
    );

    try {
      // Call the AI message use case with the diagnostic issue formatted as a prompt.
      gemini
          .call(
        params: AiMessageRequest(
          requestMessageText: _formatPrompt(
            diagnosticIssue,
          ),
          chatHistory: state.chatMessages,
        ),
      )
          .then((event) {
        event.fold(
          (l) => _onSuccess(l, state.chatMessages), // Handle success.
          (r) => _onFail(r), // Handle failure.
        );
      });
    } catch (e) {
      // Emit a new state in case of an error.
      emit(
        ChatbotState(chatMessages: initialChatMessages, aiTyping: false),
      );
      print(e);
    }
  }

  /// Helper method to format the diagnostic issue into a prompt for the AI.
  String _formatPrompt(Map<String, Object> diagnosticIssue) {
    return """
    Provide a set of instructions related to my diagnostic issue of a car.
    Instructions should keep in mind that the user might be a beginner and not
    completely used to cars and/or have extensive knowledge of them.
    Also assure the user you can always provide more help or guidance.
    
    Below is the Json for the diagnostic issue:
    ${diagnosticIssue.toString()}
    """;
  }

  /// Method to start a new chat with an empty state.
  void startNewChat() {
    emit(
      ChatbotState(chatMessages: [], aiTyping: false),
    );
  }

  /// Handler for successful AI message response.
  void _onSuccess(AiMessageResponse l, List<ChatMessage> messages) {
    ChatMessage? lastMessage = messages.firstOrNull;

    if (lastMessage != null && lastMessage.user == ChatbotState.geminiUser) {
      lastMessage = messages.removeAt(0);

      // Append the AI's response to the last message if the sender is the AI.
      final response = l.aiMessageResponseText;
      lastMessage.text += response;
      final newState = [
        lastMessage,
        ...messages,
      ];
      emit(ChatbotState(chatMessages: newState, aiTyping: false));
    } else {
      // Create a new message for the AI's response.
      final response = l.aiMessageResponseText;
      ChatMessage message = ChatMessage(
        user: ChatbotState.geminiUser,
        createdAt: DateTime.now(),
        text: response,
        isMarkdown: true,
      );
      final newState = [message, ...messages];
      emit(ChatbotState(chatMessages: newState, aiTyping: false));
    }
  }

  /// Handler for failure in AI message response.
  void _onFail(Failure l) {
    const response =
        "There seems to be a Server Error. Please start a new chat";
    ChatMessage message = ChatMessage(
      user: ChatbotState.geminiUser,
      createdAt: DateTime.now(),
      text: response,
      isMarkdown: true,
    );
    final newState = [message, ...state.chatMessages];
    emit(ChatbotState(chatMessages: newState, aiTyping: false));
    print(l);
  }
}
