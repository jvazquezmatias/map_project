import 'package:flutter/material.dart';
import 'package:project/ui/pages/account.dart';
import 'package:project/ui/pages/settings.dart';
import 'package:project/ui/pages/home.dart' as home;
import 'package:project/ui/pages/account_settings.dart';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';
import 'dart:io';

class MyHome extends StatefulWidget {
  static String tag = 'home-principal';
  @override
  HomePage createState() => new HomePage();
}

class HomePage extends State<MyHome> with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(
      icon: new Icon(Icons.home),
      text: "Inicio",
    ),
    Tab(icon: new Icon(Icons.account_circle), text: "Cuenta"),
    Tab(icon: new Icon(Icons.settings), text: "Ajustes")
  ];
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = new TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> _onBackPressed() {
    SweetAlert.dialog(
      type: AlertType.WARNING,
      cancelable: true,
      title: "¿Deseas cerrar la aplicación?",
      content: " ",
      showCancel: true,
      cancelButtonText: "No",
      confirmButtonText: "Si",
      closeOnConfirm: true,
      closeOnCancel: true,
    ).then((value) {
      if (value) {
        exit(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      elevation: 5.0,
      leading: Icon(Icons.map),
      titleSpacing: 0,
      title: Text('SWYP'),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Share Where You Park'),
                  content: Row(
                    children: <Widget>[
                      const Text(
                          'Version: 1.0 \n\nAutores:\n  Javier Vázquez\n  Pablo Sánchez'),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        height: 100,
                        width: 80,
                        decoration: BoxDecoration(
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.white.withOpacity(0.8),
                                BlendMode.dstATop),
                            image:
                                new AssetImage('assets/img/logoMapBlack.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: _appBar,
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              new home.HomeTab(),
              home.HomeTab.disabled ? new LoginPage() : new AccountSettings(),
              new SettingsPage()
            ],
            controller: controller,
          ),
          bottomNavigationBar: new Material(
              child: new TabBar(
            // labelColor: Colors.black,
            tabs: tabs,
            controller: controller,
          )),
        ));
  }
}
