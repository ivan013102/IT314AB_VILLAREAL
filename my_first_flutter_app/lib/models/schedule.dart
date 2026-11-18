class Schedule {
  final String id;
  final String subjectId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final int slotCapacity;

  Schedule({
    this.id = '',
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
  });
}