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
          child: Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/download.jpg", // Change this if your filename is different
                    width: 100,
                    height: 100,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Ivan Vincent C. Villareal",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  const Text("BSIT - 3", style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 8),

                  const Divider(),

                  const Text(
                    "My First Flutter Application",
                    style: TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 10),

                  const Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.amber,
                    size: 40,
                  ),

                  const SizedBox(height: 10),

                  const Text("August 4, 2026", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
