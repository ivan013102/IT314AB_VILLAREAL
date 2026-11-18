import '../core/db_connection.dart';
import '../models/enrollment.dart';

class EnrollmentRepository {
  Future<List<Enrollment>> fetchAll() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute('SELECT * FROM enrollments ORDER BY enrollment_id');

    return result.map((row) {
      final m = row.toColumnMap();
      return Enrollment(
        id: m['enrollment_id'].toString(),
        studentId: m['student_id'].toString(),
        subjectId: m['subject_id'].toString(), // Added back
        scheduleId: m['schedule_id'].toString(),
        status: m['status']?.toString() ?? 'Enrolled',
      );
    }).toList();
  }

  Future<void> insert(Enrollment e) async {
    final conn = await DbConnection.connection;

    final sql = '''
      INSERT INTO enrollments (student_id, subject_id, schedule_id, status)
      VALUES (${e.studentId}, ${e.subjectId}, ${e.scheduleId}, '${e.status}')
    ''';
    await conn.execute(sql);
  }

  Future<void> delete(String id) async {
    final conn = await DbConnection.connection;
    await conn.execute("DELETE FROM enrollments WHERE enrollment_id = $id");
  }
}