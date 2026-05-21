import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../profiles/presentation/providers/profile_notifier.dart';
import '../../../profiles/data/repositories/profile_repository.dart';

class BlockedUsersScreen extends ConsumerWidget {
  const BlockedUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blockedAsync = ref.watch(blockedUsersProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: Column(
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Blocked Users',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: blockedAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  e.toString(),
                  style: const TextStyle(color: Colors.white38),
                ),
              ),
              data: (users) => users.isEmpty
                  ? const Center(
                      child: Text(
                        'No blocked users',
                        style: TextStyle(color: Colors.white38),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _BlockedUserRow(
                          user: user,
                          onUnblock: () async {
                            await ProfileRepository.instance.unblockUser(
                              user['id']!,
                            );
                            ref.invalidate(blockedUsersProvider);
                          },
                        );
                      },
                    ),
            ),
          ),

          // ── Search bar ───────────────────────────────────────────────────
          _SearchBar(),
        ],
      ),
    );
  }
}

class _BlockedUserRow extends StatelessWidget {
  final Map<String, String> user;
  final VoidCallback onUnblock;

  const _BlockedUserRow({required this.user, required this.onUnblock});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white12,
            backgroundImage: user['avatar']!.isNotEmpty
                ? NetworkImage(user['avatar']!)
                : null,
            child: user['avatar']!.isEmpty
                ? Text(
                    user['name']![0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Blocked User',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onUnblock,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFAC5AF7), Color(0xFF6366F1)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Text(
                'Unblock',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFC0C0C0).withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.black54, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: 'Search user to block',
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Search for a user to add them to your block list.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
