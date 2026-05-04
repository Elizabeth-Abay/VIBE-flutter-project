import 'package:flutter/material.dart';
import './features/home/presentation/screens/main_navigation.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainNavigation(),
    );
  }
  
}