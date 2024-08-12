import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';

/// Represents a request for an AI message.
///
/// This class encapsulates the data needed to make a request to the AI service,
/// including the message text, optional images, and the chat history.
class AiMessageRequest {
  /// The text of the message being sent to the AI.
  final String requestMessageText;

  /// Optional list of images associated with the message request.
  ///
  /// Each image is represented as a [Uint8List] containing the image data.
  final List<Uint8List>? images;

  /// The history of chat messages prior to the current request.
  final List<ChatMessage> chatHistory;

  /// Creates an instance of [AiMessageRequest] with the provided parameters.
  ///
  /// [requestMessageText] is required and represents the content of the message
  /// being sent to the AI. [chatHistory] is required and represents the history
  /// of chat messages prior to the current request. [images] is optional and
  /// can be used to include images with the request.
  AiMessageRequest({
    required this.requestMessageText,
    required this.chatHistory,
    this.images,
  });
}
