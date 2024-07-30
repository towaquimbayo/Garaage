import 'package:dartz/dartz.dart';
import 'package:garaage/data/datasources/ai_message_service.dart';
import 'package:garaage/data/models/chat/ai_message_request.dart';
import 'package:garaage/domain/repositories/ai_message.dart';

import '../../service_locator.dart';

class AiMessageRepositoryImpl extends AiMessageRepository {
  @override
  Future<Either> getAIMessage(AiMessageRequest aiMessageRequest) {
    return sl<AiMessageService>().sendAiMessage(aiMessageRequest);
  }
}
