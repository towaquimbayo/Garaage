/// Represents a response from the AI service.
///
/// This class encapsulates the data returned by the AI service in response
/// to a message request.
class AiMessageResponse {
  /// The text of the message response from the AI.
  final String aiMessageResponseText;

  /// Creates an instance of [AiMessageResponse] with the provided [aiMessageResponseText].
  ///
  /// [aiMessageResponseText] is required and represents the content of the message
  /// returned by the AI in response to the request.
  AiMessageResponse({required this.aiMessageResponseText});
}
