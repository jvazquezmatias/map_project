import 'package:flutter/material.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/ui/pages/home_page.dart';
import 'package:project/ui/pages/account.dart';

class Register extends StatelessWidget {
  static String tag = 'register-page';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final logo = Hero(
      tag: 'hero',
      child: Container(
        height: size.height * 0.25,
        child: new FlatButton(
          onPressed: null,
          child: new ConstrainedBox(
            constraints: new BoxConstraints.expand(),
            child: Image(image: new AssetImage('assets/img/logoMap.png')),
          ),
        ),
      ),
    );

    final nameValue = TextEditingController();
    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'pablo@gmail.com',
      controller: nameValue,
      decoration: InputDecoration(
        hintText: 'Nombre',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final surnameValue = TextEditingController();
    final surname = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'pablo@gmail.com',
      controller: surnameValue,
      decoration: InputDecoration(
        hintText: 'Primer Apellido',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final surname2Value = TextEditingController();
    final surname2 = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'pablo@gmail.com',
      controller: surname2Value,
      decoration: InputDecoration(
        hintText: 'Segundo Apellido',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final usernameValue = TextEditingController();
    final username = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'pablo@gmail.com',
      controller: usernameValue,
      decoration: InputDecoration(
        hintText: 'Usuario',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final emailValue = TextEditingController();
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'pablo@gmail.com',
      controller: emailValue,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passwordValue = TextEditingController();
    final password = TextFormField(
      autofocus: false,
      //initialValue: 'some password',
      obscureText: true,
      controller: passwordValue,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          mysql
              .query("INSERT INTO USERS VALUES('" +
                  nameValue.text +
                  "','" +
                  surnameValue.text +
                  "','" +
                  surname2Value.text +
                  "','" +
                  usernameValue.text +
                  "','" +
                  emailValue.text +
                  "','" +
                  passwordValue.text +
                  "')")
              .whenComplete(() {
              Navigator.of(context).pop();
          });
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Registrarse', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 30.0),
            name,
            SizedBox(height: 8.0),
            surname,
            SizedBox(height: 8.0),
            surname2,
            SizedBox(height: 8.0),
            username,
            SizedBox(height: 8.0),
            email,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 25.0),
            loginButton
          ],
        ),
      ),
    );
  }
}
