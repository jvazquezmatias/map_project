import 'package:flutter/material.dart';
import 'package:project/ui/pages/account.dart';
import 'package:project/ui/pages/settings.dart';
import 'package:project/ui/pages/home.dart' as home;
import 'package:project/ui/pages/account_settings.dart';

class MyHome extends StatefulWidget  {
  static String tag = 'home-principal';
  @override
  HomePage createState() => new HomePage();
}

class HomePage extends State<MyHome> with SingleTickerProviderStateMixin  {
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

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      elevation: 5.0,
      leading: Icon(Icons.map),
      title: Text('Parking Map'),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () {
            return showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Share Where Your Park'),
                  content: const Text(
                      'Version: 1.0 \n\nAutores:\n  Javier Vázquez\n  Pablo Sánchez'),
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

    return Scaffold(
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
    );
  }
}
