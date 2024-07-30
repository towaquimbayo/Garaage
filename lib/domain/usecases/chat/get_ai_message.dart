import 'package:dartz/dartz.dart';
import 'package:garaage/core/usecase/usecase.dart';
import 'package:garaage/data/models/chat/ai_message_request.dart';
import 'package:garaage/domain/repositories/ai_message.dart';

import '../../../service_locator.dart';

class GetAiMessage extends UseCase<Either, AiMessageRequest> {
  @override
  Future<Either> call({AiMessageRequest? params}) async {
    return sl<AiMessageRepository>().getAIMessage(params!);
  }
}
