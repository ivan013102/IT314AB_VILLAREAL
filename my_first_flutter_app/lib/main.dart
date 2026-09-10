import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
// STUDENT MODEL
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
      favoriteSubject:
      favoriteSubject ?? this.favoriteSubject,
      isActive: isActive,
    );
  }
}
// STUDENT DATA
List<Student> students = [
  Student(
    image: "assets/profile2.jpg",
    name: "Ivan Villareal",
    course: "BSIT",
    yearLevel: "3rd Year",
    age: 24,
    hobby: "Photography, Videography, & Video Editing",
    studentId: "2026-0001",
    email: "ivan.villareal@dbtc-cebu.edu.ph",
    favoriteSubject: "Snacks",
    isActive: true,
  ),
  Student(
    image: "assets/Profile1.jpg",
    name: "Mannes Artajo",
    course: "BSIT",
    yearLevel: "2nd Year",
    age: 21,
    hobby: "Reading",
    studentId: "2026-0002",
    email: "mannes.artajo@dbtc-cebu.edu.ph",
    favoriteSubject: "Programming",
    isActive: false,
  ),
  Student(
    image: "assets/profile3.jpg",
    name: "Wilken Montebon",
    course: "BSIT",
    yearLevel: "1st Year",
    age: 20,
    hobby: "Basketball",
    studentId: "2026-0003",
    email: "wilken.montebon@dbtc-cebu.edu.ph",
    favoriteSubject: "Database",
    isActive: true,
  ),
  Student(
    image: "assets/profile4.png",
    name: "John Kevin Villacorte",
    course: "BSIT",
    yearLevel: "4th Year",
    age: 23,
    hobby: "Drawing",
    studentId: "2026-0004",
    email: "john.villacorte@dbtc-cebu.edu.ph",
    favoriteSubject: "Web Development",
    isActive: false,
  ),
  Student(
    image: "assets/profile5.jpg",
    name: "Keith Francheska Lopez",
    course: "BSIT",
    yearLevel: "3rd Year",
    age: 22,
    hobby: "Gaming",
    studentId: "2026-0005",
    email: "keith.lopez@dbtc-cebu.edu.ph",
    favoriteSubject: "Software Engineering",
    isActive: true,
  ),
  Student(
    image: "assets/Profile6.jpg",
    name: "Maria Santos",
    course: "BSIT",
    yearLevel: "2nd Year",
    age: 21,
    hobby: "Photography",
    studentId: "2026-0006",
    email: "maria.santos@dbtc-cebu.edu.ph",
    favoriteSubject: "Multimedia",
    isActive: true,
  ),
];
// MAIN APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Student Directory",

      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),

      // NAMED ROUTES
      initialRoute: "/student-list",

      routes: {
        "/student-list": (context) =>
        const StudentListScreen(),

        // FLAG 7
        // RECEIVE STUDENT FROM ROUTE
        "/student-details": (context) {
          final student =
          ModalRoute.of(context)!
              .settings
              .arguments as Student;

          return StudentDetailsScreen(
            student: student,
          );
        },

        "/add-student": (context) =>
        const AddStudentScreen(),
      },
    );
  }
}
// STUDENT LIST SCREEN
class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() =>
      _StudentListScreenState();
}

class _StudentListScreenState
    extends State<StudentListScreen> {
  bool isLoading = true;

  final Set<String> favoriteStudents = {};

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 2),
          () {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      },
    );
  }
  // OPEN STUDENT DETAILS
  Future<void> _openStudentDetails(
      Student student) async {
    final updatedStudent =
    await Navigator.pushNamed<Student>(
      context,
      "/student-details",
      arguments: student,
    );

    if (updatedStudent != null) {
      setState(() {
        final index = students.indexWhere(
              (item) =>
          item.studentId ==
              updatedStudent.studentId,
        );

        if (index != -1) {
          students[index] = updatedStudent;
        }
      });
    }
  }

  // OPEN ADD STUDENT
  void _openAddStudentScreen() {
    Navigator.pushNamed(
      context,
      "/add-student",
    );
  }
  // DELETE STUDENT
  void _deleteStudent(int index) {
    final student = students[index];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Delete Student",
          ),

          content: Text(
            "Are you sure you want to delete "
                "${student.name}?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Cancel",
              ),
            ),

            TextButton(
              onPressed: () {
                setState(() {
                  students.removeAt(index);

                  favoriteStudents.remove(
                    student.studentId,
                  );
                });

                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Delete",
              ),
            ),
          ],
        );
      },
    );
  }
  // RESTORE STUDENTS
  void _restoreStudents() {
    setState(() {
      students = [
        Student(
          image: "assets/profile2.jpg",
          name: "Ivan Villareal",
          course: "BSIT",
          yearLevel: "3rd Year",
          age: 24,
          hobby:
          "Photography, Videography, & Video Editing",
          studentId: "2026-0001",
          email:
          "ivan.villareal@dbtc-cebu.edu.ph",
          favoriteSubject: "Snacks",
          isActive: true,
        ),
        Student(
          image: "assets/Profile1.jpg",
          name: "Mannes Artajo",
          course: "BSIT",
          yearLevel: "2nd Year",
          age: 21,
          hobby: "Reading",
          studentId: "2026-0002",
          email:
          "mannes.artajo@dbtc-cebu.edu.ph",
          favoriteSubject: "Programming",
          isActive: false,
        ),
        Student(
          image: "assets/profile3.jpg",
          name: "Wilken Montebon",
          course: "BSIT",
          yearLevel: "1st Year",
          age: 20,
          hobby: "Basketball",
          studentId: "2026-0003",
          email:
          "wilken.montebon@dbtc-cebu.edu.ph",
          favoriteSubject: "Database",
          isActive: true,
        ),
        Student(
          image: "assets/profile4.png",
          name: "John Kevin Villacorte",
          course: "BSIT",
          yearLevel: "4th Year",
          age: 23,
          hobby: "Drawing",
          studentId: "2026-0004",
          email:
          "john.villacorte@dbtc-cebu.edu.ph",
          favoriteSubject: "Web Development",
          isActive: false,
        ),
        Student(
          image: "assets/profile5.jpg",
          name: "Keith Francheska Lopez",
          course: "BSIT",
          yearLevel: "3rd Year",
          age: 22,
          hobby: "Gaming",
          studentId: "2026-0005",
          email:
          "keith.lopez@dbtc-cebu.edu.ph",
          favoriteSubject: "Software Engineering",
          isActive: true,
        ),
        Student(
          image: "assets/Profile6.jpg",
          name: "Maria Santos",
          course: "BSIT",
          yearLevel: "2nd Year",
          age: 21,
          hobby: "Photography",
          studentId: "2026-0006",
          email:
          "maria.santos@dbtc-cebu.edu.ph",
          favoriteSubject: "Multimedia",
          isActive: true,
        ),
      ];

      favoriteStudents.clear();
    });
  }
  // STUDENT CARD
  Widget _buildStudentCard(
      Student student, int index) {
    final isFavorite =
    favoriteStudents.contains(
      student.studentId,
    );

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),

      child: ListTile(
        // Clicking the student
        // opens Student Details
        onTap: () {
          _openStudentDetails(student);
        },

        leading: CircleAvatar(
          radius: 28,
          backgroundImage:
          AssetImage(student.image),
        ),

        title: Text(
          student.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        subtitle: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              "${student.course} • "
                  "${student.yearLevel}",
            ),

            const SizedBox(height: 4),

            Text(
              student.isActive
                  ? "ACTIVE"
                  : "INACTIVE",
              style: TextStyle(
                color: student.isActive
                    ? Colors.green
                    : Colors.red,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            if (!student.isActive)
              const Text(
                "This student is currently inactive.",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),

            if (isFavorite)
              const Text(
                "★ Favorite Student",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
          ],
        ),

        trailing: Row(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            // FAVORITE
            IconButton(
              icon: Icon(
                isFavorite
                    ? Icons.star
                    : Icons.star_border,
                color: isFavorite
                    ? Colors.orange
                    : Colors.grey,
              ),

              tooltip:
              "Favorite Student",

              onPressed: () {
                setState(() {
                  if (isFavorite) {
                    favoriteStudents.remove(
                      student.studentId,
                    );
                  } else {
                    favoriteStudents.add(
                      student.studentId,
                    );
                  }
                });
              },
            ),
            // EDIT / DETAILS
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blue,
              ),

              tooltip:
              "Edit Student",

              onPressed: () {
                _openStudentDetails(
                  student,
                );
              },
            ),
            // DELETE
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),

              tooltip:
              "Delete Student",

              onPressed: () {
                _deleteStudent(index);
              },
            ),
          ],
        ),
      ),
    );
  }
  // BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Directory",
        ),

        backgroundColor: Colors.teal,

        actions: [
          // ADD STUDENT
          IconButton(
            icon: const Icon(
              Icons.person_add,
            ),

            tooltip:
            "Add Student",

            onPressed:
            _openAddStudentScreen,
          ),
        ],
      ),

      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )

          : students.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey,
            ),

            const SizedBox(
              height: 16,
            ),

            const Text(
              "No students available",
              style: TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            ElevatedButton(
              onPressed:
              _restoreStudents,
              child: const Text(
                "Restore Students",
              ),
            ),
          ],
        ),
      )

          : ListView.builder(
        itemCount:
        students.length,
        itemBuilder:
            (context, index) {
          return _buildStudentCard(
            students[index],
            index,
          );
        },
      ),
    );
  }
}
// STUDENT DETAILS SCREEN
class StudentDetailsScreen
    extends StatefulWidget {

  // FLAG 7
  // RECEIVE STUDENT DIRECTLY
  final Student student;

  const StudentDetailsScreen({
    super.key,
    required this.student,
  });

  @override
  State<StudentDetailsScreen>
  createState() =>
      _StudentDetailsScreenState();
}

class _StudentDetailsScreenState
    extends State<StudentDetailsScreen> {

  late Student student;

  // FLAG 7
  // GET STUDENT FROM WIDGET
  @override
  void initState() {
    super.initState();

    student = widget.student;
  }

  // EDIT MODAL
  void _showEditModal() {
    final nameController =
    TextEditingController(
      text: student.name,
    );

    final courseController =
    TextEditingController(
      text: student.course,
    );

    final yearController =
    TextEditingController(
      text: student.yearLevel,
    );

    final ageController =
    TextEditingController(
      text: student.age.toString(),
    );

    final hobbyController =
    TextEditingController(
      text: student.hobby,
    );

    final emailController =
    TextEditingController(
      text: student.email,
    );

    final subjectController =
    TextEditingController(
      text: student.favoriteSubject,
    );

    // SHOW MODAL
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            "Edit Student",
          ),

          content:
          SingleChildScrollView(
            child: Column(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                TextField(
                  controller:
                  nameController,
                  decoration:
                  const InputDecoration(
                    labelText: "Name",
                  ),
                ),

                TextField(
                  controller:
                  courseController,
                  decoration:
                  const InputDecoration(
                    labelText: "Course",
                  ),
                ),

                TextField(
                  controller:
                  yearController,
                  decoration:
                  const InputDecoration(
                    labelText: "Year Level",
                  ),
                ),

                TextField(
                  controller:
                  ageController,
                  keyboardType:
                  TextInputType.number,
                  decoration:
                  const InputDecoration(
                    labelText: "Age",
                  ),
                ),

                TextField(
                  controller:
                  hobbyController,
                  decoration:
                  const InputDecoration(
                    labelText: "Hobby",
                  ),
                ),

                TextField(
                  controller:
                  emailController,
                  decoration:
                  const InputDecoration(
                    labelText: "Email",
                  ),
                ),

                TextField(
                  controller:
                  subjectController,
                  decoration:
                  const InputDecoration(
                    labelText:
                    "Favorite Subject",
                  ),
                ),
              ],
            ),
          ),

          // MODAL BUTTONS
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child: const Text(
                "Cancel",
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final updatedStudent =
                student.copyWith(
                  name:
                  nameController.text,

                  course:
                  courseController.text,

                  yearLevel:
                  yearController.text,

                  age: int.tryParse(
                    ageController.text,
                  ),

                  hobby:
                  hobbyController.text,

                  email:
                  emailController.text,

                  favoriteSubject:
                  subjectController.text,
                );

                // Update student
                setState(() {
                  student =
                      updatedStudent;
                });

                // Close Edit Modal
                Navigator.pop(
                  dialogContext,
                );

                // Return updated student
                // to Student List
                Navigator.pop(
                  context,
                  updatedStudent,
                );
              },

              child: const Text(
                "Save Changes",
              ),
            ),
          ],
        );
      },
    );
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Details",
        ),

        backgroundColor:
        Colors.teal,

        actions: [
          // EDIT ICON
          IconButton(
            icon: const Icon(
              Icons.edit,
            ),

            tooltip:
            "Edit Student",

            onPressed:
            _showEditModal,
          ),
        ],
      ),

      body:
      SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),

        child: Column(
          children: [

            // PROFILE IMAGE
            CircleAvatar(
              radius: 70,

              backgroundImage:
              AssetImage(
                student.image,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // NAME
            Text(
              student.name,

              style: const TextStyle(
                fontSize: 26,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // STATUS
            Text(
              student.isActive
                  ? "ACTIVE"
                  : "INACTIVE",

              style: TextStyle(
                color: student.isActive
                    ? Colors.green
                    : Colors.red,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // STUDENT INFORMATION
            Align(
              alignment:
              Alignment.centerLeft,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  Text(
                    "Student ID: "
                        "${student.studentId}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Course: "
                        "${student.course}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Year Level: "
                        "${student.yearLevel}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Age: "
                        "${student.age}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Hobby: "
                        "${student.hobby}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Email: "
                        "${student.email}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Favorite Subject: "
                        "${student.favoriteSubject}",

                    style:
                    const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // EDIT BUTTON
            ElevatedButton.icon(
              onPressed:
              _showEditModal,

              icon: const Icon(
                Icons.edit,
              ),

              label: const Text(
                "Edit Student",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ADD STUDENT SCREEN
class AddStudentScreen
    extends StatelessWidget {
  const AddStudentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Student",
        ),

        backgroundColor:
        Colors.teal,
      ),

      body: const Center(
        child: Text(
          "Add Student Screen",

          style: TextStyle(
            fontSize: 24,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }
}