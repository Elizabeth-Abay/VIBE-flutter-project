import 'package:flutter/material.dart';
import '../widgets/category_bar.dart';
import '../widgets/posts_bar.dart';
import '../widgets/recommended_ppl_list.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Horizontal Categories
            const CategoryBar(),

            // Padding between Categories and Posts
            const SizedBox(height: 20),

            // 2. Horizontal Post Feed
            const HorizontalPostFeed(),

            // Padding between Posts and People
            const SizedBox(height: 24),

            // 3. Vertical People List (The "Expanded" is the fix!)
            const Expanded(child: RecommendedConnectionsList()),
          ],
        ),
      ),
    );
  }
}
