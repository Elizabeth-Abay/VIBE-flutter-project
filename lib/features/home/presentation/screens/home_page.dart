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
    return Column(
      // No Scaffold here! MainNavigation provides it.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16), // Padding below the AppBar

        const CategoryBar(),

        const SizedBox(height: 24),

        const HorizontalPostFeed(),

        const SizedBox(height: 24),

        // This Expanded will now work perfectly because
        // MainNavigation provides the bounded height.
        const Expanded(child: RecommendedConnectionsList()),
      ],
    );
  }
}
