import 'package:flutter/material.dart';
import 'package:project/login/home_page.dart';
import 'package:project/login/register.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/model/user.dart';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';

class LoginPage extends StatefulWidget {
  static String _username = "";
  static String tag = 'login-page';
  @override
  AccountTab createState() => new AccountTab();
}

class AccountTab extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameValue = TextEditingController();
  final passwordValue = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final logo = Hero(
      tag: 'hero',
      child: Container(
        height: size.height * 0.20,
        child: new FlatButton(
          onPressed: null,
          child: new ConstrainedBox(
            constraints: new BoxConstraints.expand(),
            child: Image(image: new AssetImage('assets/img/logoMap.png')),
          ),
        ),
      ),
    );

    final form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: false,
            // initialValue: 'pablo@gmail.com',
            controller: usernameValue,
            decoration: InputDecoration(
              hintText: 'Usuario',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'No puedes dejar el campo vacío';
              }
            },
          ),
          SizedBox(height: 8.0),
          TextFormField(
            autofocus: false,
            //initialValue: 'some password',
            obscureText: true,
            controller: passwordValue,
            decoration: InputDecoration(
              hintText: 'Contraseña',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'No puedes dejar el campo vacío';
              }
            },
          ),
        ],
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            mysql
                .query("SELECT * FROM USERS WHERE USERNAME = '" +
                    usernameValue.text +
                    "' and password='" +
                    passwordValue.text +
                    "'")
                .whenComplete(
              () {
                mysql.getConnection()
                    ? Navigator.of(context).pushNamed(HomeLoginPage.tag)
                    : SweetAlert.dialog(
                        type: AlertType.ERROR,
                        cancelable: true,
                        title: "Usuario o contraseña incorrecto",
                        showCancel: false,
                        closeOnConfirm: true,
                        confirmButtonText: "Aceptar",
                      );
              },
            );
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
      ),
    );

    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterPage()));
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Registrar', style: TextStyle(color: Colors.white)),
      ),
    );

    final forgotLabel = FlatButton(
      child: Text(
        '¿Has olvidado la contraseña?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: size.height * 0.05),
            form,
            SizedBox(height: 24.0),
            loginButton,
            registerButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
