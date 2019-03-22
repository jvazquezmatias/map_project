import 'package:flutter/material.dart';
import 'package:project/ui/pages/account.dart';
import 'package:project/ui/pages/settings.dart';
import 'package:project/ui/pages/home.dart';

class MyHome extends StatefulWidget {
  @override
  HomePage createState() => new HomePage();
}
class HomePage extends State<MyHome> with SingleTickerProviderStateMixin {
final List<Tab> tabs =  <Tab>[
          Tab(
            icon: new Icon(Icons.home),
            text: "Inicio",
          ),
          Tab(
            icon: new Icon(Icons.account_circle),
            text:"Cuenta"
            ),
          Tab(
            icon: new Icon(Icons.settings),
            text: "Ajustes"
            )
        ];
TabController controller;
  @override
  void initState() {
    super.initState();
    controller = new TabController(length: tabs.length,vsync: this);
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

          },
        ),
      ],
    );
      

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: _appBar,
      body: TabBarView(
        children: <Widget>[new HomeTab(),new AccountTab(), new SettingsTab()],
        controller: controller,
      ),
      bottomNavigationBar: new Material(
        
        child: new TabBar(
          tabs: tabs,
        controller: controller,
      )
      ),
    );
  }
}