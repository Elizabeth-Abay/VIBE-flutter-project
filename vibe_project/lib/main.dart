import 'package:flutter/material.dart';
import './features/posts/presentation/screens/create_post.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreatePostPage(),
    );
  }
  
}