import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

import '../../../data/models/chat/ai_message_request.dart';
import '../../../data/models/chat/ai_message_response.dart';
import '../../../domain/usecases/chat/get_ai_message.dart';
import '../../../service_locator.dart';

part 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  ChatbotCubit() : super(ChatbotState(chatMessages: []));
  final gemini = sl<GetAiMessage>();

  void addChatMessage(
    ChatMessage message,
  ) {
    final messages = state.chatMessages;
    print(messages.length);
    emit(ChatbotState(
      chatMessages: [
        message,
        ...messages,
      ],
    ));
    try {
      String question = message.text;
      List<Uint8List>? images;
      if (message.medias?.isNotEmpty ?? false) {
        images = message.medias!
            .map((file) => File(file.url).readAsBytesSync())
            .toList();
      }

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
          (l) => _onSuccess(l, state.chatMessages),
          (r) => _onFail(r),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  void startDiagnosticChat(Map<String, Object> diagnosticIssue) {
    print(diagnosticIssue);
    final initialChatMessages =
        getInitialDiagnosticMessages(diagnosticIssue['code'] as String);
    emit(
      ChatbotState(
        chatMessages: initialChatMessages,
      ),
    );
    try {
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
          (l) => _onSuccess(l, state.chatMessages),
          (r) => _onFail(r),
        );
      });
    } catch (e) {
      print(e);
    }
  }

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

  void _onSuccess(AiMessageResponse l, List<ChatMessage> messages) {
    ChatMessage? lastMessage = messages.firstOrNull;
    if (lastMessage != null && lastMessage.user == ChatbotState.geminiUser) {
      lastMessage = messages.removeAt(0);
      // String response = event.content?.parts?.fold(
      //     "", (previous, current) => "$previous ${current.text}") ??
      //     "";
      final response = l.aiMessageResponseText;
      lastMessage.text += response;
      final newState = [
        lastMessage,
        ...messages,
      ];
      emit(ChatbotState(chatMessages: newState));
    } else {
      // String response = event.content?.parts?.fold(
      //     "", (previous, current) => "$previous ${current.text}") ??
      //     "";

      final response = l.aiMessageResponseText;
      ChatMessage message = ChatMessage(
        user: ChatbotState.geminiUser,
        createdAt: DateTime.now(),
        text: response,
        isMarkdown: true,
      );
      final newState = [message, ...messages];
      emit(ChatbotState(chatMessages: newState));
    }
  }
}

void _onFail(Right l) {}
