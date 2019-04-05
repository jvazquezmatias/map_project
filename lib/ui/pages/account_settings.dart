import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/flutter_cupertino_settings.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/model/user.dart';

class AccountSettings extends StatefulWidget {
  static String tag = 'account-settings';
  @override
  AccountTabSettings createState() => new AccountTabSettings();
}
  class AccountTabSettings extends State<AccountSettings> {
  double _slider = 0.5;
  bool _switch = false;
  int _index = 0;
  List<String> locations = ['Español', 'Catalán', 'Inglés'];
  String _selectedLocation = 'Español';


  @override
  Widget build(BuildContext context) {
    User user = mysql.getUser();
    return Scaffold(
      body: CupertinoSettings(
        items: <Widget>[
          CSHeader(user.getName()),
          CSSelection(
            ['Carretera', 'Satélites', 'Terreno'],
            (int value) {
              setState(() {
                _index = value;
              });
            },
            currentSelection: _index,
          ),
          CSHeader('Formato mapa:'),
          CSSelection(
            ['Kilómetros', 'Millas'],
            (int value) {
              setState(() {
                _index = value;
              });
            },
            currentSelection: _index,
          ),
          CSHeader("Idioma"),
          new DropdownButton<String>(
             style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : CS_TEXT_COLOR,
                fontSize: CS_HEADER_FONT_SIZE,
              ),
              items: locations.map((String val) {
                return new DropdownMenuItem<String>(
                  value: val,
                  child: new Text(val),
                  
                );
              }).toList(),
              hint: Text("Elige Idioma"),
              onChanged: (newVal) {
                _selectedLocation = newVal;
                this.setState(() {});
              }),
          CSHeader(""),
          CSButton(CSButtonType.DEFAULT_CENTER, "Cambiar Contraseña", () {}),
          CSButton(CSButtonType.DESTRUCTIVE, "Eliminar Cuenta", () {}),
        ],
      ),
    );
  }
}
