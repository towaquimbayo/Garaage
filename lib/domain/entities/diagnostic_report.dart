class DiagnosticReportEntity {
  String description;
  String causes;
  String howToFix;

  DiagnosticReportEntity({
    required this.description,
    required this.causes,
    required this.howToFix,
  });

  factory DiagnosticReportEntity.fromJson(Map<String, dynamic> json) {
    return DiagnosticReportEntity(
      description: json['description'],
      causes: json['causes'],
      howToFix: json['howToFix'],
    );
  }
}
