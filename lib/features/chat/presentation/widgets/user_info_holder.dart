import 'package:flutter/material.dart';
import '../../data/models/chat_users_info.dart';

class UserInfoHolder extends StatelessWidget implements PreferredSizeWidget {
  final ChatUserInfo userInfo;

  const UserInfoHolder({
    super.key,
    required this.userInfo
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(
        0xFF0B141A,
      ), // Matches the deep dark background
      elevation: 0,
      leadingWidth: 40, // Keeps the back arrow tight to the edge
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new, // Matches the sharp back chevron
          color: Colors.white,
          size: 20,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[800],
            backgroundImage: NetworkImage(userInfo.profileUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              userInfo.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600, // Semi-bold matching "Leul Kebede"
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      // Optional bottom border divider line matching the image
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: Colors.white.withOpacity(0.1), height: 1.0),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}
