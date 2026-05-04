import 'package:flutter/material.dart';
import '../widgets/category_bar.dart';
import '../widgets/posts_bar.dart';


class HomePage extends StatefulWidget{
  HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // the middle part
      body: Column(
        children: [
          CategoryBar(),
          HorizontalPostFeed()

        ],
      )


    );
  }
}