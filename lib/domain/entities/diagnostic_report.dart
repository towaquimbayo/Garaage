/// Represents a diagnostic report entity containing information about a diagnostic issue.
class DiagnosticReportEntity {
  /// A description of the diagnostic issue.
  String description;

  /// The causes of the diagnostic issue.
  String causes;

  /// Instructions on how to fix the diagnostic issue.
  String howToFix;

  /// Creates a [DiagnosticReportEntity] instance with the provided [description], [causes], and [howToFix].
  DiagnosticReportEntity({
    required this.description,
    required this.causes,
    required this.howToFix,
  });

  /// Creates a [DiagnosticReportEntity] instance from a JSON object.
  ///
  /// The [json] parameter should be a map containing the keys 'description', 'causes', and 'howToFix'.
  /// Returns a [DiagnosticReportEntity] object with the values extracted from the JSON map.
  factory DiagnosticReportEntity.fromJson(Map<String, dynamic> json) {
    return DiagnosticReportEntity(
      description: json['description'],
      causes: json['causes'],
      howToFix: json['howToFix'],
    );
  }
}
