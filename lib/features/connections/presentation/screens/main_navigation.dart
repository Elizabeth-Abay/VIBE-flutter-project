import 'package:flutter/material.dart';
import '../widgets/connection_toggle.dart';
import './connected_screen.dart';
import './sent_request.dart';
import '../../domain/entity/sent_request_user.dart';
import '../../domain/entity/connected_user.dart';

class ConnectionsMainLayout extends StatefulWidget {
  const ConnectionsMainLayout({super.key});

  @override
  State<ConnectionsMainLayout> createState() => _ConnectionsMainLayoutState();
}

class _ConnectionsMainLayoutState extends State<ConnectionsMainLayout> {
  final int _currentIndex = 0;

  final List<SentRequestUser> fakeSentRequests = [
    SentRequestUser(
      userId: 'req_1',
      name: 'Mariamawit',
      profileImage: 'assets/mariamawit.png',
      timestamp: '2m ago',
      isCancelled: true,
    ),
    SentRequestUser(
      userId: 'req_2',
      name: 'Hailu',
      profileImage: 'assets/hailu.png',
      timestamp: '15m ago',
      isCancelled: false,
    ),
    SentRequestUser(
      userId: 'req_3',
      name: 'Dawit Isaac',
      profileImage: 'assets/user_placeholder.png',
      timestamp: '1h ago',
      isCancelled: false,
    ),
    SentRequestUser(
      userId: 'req_4',
      name: 'Selam Tesfaye',
      profileImage: 'assets/user_placeholder.png',
      timestamp: '3h ago',
      isCancelled: false,
    ),
  ];

  final List<ConnectedUser> connectedMockData = [
    ConnectedUser(
      userId: 'conn_1',
      name: 'Lisa Carter',
      username: '@Lisa123',
      profileImage: 'assets/lisa_avatar.png',
      isLiked: true,
    ),
    ConnectedUser(
      userId: 'conn_2',
      name: 'Lisa Carter',
      username: '@Lisa12',
      profileImage: 'assets/lisa_avatar.png',
      isLiked: true,
    ),
    ConnectedUser(
      userId: 'conn_3',
      name: 'Lisa Carter',
      username: '@Lisa12',
      profileImage: 'assets/lisa_avatar.png',
      isLiked: true,
    ),
    ConnectedUser(
      userId: 'conn_4',
      name: 'Lisa Carter',
      username: '@Lisa12',
      profileImage: 'assets/lisa_avatar.png',
      isLiked: true,
    ),
    ConnectedUser(
      userId: 'conn_5',
      name: 'Helen',
      username: '@Helen',
      profileImage: 'assets/helen_avatar.png',
      isLiked: false,
    ),
    ConnectedUser(
      userId: 'conn_6',
      name: 'Abebe Kebede',
      username: '@abe123',
      profileImage: 'assets/abebe_avatar.png',
      isLiked: false,
    ),
    ConnectedUser(
      userId: 'conn_7',
      name: 'Tom Adams',
      username: '@Tomm',
      profileImage: 'assets/tom_avatar.png',
      isLiked: false,
    ),
    ConnectedUser(
      userId: 'conn_8',
      name: 'Tom Adams',
      username: '@Tomm',
      profileImage: 'assets/tom_avatar.png',
      isLiked: false,
    ),
  ];

  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050517),
      body: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            'Connections',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          ConnectionsToggle(
            onToggle: (index) {
              setState(() => _activeTab = index);
            },
          ),

          const SizedBox(height: 10),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),

              child: _activeTab == 0
                  ? ConnectionsListContainer(connections: connectedMockData)
                  : SentRequestsListContainer(),
            ),
          ),
        ],
      ),
    );
  }
}
