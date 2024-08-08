import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';

class AiMessageRequest {
  final String requestMessageText;
  final List<Uint8List>? images;
  final List<ChatMessage> chatHistory;

  AiMessageRequest({
    required this.requestMessageText,
    required this.chatHistory,
    this.images,
  });
}
