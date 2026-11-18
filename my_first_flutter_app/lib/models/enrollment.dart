class Enrollment {
  final String id;
  final String studentId;
  final String subjectId;
  final String scheduleId;
  final String status;

  Enrollment({
    this.id = '',
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    this.status = 'Enrolled',
  });
}