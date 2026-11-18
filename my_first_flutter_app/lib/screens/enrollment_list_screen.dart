import 'package:flutter/material.dart';
import '../models/enrollment.dart';
import '../repositories/enrollment_repository.dart';

class EnrollmentListScreen extends StatefulWidget {
  const EnrollmentListScreen({super.key});
  @override
  State<EnrollmentListScreen> createState() => _EnrollmentListScreenState();
}

class _EnrollmentListScreenState extends State<EnrollmentListScreen> {
  final EnrollmentRepository _repo = EnrollmentRepository();
  List<Enrollment> enrollments = [];
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
      setState(() {
        enrollments = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _showAddDialog() async {
    final studentCtrl = TextEditingController();
    final subjectCtrl = TextEditingController(); // Added back
    final scheduleCtrl = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enroll Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Student ID'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subjectCtrl, // Added back
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Subject ID'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: scheduleCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Schedule ID'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              studentCtrl.clear();
              subjectCtrl.clear();
              scheduleCtrl.clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (studentCtrl.text.isEmpty || subjectCtrl.text.isEmpty || scheduleCtrl.text.isEmpty) return;

              try {
                await _repo.insert(Enrollment(
                  studentId: studentCtrl.text.trim(),
                  subjectId: subjectCtrl.text.trim(), // Added back
                  scheduleId: scheduleCtrl.text.trim(),
                ));
                if (!mounted) return;
                Navigator.pop(dialogContext);
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

  Future<void> _delete(Enrollment e) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Drop Enrollment'),
        content: const Text('Are you sure you want to drop this enrollment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Drop')),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _repo.delete(e.id);
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollments'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : enrollments.isEmpty
          ? const Center(child: Text('No enrollments available.'))
          : ListView.builder(
        itemCount: enrollments.length,
        itemBuilder: (_, i) {
          final e = enrollments[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.assignment_ind, color: Colors.teal),
              title: Text('Student ID: ${e.studentId}'),
              subtitle: Text('Subject ID: ${e.subjectId} • Schedule ID: ${e.scheduleId}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _delete(e),
              ),
            ),
          );
        },
      ),
    );
  }
}