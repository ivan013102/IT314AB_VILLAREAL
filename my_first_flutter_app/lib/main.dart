import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/db_connection.dart';
import 'models/student.dart';
import 'repositories/student_repository.dart';
import 'screens/subject_list_screen.dart';
import 'screens/schedule_list_screen.dart';
import 'screens/grade_list_screen.dart';
import 'screens/enrollment_list_screen.dart';

List<Student> students = [];
final StudentRepository _repo = StudentRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  try {
    final ok = await DbConnection.verify();
    debugPrint('Neon connection verified: $ok');
  } catch (e) {
    debugPrint('Neon connection FAILED: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Directory',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/student-list',
      routes: {
        '/student-list': (context) => const StudentListScreen(),
        '/student-details': (context) {
          final student = ModalRoute.of(context)!.settings.arguments as Student;
          return StudentDetailsScreen(student: student);
        },
        '/add-student': (context) => const AddStudentScreen(),
      },
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  bool isLoading = true;
  final Set<String> favoriteStudents = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() => isLoading = true);
    try {
      final data = await _repo.fetchAll();
      setState(() {
        students = data;
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load students: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSaveError([Object? error]) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Database error: ${error ?? 'unknown'}')),
    );
  }

  Future<void> _openStudentDetails(Student student) async {
    final updatedStudent = await Navigator.push<Student>(
      context,
      MaterialPageRoute<Student>(
        builder: (context) => StudentDetailsScreen(student: student),
      ),
    );

    if (!mounted || updatedStudent == null) return;

    final index = students.indexWhere(
          (item) => item.studentId == updatedStudent.studentId,
    );
    if (index == -1) return;

    final originalStudents = List<Student>.from(students);
    setState(() => students[index] = updatedStudent);

    try {
      await _repo.update(updatedStudent);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated in database.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => students = originalStudents);
      _showSaveError(error);
    }
  }

  Future<void> _openAddStudentScreen() async {
    final newStudent = await Navigator.push<Student>(
      context,
      MaterialPageRoute<Student>(
        builder: (context) => const AddStudentScreen(),
      ),
    );

    if (!mounted || newStudent == null) return;

    final normalizedId = newStudent.studentId.trim().toLowerCase();
    final alreadyExists = students.any(
          (s) => s.studentId.trim().toLowerCase() == normalizedId,
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This Student ID already exists.')),
      );
      return;
    }

    try {
      await _repo.insert(newStudent);
      if (!mounted) return;
      setState(() {
        students.add(newStudent);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newStudent.name} saved to database.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save student: $error')),
      );
    }
  }

  Future<void> _deleteStudent(int index) async {
    if (index < 0 || index >= students.length) return;
    final student = students[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Are you sure you want to delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    final originalStudents = List<Student>.from(students);
    final wasFavorite = favoriteStudents.contains(student.studentId);

    setState(() {
      students.removeWhere((s) => s.studentId == student.studentId);
      favoriteStudents.remove(student.studentId);
    });

    try {
      await _repo.delete(student.studentId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${student.name} deleted from database.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        students = originalStudents;
        if (wasFavorite) favoriteStudents.add(student.studentId);
      });
      _showSaveError(error);
    }
  }

  Future<void> _restoreStudents() async {
    final originalStudents = List<Student>.from(students);

    final defaults = <Student>[
      Student(
        image: 'assets/profile2.jpg',
        name: 'Ivan Villareal',
        course: 'BSIT',
        yearLevel: '3rd Year',
        age: 24,
        hobby: 'Photography',
        studentId: '1001',
        email: 'ivan@example.com',
        favoriteSubject: 'Snacks',
        isActive: true,
      ),
      Student(
        image: 'assets/Profile1.jpg',
        name: 'Mannes Artajo',
        course: 'BSIT',
        yearLevel: '2nd Year',
        age: 21,
        hobby: 'Reading',
        studentId: '1002',
        email: 'mannes@example.com',
        favoriteSubject: 'Programming',
        isActive: false,
      ),
      Student(
        image: 'assets/profile3.jpg',
        name: 'Wilken Montebon',
        course: 'BSIT',
        yearLevel: '1st Year',
        age: 20,
        hobby: 'Basketball',
        studentId: '1003',
        email: 'wilken@example.com',
        favoriteSubject: 'Database',
        isActive: true,
      ),
      Student(
        image: 'assets/profile4.png',
        name: 'John Kevin Villacorte',
        course: 'BSIT',
        yearLevel: '4th Year',
        age: 23,
        hobby: 'Drawing',
        studentId: '1004',
        email: 'john@example.com',
        favoriteSubject: 'Web Development',
        isActive: false,
      ),
      Student(
        image: 'assets/profile5.jpg',
        name: 'Keith Francheska Lopez',
        course: 'BSIT',
        yearLevel: '3rd Year',
        age: 22,
        hobby: 'Gaming',
        studentId: '1005',
        email: 'keith@example.com',
        favoriteSubject: 'Software Engineering',
        isActive: true,
      ),
      Student(
        image: 'assets/Profile6.jpg',
        name: 'Maria Santos',
        course: 'BSIT',
        yearLevel: '2nd Year',
        age: 21,
        hobby: 'Photography',
        studentId: '1006',
        email: 'maria@example.com',
        favoriteSubject: 'Multimedia',
        isActive: true,
      ),
    ];

    setState(() {
      students = defaults;
      favoriteStudents.clear();
    });

    try {
      await _repo.restoreDefaults(defaults);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Default students restored in database.')),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() => students = originalStudents);
      _showSaveError(error);
    }
  }

  Widget _buildStudentCard(Student student, int index) {
    final isFavorite = favoriteStudents.contains(student.studentId);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: () => _openStudentDetails(student),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(student.image),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${student.course} • ${student.yearLevel}'),
            const SizedBox(height: 4),
            Text(
              student.isActive ? 'ACTIVE' : 'INACTIVE',
              style: TextStyle(
                color: student.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.orange : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  if (isFavorite) {
                    favoriteStudents.remove(student.studentId);
                  } else {
                    favoriteStudents.add(student.studentId);
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteStudent(index),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Directory'),
        backgroundColor: Colors.teal,
        actions: [
          // ─── SCHEDULE BUTTON ───
          IconButton(
            icon: const Icon(Icons.calendar_today),
            tooltip: 'Schedules',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ScheduleListScreen(),
                ),
              );
            },
          ),
          // ─── GRADE BUTTON ───
          IconButton(
            icon: const Icon(Icons.grade),
            tooltip: 'Grades',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GradeListScreen(),
                ),
              );
            },
          ),
          // ─── ENROLLMENT BUTTON ───
          IconButton(
            icon: const Icon(Icons.assignment_ind),
            tooltip: 'Enrollments',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EnrollmentListScreen(),
                ),
              ).then((_) => _loadStudents());
            },
          ),
          // ─── SUBJECT BUTTON ───
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: 'Manage Subjects',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SubjectListScreen(),
                ),
              ).then((_) => _loadStudents());
            },
          ),
          // ─── ADD STUDENT BUTTON ───
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Student',
            onPressed: isLoading ? null : _openAddStudentScreen,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No students available'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _restoreStudents,
              child: const Text('Restore Students'),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) =>
            _buildStudentCard(students[index], index),
      ),
    );
  }
}

// ─── ADD STUDENT SCREEN ───
class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  @override
  void dispose() {
    studentIdController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  Future<void> _enrollStudent() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final newStudent = Student(
      image: 'assets/profile2.jpg',
      name: fullNameController.text.trim(),
      course: 'BSIT',
      yearLevel: '1st Year',
      age: 18,
      hobby: 'None',
      studentId: studentIdController.text.trim(),
      email: 'none',
      favoriteSubject: 'None',
      isActive: true,
    );

    if (!mounted) return;
    Navigator.pop<Student>(context, newStudent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enroll a New Student'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Student Enrollment Form', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextFormField(
                controller: studentIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Student ID (Numbers only)'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _enrollStudent,
                  child: Text(_isSaving ? 'Saving...' : 'Enroll Student'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── DETAILS SCREEN ───
class StudentDetailsScreen extends StatefulWidget {
  final Student student;
  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student student;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  void _showEditModal() {
    final nameController = TextEditingController(text: student.name);

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Student Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                final updatedStudent = Student(
                  image: student.image,
                  name: nameController.text.trim(),
                  course: student.course,
                  yearLevel: student.yearLevel,
                  age: student.age,
                  hobby: student.hobby,
                  studentId: student.studentId,
                  email: student.email,
                  favoriteSubject: student.favoriteSubject,
                  isActive: student.isActive,
                );
                setState(() => student = updatedStudent);
                Navigator.pop(dialogContext);
                Navigator.pop(context, updatedStudent);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ).then((_) => nameController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage(student.image),
            ),
            const SizedBox(height: 20),
            Text(student.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(student.isActive ? 'ACTIVE' : 'INACTIVE'),
            const SizedBox(height: 20),
            ListTile(title: Text('Student ID: ${student.studentId}')),
          ],
        ),
      ),
    );
  }
}