import 'dart:typed_data';

class AiMessageRequest {
  final String requestMessageText;
  final List<Uint8List>? images;

  AiMessageRequest({
    required this.requestMessageText,
    this.images,
  });
}
