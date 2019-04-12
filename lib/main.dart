import 'package:flutter/material.dart';
import 'ui/pages/home_page.dart';
import 'package:project/login/home_page.dart';
import 'package:project/login/register.dart';
import 'package:project/ui/pages/account.dart';
import 'package:project/ui/pages/home_page.dart';
import 'package:project/ui/pages/map_page.dart';
import 'package:project/ui/pages/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
    final routes = <String, WidgetBuilder>{
    MyHome.tag: (context) => MyHome(),
    LoginPage.tag: (context) => LoginPage(),
    HomeLoginPage.tag: (context) => HomeLoginPage(),
    RegisterPage.tag: (context) => RegisterPage(),
    MapPage.tag: (context) => MapPage(),
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
      home: SplashScreen(),

    );
  }
}