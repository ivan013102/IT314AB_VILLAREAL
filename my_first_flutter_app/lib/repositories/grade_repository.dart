import '../core/db_connection.dart';
import '../models/grade.dart';

class GradeRepository {
  Future<List<Grade>> fetchAll() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute('SELECT * FROM grades ORDER BY grade_id');

    return result.map((row) {
      final m = row.toColumnMap();
      return Grade(
        id: m['grade_id'].toString(),
        studentId: m['student_id'].toString(),
        subject: m['subject']?.toString() ?? '',
        // Safely parse string or number to double
        score: double.tryParse(m['score'].toString()) ?? 0.0,
      );
    }).toList();
  }

  Future<void> insert(Grade g) async {
    final conn = await DbConnection.connection;
    final safeSubject = g.subject.replaceAll("'", "''");

    final sql = '''
      INSERT INTO grades (student_id, subject, score)
      VALUES (${g.studentId}, '$safeSubject', ${g.score})
    ''';
    await conn.execute(sql);
  }

  Future<void> delete(String id) async {
    final conn = await DbConnection.connection;
    await conn.execute("DELETE FROM grades WHERE grade_id = $id");
  }
}