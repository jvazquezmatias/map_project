import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';
import 'package:project/login/home_page.dart';
import 'package:project/login/register.dart';
import 'package:project/ui/pages/account.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
    final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomeLoginPage.tag: (context) => HomeLoginPage(),
    Register.tag: (context) => Register(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project: Map',
      routes: routes,
      theme: new ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.greenAccent 
          ),
      home: MyHome(),

    );
  }
}