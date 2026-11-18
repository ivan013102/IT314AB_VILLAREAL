class Grade {
  final String id;
  final String studentId;
  final String subject; // It's a string in your DB!
  final double score;

  Grade({
    this.id = '',
    required this.studentId,
    required this.subject,
    required this.score,
  });
}