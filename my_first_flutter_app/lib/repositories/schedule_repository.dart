import '../core/db_connection.dart';
import '../models/schedule.dart';

class ScheduleRepository {
  Future<List<Schedule>> fetchAll() async {
    final conn = await DbConnection.connection;
    final result = await conn.execute('SELECT * FROM schedules ORDER BY schedule_id');

    return result.map((row) {
      final m = row.toColumnMap();
      return Schedule(
        id: m['schedule_id'].toString(),
        subjectId: m['subject_id'].toString(),
        dayOfWeek: m['day_of_week']?.toString() ?? '',
        // Postgres returns time as a special object, we convert it to string
        startTime: m['start_time']?.toString() ?? '',
        endTime: m['end_time']?.toString() ?? '',
        room: m['room']?.toString() ?? '',
        slotCapacity: (m['slot_capacity'] as num?)?.toInt() ?? 0,
      );
    }).toList();
  }

  Future<void> insert(Schedule s) async {
    final conn = await DbConnection.connection;
    final safeRoom = s.room.replaceAll("'", "''");

    // We DO NOT insert schedule_id (it is auto-generated)
    final sql = '''
      INSERT INTO schedules (subject_id, day_of_week, start_time, end_time, room, slot_capacity)
      VALUES (${s.subjectId}, '${s.dayOfWeek}', '${s.startTime}', '${s.endTime}', '$safeRoom', ${s.slotCapacity})
    ''';
    await conn.execute(sql);
  }

  Future<void> delete(String id) async {
    final conn = await DbConnection.connection;
    await conn.execute("DELETE FROM schedules WHERE schedule_id = $id");
  }
}