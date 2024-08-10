import 'package:dartz/dartz.dart';
import 'package:garaage/data/models/chat/ai_diagnostic_request.dart';

import '../../domain/repositories/ai_message.dart';
import '../../service_locator.dart';
import '../datasources/ai_message_service.dart';
import '../models/chat/ai_message_request.dart';

class AiMessageRepositoryImpl extends AiMessageRepository {
  @override
  Future<Either> getAIMessage(AiMessageRequest aiMessageRequest) {
    return sl<AiMessageService>().sendAiMessage(aiMessageRequest);
  }

  @override
  Future<Either> getDiagnosticReport(AiDiagnosticRequest aiDiagnosticRequest) {
    return sl<AiMessageService>().getDiagnosticReport(aiDiagnosticRequest);
  }
}
