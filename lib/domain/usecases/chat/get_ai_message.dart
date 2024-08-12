import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/chat/ai_message_request.dart';
import '../../../service_locator.dart';
import '../../repositories/ai_message.dart';

/// A use case for retrieving an AI-generated message based on a request.
class GetAiMessage extends UseCase<Either, AiMessageRequest> {
  @override
  Future<Either> call({AiMessageRequest? params}) async {
    // Ensures that the parameters are not null and calls the repository to get the AI message.
    return sl<AiMessageRepository>().getAIMessage(params!);
  }
}
