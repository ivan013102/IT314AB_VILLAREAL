import '../core/db_connection.dart';
import '../models/subject.dart';

class SubjectRepository {
  // READ
  Future<List<Subject>> fetchAll() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute('SELECT * FROM subjects ORDER BY subject_id');

    return result.map((row) {
      final m = row.toColumnMap();
      return Subject(
        id: m['subject_id'].toString(),
        subjectCode: m['subject_code']?.toString() ?? '',
        subjectName: m['subject_name']?.toString() ?? '',
        units: (m['units'] as num?)?.toInt() ?? 3,
        description: m['description']?.toString() ?? '',
      );
    }).toList();
  }

  // CREATE
  Future<void> insert(Subject s) async {
    final conn = await DbConnection.connection;
    final safeCode = s.subjectCode.replaceAll("'", "''");
    final safeName = s.subjectName.replaceAll("'", "''");
    final safeDesc = s.description.replaceAll("'", "''");

    // We DO NOT insert subject_id (Neon auto-generates it)
    final sql = '''
      INSERT INTO subjects (subject_code, subject_name, units, description)
      VALUES ('$safeCode', '$safeName', ${s.units}, '$safeDesc')
    ''';
    await conn.execute(sql);
  }

  // DELETE
  Future<void> delete(String id) async {
    final conn = await DbConnection.connection;
    await conn.execute("DELETE FROM subjects WHERE subject_id = $id");
  }
}