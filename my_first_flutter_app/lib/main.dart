import 'package:flutter/material.dart';

void main() {
  // FLAG 7 - Sort students alphabetically before running the app
  students.sort(
        (a, b) => a.name.toLowerCase().compareTo(
      b.name.toLowerCase(),
    ),
  );

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

  // FLAG 5 - Additional Fields
  final String studentId;
  final String email;
  final String favoriteSubject;

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
  });
}

// STUDENT LIST
// FLAG 7 - This list can be sorted.
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
  ),

  // MARIA SANTOS
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
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        backgroundColor: Colors.blueGrey,

        appBar: AppBar(
          title: const Text("Student Directory"),
          backgroundColor: Colors.teal,
        ),

        // FLAG 6 - EMPTY STATE
        body: students.isEmpty
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                color: Colors.white,
                size: 70,
              ),

              SizedBox(height: 15),

              Text(
                "No students found.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "The student list is currently empty.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )

        // FLAG 4 & 5 - STUDENT LIST
            : ListView.builder(
          padding: const EdgeInsets.all(10),

          itemCount: students.length,

          itemBuilder: (context, index) {
            final student = students[index];

            return Card(
              margin: const EdgeInsets.all(10),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [
                    // Profile Image
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        student.image,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Name
                    Text(
                      student.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Course & Year
                    Text(
                      "${student.course} - ${student.yearLevel}",
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Age
                    Text(
                      "Age: ${student.age}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Hobby
                    Text(
                      "Hobby: ${student.hobby}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const Divider(height: 30),

                    // FLAG 5 - Student ID
                    Text(
                      "Student ID: ${student.studentId}",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Email
                    Text(
                      "Email: ${student.email}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Favorite Subject
                    Text(
                      "Favorite Subject: ${student.favoriteSubject}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}