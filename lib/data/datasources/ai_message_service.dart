import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:garaage/data/models/chat/ai_diagnostic_request.dart';
import 'package:garaage/domain/entities/diagnostic_report.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/error/failures.dart';
import '../models/chat/ai_message_request.dart';
import '../models/chat/ai_message_response.dart';

abstract class AiMessageService {
  Future<Either> sendAiMessage(AiMessageRequest aiMessageReq);

  Future<Either> getDiagnosticReport(AiDiagnosticRequest aiDiagnosticReq);
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
          "error", "An error has occurred while getting ai message.");
      return Right(failure);
    }
  }

  @override
  Future<Either> getDiagnosticReport(
      AiDiagnosticRequest aiDiagnosticReq) async {
    final diagnosticPrompt = """
    What does the ${aiDiagnosticReq.troubleCode} code mean?
    Include description, causes and how to fix. 
    Give the result in the following format:
    {
      'description': "",
      'causes':""
      'howToFix': ""
    }
    """;
    try {
      final response = await model.generateContent(
        [
          Content.text(
            diagnosticPrompt,
          ),
        ],
      );
      Map<String, dynamic> jsonResponse = jsonDecode(response.text!);
      DiagnosticReportEntity report =
          DiagnosticReportEntity.fromJson(jsonResponse);
      return Right(report);
    } catch (e) {
      Failure failure = ServerFailure(
        'error',
        'An error occurred while getting diagnostic report.',
      );
      return left(failure);
    }
  }
}
