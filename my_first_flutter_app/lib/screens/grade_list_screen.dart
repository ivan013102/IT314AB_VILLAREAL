import 'package:flutter/material.dart';
import '../models/grade.dart';
import '../repositories/grade_repository.dart';

class GradeListScreen extends StatefulWidget {
  const GradeListScreen({super.key});
  @override
  State<GradeListScreen> createState() => _GradeListScreenState();
}

class _GradeListScreenState extends State<GradeListScreen> {
  final GradeRepository _repo = GradeRepository();
  List<Grade> grades = [];
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
        grades = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _showAddDialog() async {
    final studentCtrl = TextEditingController();
    final subjectCtrl = TextEditingController();
    final scoreCtrl = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Grade'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Student ID (Number)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: subjectCtrl,
                // Changed to text because your DB uses character varying for subject
                decoration: const InputDecoration(labelText: 'Subject (e.g., IT101)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: scoreCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Score (e.g., 1.5)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              studentCtrl.clear();
              subjectCtrl.clear();
              scoreCtrl.clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (studentCtrl.text.isEmpty || subjectCtrl.text.isEmpty || scoreCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              final double? parsedScore = double.tryParse(scoreCtrl.text.trim());
              if (parsedScore == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid score number')),
                );
                return;
              }

              try {
                await _repo.insert(Grade(
                  studentId: studentCtrl.text.trim(),
                  subject: subjectCtrl.text.trim(),
                  score: parsedScore,
                ));
                if (!mounted) return;
                Navigator.pop(dialogContext);
                _load();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(Grade g) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Grade'),
        content: const Text('Delete this grade?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _repo.delete(g.id);
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grades'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : grades.isEmpty
          ? const Center(child: Text('No grades available.'))
          : ListView.builder(
        itemCount: grades.length,
        itemBuilder: (_, i) {
          final g = grades[i];

          // Calculate Passed/Failed purely for the UI
          final isPassed = g.score >= 1.0 && g.score <= 3.0;
          final remarkColor = isPassed ? Colors.green : Colors.red;
          final remarkText = isPassed ? 'PASSED' : 'FAILED';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.grade, color: Colors.teal),
              title: Text('Student ID: ${g.studentId} • Subject: ${g.subject}'),
              subtitle: Row(
                children: [
                  Text('Score: ${g.score} • '),
                  Text(
                    remarkText,
                    style: TextStyle(
                      color: remarkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _delete(g),
              ),
            ),
          );
        },
      ),
    );
  }
}