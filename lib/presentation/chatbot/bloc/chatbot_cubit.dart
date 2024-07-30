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

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "Mika");

  void addChatMessage(ChatMessage message) {
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
        images = [
          File(message.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini
          .call(
              params: AiMessageRequest(
                  requestMessageText: question, images: images))
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

  void _onSuccess(AiMessageResponse l, List<ChatMessage> messages) {
    ChatMessage? lastMessage = messages.firstOrNull;
    if (lastMessage != null && lastMessage.user == geminiUser) {
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
        user: geminiUser,
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
