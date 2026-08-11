import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueGrey,

        appBar: AppBar(
          title: const Text("My First Flutter Application"),
          backgroundColor: Colors.teal,
        ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Profile Card
                Card(
                  margin: const EdgeInsets.all(20),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      // Flag 7 - Column Alignment
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        // Circular Profile Image
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.teal,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                            AssetImage("assets/download.jpg"),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Name
                        const Text(
                          "Ivan Vincent C. Villareal",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Course
                        const Text(
                          "BSIT - 3",
                          style: TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 15),

                        const Divider(),

                        const SizedBox(height: 10),

                        // Application Title
                        const Text(
                          "My First Flutter Application",
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Icon
                        const Icon(
                          Icons.sentiment_very_satisfied,
                          color: Colors.amber,
                          size: 40,
                        ),

                        const SizedBox(height: 15),

                        // Date
                        const Text(
                          "August 4, 2026",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 10),

                        // Hobby
                        const Text(
                          "Photography, Videography, & Video Editing",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 15),

                        // Flag 4 - Row
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Age: 24",
                              style: TextStyle(fontSize: 16),
                            ),

                            SizedBox(width: 30),

                            Text(
                              "Birthdate: June 2002",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Space between the two cards
                const SizedBox(height: 10),

                // Flag 8 - Favorites Card
                Card(
                  margin: const EdgeInsets.all(20),

                  child: Padding(
                    padding: const EdgeInsets.all(20),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [

                        const Text(
                          "My Favorites",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        const Chip(
                          label: Text("Favorite Game: Basketball"),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Favorite Food: Chicken Halang-Halang",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Favorite Movie: Paksiw Anak sa Liking Kawayan",
                          style: TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 15),

                        // Row for Flag 8
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Photography",
                              style: TextStyle(fontSize: 16),
                            ),

                            SizedBox(width: 30),

                            Text(
                              "Videography",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}