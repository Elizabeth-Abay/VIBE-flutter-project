import 'package:flutter/material.dart';
import '../providers/post_provider.dart';
import '../providers/person_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/recommended_person_card.dart';
// import '../../../feed/core/constants/app_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     context.read<PostProvider>().fetchPosts();
  //     context.read<PersonProvider>().fetchRecommendedPeople();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Text(
              AppConstants.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[700],
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PostProvider>().refresh();
          context.read<PersonProvider>().refresh();
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categories
              _buildCategories(),
              const SizedBox(height: 20),
              // Posts section
              _buildPostsSection(),
              const SizedBox(height: 20),
              // Recommended people section
              _buildRecommendedPeopleSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppConstants.categories.length,
        itemBuilder: (context, index) {
          final category = AppConstants.categories[index];
          return Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: index == 0 ? Colors.blue : Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                category,
                style: TextStyle(
                  color: index == 0 ? Colors.white : Colors.grey[300],
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPostsSection() {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.posts.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }

        if (provider.error != null && provider.posts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[400], size: 48),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: provider.refresh,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Posts',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...provider.posts.map((post) => PostCard(post: post)),
            if (provider.isLoading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator(color: Colors.white)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRecommendedPeopleSection() {
    return Consumer<PersonProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.people.isEmpty) {
          return const SizedBox.shrink();
        }

        if (provider.error != null && provider.people.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recommended Connections',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...provider.people.map((person) => PersonCard(
              person: person,
              onConnect: () => provider.followPerson(person.id),
            )),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}
