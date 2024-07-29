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
      final imageParts = <DataPart>[];
      if (aiMessageReq.images != null) {
        aiMessageReq.images?.forEach((image) {
          imageParts.add(DataPart('image/jpeg', image));
        });
      }
      final response = await model.generateContent([
        Content.multi(
            [TextPart(aiMessageReq.requestMessageText), ...imageParts]),
      ]);
      return Left(AiMessageResponse(aiMessageResponseText: response.text!));
    } catch (e) {
      Failure failure = ServerFailure(
          "error", "An error has occured while getting ai message.");
      return Right(failure);
    }
  }
}
