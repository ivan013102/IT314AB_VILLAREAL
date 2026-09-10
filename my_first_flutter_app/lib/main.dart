import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// STUDENT DATA
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

  const Student({
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
}

// STUDENT LIST
final List<Student> students = [
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
    email: "john.villcorte@dbtc-cebu.edu.ph",
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
      home: const StudentDirectoryPage(),
    );
  }
}

// STUDENT DIRECTORY PAGE
class StudentDirectoryPage extends StatefulWidget {
  const StudentDirectoryPage({super.key});

  @override
  State<StudentDirectoryPage> createState() =>
      _StudentDirectoryPageState();
}

class _StudentDirectoryPageState extends State<StudentDirectoryPage> {
  // FLAG 4 & FLAG 5 - LOADING STATE
  bool isLoading = true;

  // FAVORITE STUDENTS
  final Set<String> favoriteStudents = {};

  @override
  void initState() {
    super.initState();

    // Simulate loading student data.
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  // FAVORITE
  void _toggleFavorite(Student student) {
    setState(() {
      if (favoriteStudents.contains(student.studentId)) {
        favoriteStudents.remove(student.studentId);
      } else {
        favoriteStudents.add(student.studentId);
      }
    });
  }

  // CHECK FAVORITE
  bool _isFavorite(Student student) {
    return favoriteStudents.contains(student.studentId);
  }

  // DELETE
  void _showDeleteDialog(int index) {
    final student = students[index];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Student?"),
          content: Text(
            "Are you sure you want to delete ${student.name}?",
          ),
          actions: [
            // CANCEL BUTTON
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),

            // DELETE BUTTON
            ElevatedButton(
              onPressed: () {
                final deletedName = student.name;

                Navigator.of(dialogContext).pop();

                setState(() {
                  students.removeAt(index);

                  // Remove from favorites if necessary.
                  favoriteStudents.remove(student.studentId);
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "$deletedName has been deleted.",
                    ),
                  ),
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // RESTORE STUDENTS
  void _restoreStudents() {
    setState(() {
      students.clear();

      students.addAll([
        const Student(
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
        const Student(
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
        const Student(
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
        const Student(
          image: "assets/profile4.png",
          name: "John Kevin Villacorte",
          course: "BSIT",
          yearLevel: "4th Year",
          age: 23,
          hobby: "Drawing",
          studentId: "2026-0004",
          email: "john.villcorte@dbtc-cebu.edu.ph",
          favoriteSubject: "Web Development",
          isActive: false,
        ),
        const Student(
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
        const Student(
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
      ]);
    });
  }

  // EDIT
  void _showEditDialog(Student student) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Edit Student"),
          content: Text(
            "You are about to edit ${student.name}'s information.",
          ),
          actions: [
            // CANCEL BUTTON
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text("Cancel"),
            ),

            // CONTINUE BUTTON
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Edit action started for ${student.name}.",
                    ),
                  ),
                );
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  // TOUCH ANYWHERE ON CARD
  void _showCardTapped(Student student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "You tapped ${student.name}'s card!",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,

      appBar: AppBar(
        title: const Text("Student Directory"),
        backgroundColor: Colors.teal,
      ),

      // FLAG 5 & FLAG 6 - MULTIPLE UI STATES
      body: isLoading
          ? const Center(
        // STATE 1: LOADING
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              "Loading Student Directory...",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : students.isEmpty
          ? Center(
        // STATE 2: EMPTY
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.people_outline,
              color: Colors.white,
              size: 70,
            ),

            const SizedBox(height: 15),

            const Text(
              "No students found.",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "The student list is currently empty.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            // RESTORE BUTTON
            ElevatedButton.icon(
              onPressed: _restoreStudents,
              icon: const Icon(Icons.refresh),
              label: const Text("Restore Students"),
            ),
          ],
        ),
      )
          : ListView.builder(
        // STATE 3: STUDENTS AVAILABLE
        padding: const EdgeInsets.all(10),
        itemCount: students.length,

        itemBuilder: (context, index) {
          final student = students[index];

          return Card(
            margin: const EdgeInsets.all(10),

            // Change appearance when favorited.
            color: _isFavorite(student)
                ? Colors.amber.shade100
                : Colors.white,

            child: InkWell(
              // Tap anywhere on card.
              onTap: () => _showCardTapped(student),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // PROFILE IMAGE
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                      AssetImage(student.image),
                    ),

                    const SizedBox(height: 15),

                    // NAME
                    Text(
                      student.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // FLAG 1 - ACTIVE / INACTIVE
                    student.isActive
                        ? const Text(
                      "ACTIVE",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : const Text(
                      "INACTIVE",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // FLAG 2 - SHOW WARNING ONLY WHEN INACTIVE
                    if (!student.isActive)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "⚠ This student is currently inactive.",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // FAVORITE LABEL
                    if (_isFavorite(student))
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          "★ FAVORITE STUDENT",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 8),

                    // COURSE AND YEAR
                    Text(
                      "${student.course} - ${student.yearLevel}",
                      style: const TextStyle(fontSize: 18),
                    ),

                    const SizedBox(height: 8),

                    // AGE
                    Text(
                      "Age: ${student.age}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    // HOBBY
                    Text(
                      "Hobby: ${student.hobby}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),

                    const Divider(height: 30),

                    // STUDENT ID
                    Text(
                      "Student ID: ${student.studentId}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    // EMAIL
                    Text(
                      "Email: ${student.email}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 8),

                    // FAVORITE SUBJECT
                    Text(
                      "Favorite Subject: ${student.favoriteSubject}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 15),

                    // ACTION BUTTONS
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        // FAVORITE BUTTON
                        ElevatedButton.icon(
                          onPressed: () {
                            _toggleFavorite(student);
                          },
                          icon: Icon(
                            _isFavorite(student)
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          label: Text(
                            _isFavorite(student)
                                ? "Favorited"
                                : "Favorite",
                          ),
                        ),

                        // EDIT BUTTON
                        ElevatedButton.icon(
                          onPressed: () {
                            _showEditDialog(student);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                        ),

                        // DELETE BUTTON
                        ElevatedButton.icon(
                          onPressed: () {
                            _showDeleteDialog(index);
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}