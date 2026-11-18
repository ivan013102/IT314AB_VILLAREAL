import 'package:flutter/material.dart';
import '../models/schedule.dart';
import '../repositories/schedule_repository.dart';

class ScheduleListScreen extends StatefulWidget {
  const ScheduleListScreen({super.key});
  @override
  State<ScheduleListScreen> createState() => _ScheduleListScreenState();
}

class _ScheduleListScreenState extends State<ScheduleListScreen> {
  final ScheduleRepository _repo = ScheduleRepository();
  List<Schedule> schedules = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    try {
      final data = await _repo.fetchAll();
      if (!mounted) return;
      setState(() { schedules = data; isLoading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _showAddDialog() async {
    final subjectCtrl = TextEditingController();
    final dayCtrl = TextEditingController();
    final startCtrl = TextEditingController();
    final endCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    final capacityCtrl = TextEditingController(text: '30');

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Schedule'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: subjectCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Subject ID (Number)')),
              TextField(controller: dayCtrl, decoration: const InputDecoration(labelText: 'Day (e.g., Monday)')),
              TextField(controller: startCtrl, decoration: const InputDecoration(labelText: 'Start Time (e.g., 08:00:00)')),
              TextField(controller: endCtrl, decoration: const InputDecoration(labelText: 'End Time (e.g., 10:00:00)')),
              TextField(controller: roomCtrl, decoration: const InputDecoration(labelText: 'Room')),
              TextField(controller: capacityCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Slot Capacity')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (subjectCtrl.text.isEmpty || dayCtrl.text.isEmpty) return;
              try {
                await _repo.insert(Schedule(
                  subjectId: subjectCtrl.text.trim(),
                  dayOfWeek: dayCtrl.text.trim(),
                  startTime: startCtrl.text.trim(),
                  endTime: endCtrl.text.trim(),
                  room: roomCtrl.text.trim(),
                  slotCapacity: int.tryParse(capacityCtrl.text.trim()) ?? 30,
                ));
                if (!mounted) return;
                Navigator.pop(context);
                _load();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(Schedule s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Schedule'),
        content: const Text('Delete this schedule?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _repo.delete(s.id);
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedules'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(onPressed: _showAddDialog, backgroundColor: Colors.teal, child: const Icon(Icons.add)),
      body: isLoading ? const Center(child: CircularProgressIndicator()) :
      schedules.isEmpty ? const Center(child: Text('No schedules available.')) :
      ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (_, i) {
          final s = schedules[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.teal),
              title: Text('Subject ID: ${s.subjectId} • ${s.dayOfWeek}'),
              subtitle: Text('${s.startTime} - ${s.endTime} • ${s.room} • Cap: ${s.slotCapacity}'),
              trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _delete(s)),
            ),
          );
        },
      ),
    );
  }
}