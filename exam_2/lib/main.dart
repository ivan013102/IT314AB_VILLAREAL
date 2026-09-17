
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// APP
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

// MODELS
class ChatMessage {
  final String text;
  final bool isMe;

  const ChatMessage({
    required this.text,
    required this.isMe,
  });
}

class Friend {
  final String name;
  final String status;
  final String game;
  final bool online;
  final bool playing;
  final bool mobile;
  final String imagePath;

  const Friend({
    required this.name,
    required this.status,
    required this.game,
    required this.online,
    required this.playing,
    required this.mobile,
    required this.imagePath,
  });
}

// SOCIAL PAGE
class SocialPage extends StatefulWidget {
  const SocialPage({super.key});

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  int selectedTab = 0;
  String searchText = '';

  final TextEditingController searchController =
  TextEditingController();

  // FRIEND DATA
  final List<Friend> valorantFriends = const [
    Friend(
      name: 'ZoroJuro',
      status: 'Online',
      game: 'VALORANT',
      online: true,
      playing: false,
      mobile: false,
      imagePath: 'assets/images/avatar.png',
    ),
    Friend(
      name: 'bread',
      status: 'Playing',
      game: 'VALORANT',
      online: true,
      playing: true,
      mobile: false,
      imagePath: 'assets/images/avatar.png',
    ),
    Friend(
      name: 'The14th',
      status: 'Playing',
      game: 'VALORANT',
      online: true,
      playing: true,
      mobile: false,
      imagePath: 'assets/images/avatar.png',
    ),
  ];

  final List<Friend> onlineFriends = const [
    Friend(
      name: 'James Maano',
      status: 'Away',
      game: 'Riot Mobile',
      online: false,
      playing: false,
      mobile: true,
      imagePath: 'assets/images/avatar.png',
    ),
    Friend(
      name: 'Tonio the Gang Leader',
      status: 'Away',
      game: 'Riot Mobile',
      online: false,
      playing: false,
      mobile: true,
      imagePath: 'assets/images/avatar.png',
    ),
  ];

  // CHAT DATA
  final Map<String, List<ChatMessage>> chatMessages = {
    'ZoroJuro': [
      ChatMessage(
        text: 'Hello!',
        isMe: false,
      ),
      ChatMessage(
        text: 'Hey! How are you?',
        isMe: true,
      ),
    ],
    'bread': [
      ChatMessage(
        text: 'Let us play Valorant later.',
        isMe: false,
      ),
    ],
    'The14th': [],
    'James Maano': [],
    'Tonio the Gang Leader': [],
  };

  // GET ALL FRIENDS
  List<Friend> get allFriends {
    return [
      ...valorantFriends,
      ...onlineFriends,
    ];
  }

  // FILTER FRIENDS
  List<Friend> get filteredFriends {
    if (searchText.isEmpty) {
      return allFriends;
    }

    return allFriends.where((friend) {
      return friend.name
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  // GET LAST MESSAGE
  String getLastMessage(String name) {
    final messages = chatMessages[name] ?? [];

    if (messages.isEmpty) {
      return 'No message available';
    }

    if (messages.last.text.isEmpty) {
      return 'No message available';
    }

    return messages.last.text;
  }

  // OPEN CHATROOM
  void openChatroom(Friend friend) {
    final displayName = friend.name.isEmpty
        ? 'Unknown User'
        : friend.name;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChatroomPage(
            name: displayName,
            imagePath: friend.imagePath,
            online: friend.online,
            initialMessages: chatMessages[friend.name] ?? [],
          );
        },
      ),
    );
  }

  // BUILD
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Social',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildTab('Friends', 0),
                      const SizedBox(width: 34),
                      _buildTab('Messages', 1),
                      const SizedBox(width: 34),
                      _buildTab('Requests', 2),
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
                  _buildSearchBar(),

                  const SizedBox(height: 23),

                  if (selectedTab == 0)
                    _buildFriendsContent(),

                  if (selectedTab == 1)
                    _buildMessagesContent(),

                  if (selectedTab == 2)
                    _buildRequestsContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TABS
  Widget _buildTab(String text, int index) {
    final selected = selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
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
      ),
    );
  }

  // SEARCH BAR
  Widget _buildSearchBar() {
    return Container(
      height: 51,
      decoration: BoxDecoration(
        color: const Color(0xFF231F20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            searchText = value;
          });
        },
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: const InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Color(0xFFAAA5A6),
            fontSize: 17,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFFAAA5A6),
            size: 28,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // FRIENDS CONTENT
  Widget _buildFriendsContent() {
    final friends = filteredFriends;

    if (friends.isEmpty) {
      return _emptyMessage('No friends found');
    }

    return Column(
      children: friends.map((friend) {
        return FriendTile(
          friend: friend,
          onTap: () {
            openChatroom(friend);
          },
        );
      }).toList(),
    );
  }

  // MESSAGES CONTENT
  Widget _buildMessagesContent() {
    final friends = filteredFriends;

    if (friends.isEmpty) {
      return _emptyMessage('No conversations found');
    }

    return Column(
      children: friends.map((friend) {
        return ConversationTile(
          name: friend.name.isEmpty
              ? 'Unknown User'
              : friend.name,
          lastMessage: getLastMessage(friend.name),
          online: friend.online,
          imagePath: friend.imagePath,
          onTap: () {
            openChatroom(friend);
          },
        );
      }).toList(),
    );
  }

  // REQUESTS CONTENT
  Widget _buildRequestsContent() {
    return const Padding(
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: Text(
          'No friend requests',
          style: TextStyle(
            color: Color(0xFFAAA5A6),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // EMPTY MESSAGE
  Widget _emptyMessage(String text) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFFAAA5A6),
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// FRIEND TILE
class FriendTile extends StatelessWidget {
  final Friend friend;
  final VoidCallback? onTap;

  const FriendTile({
    super.key,
    required this.friend,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = friend.name.isEmpty
        ? 'Unknown User'
        : friend.name;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 12,
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _avatar(
                    friend.imagePath,
                    friend.online,
                    52,
                  ),

                  Positioned(
                    right: -2,
                    bottom: 1,
                    child: Container(
                      width: friend.playing ? 19 : 16,
                      height: friend.playing ? 19 : 16,
                      decoration: BoxDecoration(
                        color: friend.playing
                            ? const Color(0xFF00AEEF)
                            : friend.online
                            ? const Color(0xFF0BA66A)
                            : const Color(0xFFFFC20A),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF161213),
                          width: 2,
                        ),
                      ),
                      child: friend.playing
                          ? const Icon(
                        Icons.play_arrow,
                        size: 11,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Color(0xFFE7E2E3),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Row(
                      children: [
                        Icon(
                          friend.mobile
                              ? Icons.phone_android
                              : Icons.desktop_windows,
                          size: 17,
                          color: const Color(0xFFAAA5A6),
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            '${friend.status} - ${friend.game}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFAAA5A6),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF777273),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AVATAR WITH FALLBACK
  Widget _avatar(
      String imagePath,
      bool online,
      double size,
      ) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFF211E1F),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imagePath.isEmpty
            ? Icon(
          Icons.person,
          size: 31,
          color: online
              ? const Color(0xFFFF4655)
              : Colors.white,
        )
            : Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 31,
              color: online
                  ? const Color(0xFFFF4655)
                  : Colors.white,
            );
          },
        ),
      ),
    );
  }
}

// CONVERSATION TILE
class ConversationTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final bool online;
  final String imagePath;
  final VoidCallback? onTap;

  const ConversationTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.online,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = name.isEmpty
        ? 'Unknown User'
        : name;

    final displayMessage = lastMessage.isEmpty
        ? 'No message available'
        : lastMessage;

    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 8,
          ),
          child: Row(
            children: [
              _buildAvatar(),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Color(0xFFE7E2E3),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      displayMessage,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFAAA5A6),
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_right,
                color: Color(0xFF777273),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // AVATAR WITH FALLBACK
  Widget _buildAvatar() {
    return Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        color: Color(0xFF211E1F),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imagePath.isEmpty
            ? Icon(
          Icons.person,
          size: 31,
          color: online
              ? const Color(0xFFFF4655)
              : Colors.white,
        )
            : Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              size: 31,
              color: online
                  ? const Color(0xFFFF4655)
                  : Colors.white,
            );
          },
        ),
      ),
    );
  }
}

// CHATROOM PAGE
class ChatroomPage extends StatefulWidget {
  final String name;
  final String imagePath;
  final bool online;
  final List<ChatMessage> initialMessages;

  const ChatroomPage({
    super.key,
    required this.name,
    required this.imagePath,
    required this.online,
    required this.initialMessages,
  });

  @override
  State<ChatroomPage> createState() => _ChatroomPageState();
}

class _ChatroomPageState extends State<ChatroomPage> {
  final TextEditingController messageController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final displayName = widget.name.isEmpty
        ? 'Unknown User'
        : widget.name;

    final messages = widget.initialMessages;

    return Scaffold(
      backgroundColor: const Color(0xFF161213),

      appBar: AppBar(
        backgroundColor: const Color(0xFF161213),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),

        title: Row(
          children: [
            _buildProfileImage(),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    widget.online ? 'Online' : 'Away',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAAA5A6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // MESSAGE LIST
          Expanded(
            child: messages.isEmpty
                ? const Center(
              child: Text(
                'No message available',
                style: TextStyle(
                  color: Color(0xFFAAA5A6),
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return Align(
                  alignment: message.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: const BoxConstraints(
                      maxWidth: 280,
                    ),
                    decoration: BoxDecoration(
                      color: message.isMe
                          ? const Color(0xFFFF4655)
                          : const Color(0xFF2A2526),
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // MESSAGE INPUT
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                12,
                8,
                12,
                10,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF231F20),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: messageController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    hintStyle: TextStyle(
                      color: Color(0xFFAAA5A6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PROFILE IMAGE WITH FALLBACK
  Widget _buildProfileImage() {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFF211E1F),
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: widget.imagePath.isEmpty
            ? Icon(
          Icons.person,
          color: widget.online
              ? const Color(0xFFFF4655)
              : Colors.white,
        )
            : Image.asset(
          widget.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.person,
              color: widget.online
                  ? const Color(0xFFFF4655)
                  : Colors.white,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}

// GAMING ICON
class ValorantLogo extends StatelessWidget {
  const ValorantLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.sports_esports,
      color: Color(0xFFFF4655),
      size: 26,
    );
  }
}