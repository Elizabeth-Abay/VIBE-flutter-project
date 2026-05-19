import 'package:flutter/material.dart';
import '../widgets/category_bar.dart';
import '../widgets/posts_bar.dart';
import '../widgets/recommended_ppl_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          CategoryBar(),
          SizedBox(height: 24),

          // Wrap this in a SizedBox to control the height of the posts
          SizedBox(
            height: 340, // Adjust this number to make posts smaller/larger
            child: HorizontalPostFeed(),
          ),

          SizedBox(height: 24),

          Padding(padding: EdgeInsets.symmetric(horizontal: 16.0)),

          SizedBox(
            height: 300, // Give the recommended list a defined area
            child: RecommendedConnectionsList(),
          ),
        ],
      ),
    );
  }
}
