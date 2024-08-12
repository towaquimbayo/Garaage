/// Represents a request for a diagnostic report.
///
/// This class is used to encapsulate the information needed to request
/// a diagnostic report from the AI service, specifically the trouble code
/// associated with the diagnostic issue.
class AiDiagnosticRequest {
  /// The trouble code related to the diagnostic issue.
  final String troubleCode;

  /// Creates an instance of [AiDiagnosticRequest] with the provided [troubleCode].
  ///
  /// [troubleCode] is a required parameter representing the specific trouble code
  /// for which the diagnostic report is requested.
  AiDiagnosticRequest(this.troubleCode);
}
