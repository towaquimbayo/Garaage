import 'package:dartz/dartz.dart';

import '../../domain/repositories/ai_message.dart';
import '../../service_locator.dart';
import '../datasources/ai_message_service.dart';
import '../models/chat/ai_diagnostic_request.dart';
import '../models/chat/ai_message_request.dart';

/// Implementation of the [AiMessageRepository] that interacts with the data source to fetch AI messages and diagnostic reports.
class AiMessageRepositoryImpl extends AiMessageRepository {
  @override
  Future<Either> getAIMessage(AiMessageRequest aiMessageRequest) {
    // Calls the data source to send an AI message request and returns the result as an Either type.
    return sl<AiMessageService>().sendAiMessage(aiMessageRequest);
  }

  @override
  Future<Either> getDiagnosticReport(AiDiagnosticRequest aiDiagnosticRequest) {
    // Calls the data source to get a diagnostic report and returns the result as an Either type.
    return sl<AiMessageService>().getDiagnosticReport(aiDiagnosticRequest);
  }
}
