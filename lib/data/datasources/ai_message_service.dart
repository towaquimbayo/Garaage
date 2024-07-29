import 'package:dartz/dartz.dart';
import 'package:garaage/conts.dart';
import 'package:garaage/core/error/failures.dart';
import 'package:garaage/data/models/chat/ai_message_request.dart';
import 'package:garaage/data/models/chat/ai_message_response.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class AiMessageService {
  Future<Either> sendAiMessage(AiMessageRequest aiMessageReq);
}

class AiMessageServiceImpl implements AiMessageService {
  AiMessageServiceImpl() {
    model = GenerativeModel(
        model: 'gemini-1.5-flash-latest', apiKey: GEMINI_API_KEY);
  }

  late GenerativeModel model;

  @override
  Future<Either<AiMessageResponse, Failure>> sendAiMessage(
      AiMessageRequest aiMessageReq) async {
    try {
      final response = await model.generateContent([
        Content.text(aiMessageReq.requestMessageText),
      ]);
      return Left(AiMessageResponse(aiMessageResponseText: response.text!));
    } catch (e) {
      Failure failure = ServerFailure(
          "error", "An error has occured while getting ai message.");
      return Right(failure);
    }
  }
}
