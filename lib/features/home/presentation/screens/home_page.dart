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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const CategoryBar(),
          const SizedBox(height: 24),

          // Wrap this in a SizedBox to control the height of the posts
          const SizedBox(
            height: 250, // Adjust this number to make posts smaller/larger
            child: HorizontalPostFeed(),
          ),

          const SizedBox(height: 24),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0)
          ),

    
          const SizedBox(
            height: 300, // Give the recommended list a defined area
            child: RecommendedConnectionsList(),
          ),
        ],
      ),
    );
  }
}