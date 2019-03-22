import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project: Map',
      theme: new ThemeData(
          primaryColor: Colors.indigo[50], accentColor: Colors.greenAccent),
      home: HomePage(),
    );
  }
}