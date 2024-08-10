import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/error/failures.dart';
import '../models/chat/ai_message_request.dart';
import '../models/chat/ai_message_response.dart';

abstract class AiMessageService {
  Future<Either> sendAiMessage(AiMessageRequest aiMessageReq);
}

class AiMessageServiceImpl implements AiMessageService {
  AiMessageServiceImpl() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: dotenv.env['GOOGLE_GEMINI_API_KEY'] ?? '',
    );
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
      final chatHistory = aiMessageReq.chatHistory.map((message) {
        return Content(
          message.user.firstName == 'Mike' ? 'model' : 'user',
          [
            TextPart(
              message.text,
            ),
          ],
        );
      }).toList();
      final chat = model.startChat(
        history: chatHistory,
      );
      final response = await chat.sendMessage(
        Content.multi(
            [TextPart(aiMessageReq.requestMessageText), ...imageParts]),
      );
      return Left(AiMessageResponse(aiMessageResponseText: response.text!));
    } catch (e) {
      Failure failure = ServerFailure(
          "error", "An error has occured while getting ai message.");
      return Right(failure);
    }
  }
}
