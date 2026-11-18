import 'package:postgres/postgres.dart';
import '../core/db_connection.dart';
import '../models/student.dart';

class StudentRepository {
  // READ
  Future<List<Student>> fetchAll() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute('SELECT * FROM students ORDER BY student_id');

    return result.map((row) {
      final m = row.toColumnMap();
      return Student(
        // Convert DB integer to App String so the UI doesn't break
        studentId: m['student_id'].toString(),
        name: m['student_name']?.toString() ?? '',

        // Since these fields don't exist in your DB, we use placeholder values
        course: 'BSIT',
        yearLevel: 'N/A',
        age: 18,
        hobby: 'Not specified',
        email: 'no-email@example.com',
        favoriteSubject: 'Not specified',
        image: 'assets/profile2.jpg',
        isActive: true,
      );
    }).toList();
  }

  // CREATE
  Future<void> insert(Student s) async {
    final conn = await DbConnection.connection;

    // Escape single quotes to prevent SQL syntax errors
    final safeName = s.name.replaceAll("'", "''");

    // We ONLY insert the 3 columns that actually exist in your DB
    final sql = '''
      INSERT INTO students (student_id, student_name, program_id)
      VALUES (${s.studentId}, '$safeName', 1)
    ''';

    await conn.execute(sql);
  }

  // UPDATE
  Future<void> update(Student s) async {
    final conn = await DbConnection.connection;

    final safeName = s.name.replaceAll("'", "''");

    // We ONLY update the student_name
    final sql = '''
      UPDATE students SET
        student_name = '$safeName'
      WHERE student_id = ${s.studentId}
    ''';

    await conn.execute(sql);
  }

  // DELETE
  Future<void> delete(String studentId) async {
    final conn = await DbConnection.connection;
    await conn.execute("DELETE FROM students WHERE student_id = $studentId");
  }

  // RESTORE DEFAULTS
  Future<void> restoreDefaults(List<Student> defaults) async {
    final conn = await DbConnection.connection;

    // We delete all students first
    await conn.execute('DELETE FROM students');

    // Then insert them one by one
    for (final s in defaults) {
      await insert(s);
    }
  }
}