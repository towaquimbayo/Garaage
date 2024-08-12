import 'package:dartz/dartz.dart';

import '../../data/models/chat/ai_diagnostic_request.dart';
import '../../data/models/chat/ai_message_request.dart';

/// An abstract class that defines the contract for interacting with AI message-related data.
abstract class AiMessageRepository {
  /// Fetches an AI-generated message based on the provided request.
  ///
  /// Takes an [AiMessageRequest] object containing the details for the request.
  /// Returns a [Future] that resolves to an [Either] object where the left side
  /// represents a failure and the right side contains the AI-generated message.
  Future<Either> getAIMessage(AiMessageRequest aiMessageRequest);

  /// Fetches a diagnostic report based on the provided request.
  ///
  /// Takes an [AiDiagnosticRequest] object containing the details for the diagnostic request.
  /// Returns a [Future] that resolves to an [Either] object where the left side
  /// represents a failure and the right side contains the diagnostic report.
  Future<Either> getDiagnosticReport(AiDiagnosticRequest aiDiagnosticRequest);
}
