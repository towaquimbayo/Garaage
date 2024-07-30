import 'package:dartz/dartz.dart';
import 'package:garaage/data/models/chat/ai_message_request.dart';

abstract class AiMessageRepository {
  Future<Either> getAIMessage(AiMessageRequest aiMessageRequest);
}
