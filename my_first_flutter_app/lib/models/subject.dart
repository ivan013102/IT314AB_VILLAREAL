class Subject {
  final String id; // Holds the auto-generated ID from DB
  final String subjectCode;
  final String subjectName;
  final int units;
  final String description;

  Subject({
    this.id = '', // Empty by default until saved to DB
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    this.description = '',
  });
}