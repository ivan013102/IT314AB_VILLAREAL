import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _studentsStorageKey = 'student_directory_records_v1';

void main() {
  runApp(const MyApp());
}

class Student {
  final String image;
  final String name;
  final String course;
  final String yearLevel;
  final int age;
  final String hobby;
  final String studentId;
  final String email;
  final String favoriteSubject;
  final bool isActive;

  Student({
    required this.image,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.age,
    required this.hobby,
    required this.studentId,
    required this.email,
    required this.favoriteSubject,
    required this.isActive,
  });

  Map<String, dynamic> toJson() => {
    'image': image,
    'name': name,
    'course': course,
    'yearLevel': yearLevel,
    'age': age,
    'hobby': hobby,
    'studentId': studentId,
    'email': email,
    'favoriteSubject': favoriteSubject,
    'isActive': isActive,
  };

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      image: json['image'] as String? ?? 'assets/profile2.jpg',
      name: json['name'] as String? ?? '',
      course: json['course'] as String? ?? '',
      yearLevel: json['yearLevel'] as String? ?? '',
      age: (json['age'] as num?)?.toInt() ?? 18,
      hobby: json['hobby'] as String? ?? 'Not specified',
      studentId: json['studentId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      favoriteSubject:
      json['favoriteSubject'] as String? ?? 'Not specified',
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Student copyWith({
    String? name,
    String? course,
    String? yearLevel,
    int? age,
    String? hobby,
    String? email,
    String? favoriteSubject,
  }) {
    return Student(
      image: image,
      name: name ?? this.name,
      course: course ?? this.course,
      yearLevel: yearLevel ?? this.yearLevel,
      age: age ?? this.age,
      hobby: hobby ?? this.hobby,
      studentId: studentId,
      email: email ?? this.email,
      favoriteSubject: favoriteSubject ?? this.favoriteSubject,
      isActive: isActive,
    );
  }
}

List<Student> students = [
  Student(
    image: 'assets/profile2.jpg',
    name: 'Ivan Villareal',
    course: 'BSIT',
    yearLevel: '3rd Year',
    age: 24,
    hobby: 'Photography, Videography, & Video Editing',
    studentId: '2026-0001',
    email: 'ivan.villareal@dbtc-cebu.edu.ph',
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
    studentId: '2026-0002',
    email: 'mannes.artajo@dbtc-cebu.edu.ph',
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
    studentId: '2026-0003',
    email: 'wilken.montebon@dbtc-cebu.edu.ph',
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
    studentId: '2026-0004',
    email: 'john.villacorte@dbtc-cebu.edu.ph',
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
    studentId: '2026-0005',
    email: 'keith.lopez@dbtc-cebu.edu.ph',
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
    studentId: '2026-0006',
    email: 'maria.santos@dbtc-cebu.edu.ph',
    favoriteSubject: 'Multimedia',
    isActive: true,
  ),
];

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
          final student =
          ModalRoute.of(context)!.settings.arguments as Student;

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
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(_studentsStorageKey);

      if (savedJson != null) {
        final decoded = jsonDecode(savedJson) as List<dynamic>;

        final loadedStudents = decoded
            .map(
              (item) => Student.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
            .toList();

        students = loadedStudents;
      } else {

        await _saveStudents();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not load saved records. Showing available records.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      students.map((student) => student.toJson()).toList(),
    );

    final saved = await prefs.setString(
      _studentsStorageKey,
      encoded,
    );

    if (!saved) {
      throw Exception('Unable to save student records.');
    }
  }

  void _showSaveError() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Could not save student records. Please try again.',
        ),
      ),
    );
  }

  Future<void> _openStudentDetails(Student student) async {
    final updatedStudent = await Navigator.push<Student>(
      context,
      MaterialPageRoute<Student>(
        builder: (context) => StudentDetailsScreen(
          student: student,
        ),
      ),
    );

    if (!mounted || updatedStudent == null) return;

    final index = students.indexWhere(
          (item) => item.studentId == updatedStudent.studentId,
    );

    if (index == -1) return;

    final originalStudents = List<Student>.from(students);

    setState(() {
      students[index] = updatedStudent;
    });

    try {
      await _saveStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student information updated and saved.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        students = originalStudents;
      });

      _showSaveError();
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
          (student) =>
      student.studentId.trim().toLowerCase() == normalizedId,
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This Student ID already exists.'),
        ),
      );
      return;
    }

    final originalStudents = List<Student>.from(students);

    setState(() {
      students.add(newStudent);
    });

    try {
      await _saveStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${newStudent.name} was enrolled and saved successfully.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        students = originalStudents;
      });

      _showSaveError();
    }
  }

  Future<void> _deleteStudent(int index) async {
    if (index < 0 || index >= students.length) return;

    final student = students[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Student'),
          content: Text(
            'Are you sure you want to delete ${student.name}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmed != true) return;

    final originalStudents = List<Student>.from(students);
    final wasFavorite = favoriteStudents.contains(student.studentId);

    setState(() {
      students.removeWhere(
            (item) => item.studentId == student.studentId,
      );

      favoriteStudents.remove(student.studentId);
    });

    try {
      await _saveStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${student.name} was deleted successfully.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        students = originalStudents;

        if (wasFavorite) {
          favoriteStudents.add(student.studentId);
        }
      });

      _showSaveError();
    }
  }

  Future<void> _restoreStudents() async {
    final originalStudents = List<Student>.from(students);

    final defaultStudents = <Student>[
      Student(
        image: 'assets/profile2.jpg',
        name: 'Ivan Villareal',
        course: 'BSIT',
        yearLevel: '3rd Year',
        age: 24,
        hobby: 'Photography, Videography, & Video Editing',
        studentId: '2026-0001',
        email: 'ivan.villareal@dbtc-cebu.edu.ph',
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
        studentId: '2026-0002',
        email: 'mannes.artajo@dbtc-cebu.edu.ph',
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
        studentId: '2026-0003',
        email: 'wilken.montebon@dbtc-cebu.edu.ph',
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
        studentId: '2026-0004',
        email: 'john.villacorte@dbtc-cebu.edu.ph',
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
        studentId: '2026-0005',
        email: 'keith.lopez@dbtc-cebu.edu.ph',
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
        studentId: '2026-0006',
        email: 'maria.santos@dbtc-cebu.edu.ph',
        favoriteSubject: 'Multimedia',
        isActive: true,
      ),
    ];

    setState(() {
      students = defaultStudents;
      favoriteStudents.clear();
    });

    try {
      await _saveStudents();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Default student records restored and saved.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      setState(() {
        students = originalStudents;
      });

      _showSaveError();
    }
  }

  Widget _buildStudentCard(Student student, int index) {
    final isFavorite = favoriteStudents.contains(student.studentId);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        onTap: () => _openStudentDetails(student),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(student.image),
        ),
        title: Text(
          student.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
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
            if (!student.isActive)
              const Text(
                'This student is currently inactive.',
                style: TextStyle(color: Colors.red),
              ),
            if (isFavorite)
              const Text(
                '★ Favorite Student',
                style: TextStyle(
                  color: Colors.orange,
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
              tooltip: 'Favorite Student',
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
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),
              tooltip: 'Edit Student',
              onPressed: () => _openStudentDetails(student),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              tooltip: 'Delete Student',
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
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Add Student',
            onPressed: isLoading ? null : _openAddStudentScreen,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No students available',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        itemBuilder: (context, index) {
          return _buildStudentCard(
            students[index],
            index,
          );
        },
      ),
    );
  }
}

class StudentDetailsScreen extends StatefulWidget {
  final Student student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailsScreen> createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late Student student;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  // EDIT STUDENT MODAL
  void _showEditModal() {
    final nameController = TextEditingController(text: student.name);
    final courseController = TextEditingController(text: student.course);
    final yearController = TextEditingController(text: student.yearLevel);
    final ageController = TextEditingController(
      text: student.age.toString(),
    );
    final hobbyController = TextEditingController(text: student.hobby);
    final emailController = TextEditingController(text: student.email);
    final subjectController = TextEditingController(
      text: student.favoriteSubject,
    );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                TextField(
                  controller: courseController,
                  decoration: const InputDecoration(
                    labelText: 'Course',
                  ),
                ),
                TextField(
                  controller: yearController,
                  decoration: const InputDecoration(
                    labelText: 'Year Level',
                  ),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                ),
                TextField(
                  controller: hobbyController,
                  decoration: const InputDecoration(
                    labelText: 'Hobby',
                  ),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextField(
                  controller: subjectController,
                  decoration: const InputDecoration(
                    labelText: 'Favorite Subject',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredAge =
                int.tryParse(ageController.text.trim());

                if (nameController.text.trim().isEmpty ||
                    courseController.text.trim().isEmpty ||
                    yearController.text.trim().isEmpty ||
                    enteredAge == null ||
                    enteredAge <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a name, course, year level, and valid age.',
                      ),
                    ),
                  );
                  return;
                }

                final updatedStudent = student.copyWith(
                  name: nameController.text.trim(),
                  course: courseController.text.trim().toUpperCase(),
                  yearLevel: yearController.text.trim(),
                  age: enteredAge,
                  hobby: hobbyController.text.trim(),
                  email: emailController.text.trim(),
                  favoriteSubject: subjectController.text.trim(),
                );

                setState(() {
                  student = updatedStudent;
                });

                // Close the modal and return the updated student.
                Navigator.pop(dialogContext);
                Navigator.pop(context, updatedStudent);
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      courseController.dispose();
      yearController.dispose();
      ageController.dispose();
      hobbyController.dispose();
      emailController.dispose();
      subjectController.dispose();
    });
  }

  Widget _infoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 17),
      ),
    );
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
            tooltip: 'Edit Student',
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
            Text(
              student.name,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              student.isActive ? 'ACTIVE' : 'INACTIVE',
              style: TextStyle(
                color: student.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoLine('Student ID', student.studentId),
                  _infoLine('Course', student.course),
                  _infoLine('Year Level', student.yearLevel),
                  _infoLine('Age', student.age.toString()),
                  _infoLine('Hobby', student.hobby),
                  _infoLine('Email', student.email),
                  _infoLine(
                    'Favorite Subject',
                    student.favoriteSubject,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              onPressed: _showEditModal,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Student'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  final TextEditingController studentIdController =
  TextEditingController();
  final TextEditingController fullNameController =
  TextEditingController();
  final TextEditingController courseController =
  TextEditingController();
  final TextEditingController yearLevelController =
  TextEditingController();
  final TextEditingController emailController =
  TextEditingController();

  static const List<String> _validYearLevels = [
    '1st Year',
    '2nd Year',
    '3rd Year',
    '4th Year',
  ];

  @override
  void dispose() {
    studentIdController.dispose();
    fullNameController.dispose();
    courseController.dispose();
    yearLevelController.dispose();
    emailController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String label,
    required String hint,
    required IconData icon,
    String? helperText,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helperText,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _studentIdValidator(String? value) {
    final requiredError = _requiredValidator(value);

    if (requiredError != null) {
      return 'Student ID is required';
    }

    final enteredId = value!.trim().toLowerCase();

    final alreadyExists = students.any(
          (student) =>
      student.studentId.trim().toLowerCase() == enteredId,
    );

    if (alreadyExists) {
      return 'This Student ID already exists';
    }

    return null;
  }

  String? _yearLevelValidator(String? value) {
    final requiredError = _requiredValidator(value);

    if (requiredError != null) {
      return 'Year level is required';
    }

    final enteredYear = value!.trim().toLowerCase();

    final isValidYear = _validYearLevels.any(
          (year) => year.toLowerCase() == enteredYear,
    );

    if (!isValidYear) {
      return 'Enter 1st Year, 2nd Year, 3rd Year, or 4th Year';
    }

    return null;
  }

  String? _emailValidator(String? value) {
    final requiredError = _requiredValidator(value);

    if (requiredError != null) {
      return 'Email address is required';
    }

    final email = value!.trim();
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

    if (!emailPattern.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  Future<void> _enrollStudent() async {
    if (_isSaving || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final enteredYear = _validYearLevels.firstWhere(
          (year) =>
      year.toLowerCase() ==
          yearLevelController.text.trim().toLowerCase(),
    );

    final newStudent = Student(
      image: 'assets/profile2.jpg',
      name: fullNameController.text.trim(),
      course: courseController.text.trim().toUpperCase(),
      yearLevel: enteredYear,
      age: 18,
      hobby: 'Not specified',
      studentId: studentIdController.text.trim(),
      email: emailController.text.trim(),
      favoriteSubject: 'Not specified',
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
              const Text(
                'Student Enrollment Form',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the student information in the fields below.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: studentIdController,
                decoration: _fieldDecoration(
                  label: 'Student ID',
                  hint: 'e.g. 2026-0007',
                  icon: Icons.badge_outlined,
                ),
                validator: _studentIdValidator,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: fullNameController,
                textCapitalization: TextCapitalization.words,
                decoration: _fieldDecoration(
                  label: 'Full Name',
                  hint: 'Enter full name',
                  icon: Icons.person_outline,
                ),
                validator: (value) {
                  final error = _requiredValidator(value);
                  return error == null ? null : 'Full name is required';
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: courseController,
                textCapitalization: TextCapitalization.characters,
                decoration: _fieldDecoration(
                  label: 'Course',
                  hint: 'e.g. BSIT',
                  icon: Icons.school_outlined,
                ),
                validator: (value) {
                  final error = _requiredValidator(value);
                  return error == null ? null : 'Course is required';
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: yearLevelController,
                textCapitalization: TextCapitalization.words,
                decoration: _fieldDecoration(
                  label: 'Year Level',
                  hint: 'e.g. 1st Year',
                  icon: Icons.calendar_today_outlined,
                  helperText:
                  'Use 1st Year, 2nd Year, 3rd Year, or 4th Year',
                ),
                validator: _yearLevelValidator,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _fieldDecoration(
                  label: 'Email Address',
                  hint: 'e.g. student@example.com',
                  icon: Icons.email_outlined,
                ),
                validator: _emailValidator,
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _enrollStudent,
                  icon: _isSaving
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.person_add_alt_1),
                  label: Text(
                    _isSaving ? 'Saving Student...' : 'Enroll Student',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}