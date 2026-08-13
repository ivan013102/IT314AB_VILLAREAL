import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// FLAG 7 - Profile Data
class Profile {
  final String image;
  final String? name;
  final String? course;
  final int? age;
  final String? hobby;

  const Profile({
    required this.image,
    this.name,
    this.course,
    this.age,
    this.hobby,
  });
}

// Five different profiles
// Some profiles intentionally have missing information
const List<Profile> profiles = [
  Profile(
    image: "assets/profile2.jpg",
    name: "Ivan Villareal",
    course: "BSIT - 3",
    age: 24,
    hobby: "Photography, Videography, & Video Editing",
  ),

  Profile(
    image: "assets/Profile1.jpg",
    name: "Mannes Artajo",
    course: "BSIT - 2",
    age: 21,
    // Hobby is missing
  ),

  Profile(
    image: "assets/profile3.jpg",
    name: "Wilken Montebon",
    // Course is missing
    age: 20,
    hobby: "Basketball",
  ),

  Profile(
    image: "assets/profile4.png",
    // Name is missing
    course: "BSIT - 4",
    age: 23,
    hobby: "Drawing",
  ),

  Profile(
    image: "assets/profile5.jpg",
    name: "Keith Francheska Lopez",
    course: "BSIT - 3",
    age: 22,
    hobby: "Gaming",
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
          title: const Text("My First Flutter Application"),
          backgroundColor: Colors.teal,
        ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [

                // FLAG 7 - Display Five Profiles
                ...profiles.map(
                      (profile) => Card(
                    margin: const EdgeInsets.all(20),

                    child: Padding(
                      padding: const EdgeInsets.all(20),

                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [

                          // Profile Image
                          Container(
                            padding: const EdgeInsets.all(3),

                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.teal,
                            ),

                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                              AssetImage(profile.image),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Name
                          Text(
                            profile.name ?? "Not provided",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Course & Section
                          Text(
                            profile.course ?? "Unknown",
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 15),

                          const Divider(),

                          const SizedBox(height: 10),

                          // Age
                          Text(
                            "Age: ${profile.age ?? "Not provided"}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Hobby
                          Text(
                            profile.hobby ?? "Not provided",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // My Favorites
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
                          label: Text(
                            "Favorite Game: Basketball",
                          ),
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

                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,

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