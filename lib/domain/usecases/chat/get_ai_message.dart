import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/chat/ai_message_request.dart';
import '../../../service_locator.dart';
import '../../repositories/ai_message.dart';

class GetAiMessage extends UseCase<Either, AiMessageRequest> {
  @override
  Future<Either> call({AiMessageRequest? params}) async {
    return sl<AiMessageRepository>().getAIMessage(params!);
  }
}
