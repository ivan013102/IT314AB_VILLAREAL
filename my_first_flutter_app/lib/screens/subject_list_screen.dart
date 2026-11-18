import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../repositories/subject_repository.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final SubjectRepository _repo = SubjectRepository();
  List<Subject> subjects = [];
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
        subjects = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _showAddDialog() async {
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final unitsCtrl = TextEditingController(text: '3');
    final descCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Subject'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Subject Code (e.g., IT101)')),
              const SizedBox(height: 8),
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Subject Name')),
              const SizedBox(height: 8),
              TextField(controller: unitsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Units')),
              const SizedBox(height: 8),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final code = codeCtrl.text.trim();
              final name = nameCtrl.text.trim();
              final units = int.tryParse(unitsCtrl.text.trim()) ?? 3;
              final desc = descCtrl.text.trim();

              if (code.isEmpty || name.isEmpty) return;

              try {
                await _repo.insert(Subject(
                    subjectCode: code,
                    subjectName: name,
                    units: units,
                    description: desc
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

  Future<void> _delete(Subject s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Delete ${s.subjectName}?'),
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
      appBar: AppBar(title: const Text('Subjects'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : subjects.isEmpty
          ? const Center(child: Text('No subjects available. Tap + to add.'))
          : ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (_, i) {
          final s = subjects[i];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.teal),
              title: Text('${s.subjectCode} - ${s.subjectName}'),
              subtitle: Text('${s.units} units • ${s.description}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _delete(s),
              ),
            ),
          );
        },
      ),
    );
  }
}