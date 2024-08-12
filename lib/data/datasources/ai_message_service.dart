import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/error/failures.dart';
import '../../domain/entities/diagnostic_report.dart';
import '../models/chat/ai_diagnostic_request.dart';
import '../models/chat/ai_message_request.dart';
import '../models/chat/ai_message_response.dart';

/// Interface for the AI message service, defining methods to interact with the AI model.
abstract class AiMessageService {
  /// Sends an AI message request and returns the AI's response.
  Future<Either<AiMessageResponse, Failure>> sendAiMessage(
      AiMessageRequest aiMessageReq);

  /// Retrieves a diagnostic report based on the provided diagnostic request.
  Future<Either<DiagnosticReportEntity, Failure>> getDiagnosticReport(
      AiDiagnosticRequest aiDiagnosticReq);
}

/// Implementation of [AiMessageService] using the Google Generative AI model.
class AiMessageServiceImpl implements AiMessageService {
  /// Constructs an instance of [AiMessageServiceImpl] and initializes the AI model.
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
      // Prepare image parts if any images are included in the request.
      final imageParts = <DataPart>[];
      if (aiMessageReq.images != null) {
        aiMessageReq.images?.forEach((image) {
          imageParts.add(DataPart('image/jpeg', image));
        });
      }

      // Map chat history to the format required by the model.
      final chatHistory = aiMessageReq.chatHistory.map((message) {
        return Content(
          message.user.firstName == 'Mike' ? 'model' : 'user',
          [
            TextPart(message.text),
          ],
        );
      }).toList();

      // Start a chat session and send the message.
      final chat = model.startChat(history: chatHistory);
      final response = await chat.sendMessage(Content.multi(
        [TextPart(aiMessageReq.requestMessageText), ...imageParts],
      ));

      // Return the AI's response encapsulated in an [Either] type.
      return Left(AiMessageResponse(aiMessageResponseText: response.text!));
    } catch (e) {
      // Return a failure if an error occurs during message sending.
      Failure failure = ServerFailure(
          "error", "An error has occurred while getting AI message.");
      return Right(failure);
    }
  }

  @override
  Future<Either<DiagnosticReportEntity, Failure>> getDiagnosticReport(
      AiDiagnosticRequest aiDiagnosticReq) async {
    final diagnosticPrompt = """
    What does the ${aiDiagnosticReq.troubleCode} code mean?
    Include description, causes, and how to fix.
    Give the result in the following format:
    {
      'description': "",
      'causes': "",
      'howToFix': ""
    }
    """;

    try {
      // Request the diagnostic report from the AI model.
      final response =
          await model.generateContent([Content.text(diagnosticPrompt)]);
      Map<String, dynamic> jsonResponse = jsonDecode(response.text!);

      // Parse and return the diagnostic report.
      DiagnosticReportEntity report =
          DiagnosticReportEntity.fromJson(jsonResponse);
      return Left(report);
    } catch (e) {
      // Return a failure if an error occurs during the report generation.
      Failure failure = ServerFailure(
          'error', 'An error occurred while getting diagnostic report.');
      return Right(failure);
    }
  }
}
