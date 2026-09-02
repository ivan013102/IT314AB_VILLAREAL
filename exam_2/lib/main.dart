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
      title: 'Social',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF161213),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const SocialPage(),
    );
  }
}


class Friend {
  final String name;
  final String status;
  final String game;
  final bool online;
  final bool playing;
  final bool mobile;

  const Friend({
    required this.name,
    required this.status,
    required this.game,
    required this.online,
    required this.playing,
    required this.mobile,
  });
}


class SocialPage extends StatelessWidget {
  const SocialPage({super.key});


  final String pageTitle = 'Social';

  final String friendsTab = 'Friends';
  final String messagesTab = 'Messages';
  final String requestsTab = 'Requests';

  final String searchHint = 'Search';

  final String valorantName = 'VALORANT';
  final int valorantCount = 3;

  final String onlineTitle = 'Online';
  final int onlineCount = 4;

  final List<Friend> valorantFriends = const [
    Friend(
      name: 'MissYouLikeKrazy',
      status: 'Online',
      game: 'VALORANT',
      online: true,
      playing: false,
      mobile: false,
    ),
    Friend(
      name: 'bread',
      status: 'Playing',
      game: 'VALORANT',
      online: true,
      playing: true,
      mobile: false,
    ),
    Friend(
      name: 'The14th',
      status: 'Playing',
      game: 'VALORANT',
      online: true,
      playing: true,
      mobile: false,
    ),
  ];

  final List<Friend> onlineFriends = const [
    Friend(
      name: 'Carlvendish',
      status: 'Away',
      game: 'Riot Mobile',
      online: false,
      playing: false,
      mobile: true,
    ),
    Friend(
      name: 'D1yah',
      status: 'Away',
      game: 'Riot Mobile',
      online: false,
      playing: false,
      mobile: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF161213),

      body: SafeArea(
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.only(
                left: 22,
                top: 8,
                right: 22,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    pageTitle.isEmpty ? 'Social' : pageTitle,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [

                      _tab(
                        friendsTab,
                        true,
                      ),

                      const SizedBox(width: 34),

                      _tab(
                        messagesTab,
                        false,
                      ),

                      const SizedBox(width: 34),

                      _tab(
                        requestsTab,
                        false,
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Container(
                    height: 1,
                    color: const Color(0xFF352F30),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 17,
                  bottom: 30,
                ),

                children: [

                  Container(
                    height: 51,
                    decoration: BoxDecoration(
                      color: const Color(0xFF231F20),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),

                      decoration: InputDecoration(
                        hintText: searchHint,
                        hintStyle: const TextStyle(
                          color: Color(0xFFAAA5A6),
                          fontSize: 17,
                        ),

                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFAAA5A6),
                          size: 28,
                        ),

                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 23),

                  Row(
                    children: [

                      const ValorantLogo(),

                      const SizedBox(width: 16),

                      Text(
                        valorantName.isEmpty
                            ? 'Unknown Game'
                            : valorantName,

                        style: const TextStyle(
                          color: Color(0xFFB9B5B6),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        valorantCount.toString(),

                        style: const TextStyle(
                          color: Color(0xFF777273),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 13),

                  ...valorantFriends.map(
                        (friend) => FriendTile(
                      friend: friend,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.only(
                      left: 13,
                    ),

                    child: Row(
                      children: [

                        Text(
                          onlineTitle.isEmpty
                              ? 'Online'
                              : onlineTitle,

                          style: const TextStyle(
                            color: Color(0xFFB9B5B6),
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(width: 9),

                        Text(
                          onlineCount.toString(),

                          style: const TextStyle(
                            color: Color(0xFF777273),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ONLINE FRIENDS
                  ...onlineFriends.map(
                        (friend) => FriendTile(
                      friend: friend,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(
      String text,
      bool selected,
      ) {
    return Column(
      children: [

        Text(
          text.isEmpty ? 'Tab' : text,

          style: TextStyle(
            color: selected
                ? const Color(0xFFE6E1E2)
                : const Color(0xFFAAA5A6),

            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 13),

        Container(
          width: selected ? 40 : 0,
          height: 2,
          color: selected
              ? const Color(0xFFFF4655)
              : Colors.transparent,
        ),
      ],
    );
  }
}
