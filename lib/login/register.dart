import 'package:flutter/material.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/ui/pages/home_page.dart';
import 'package:project/ui/pages/account.dart';
import 'package:sweetalert/sweetalert.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  Register createState() => new Register();
}

class Register extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameValue = TextEditingController();
  final surnameValue = TextEditingController();
  final surname2Value = TextEditingController();
  final usernameValue = TextEditingController();
  final emailValue = TextEditingController();
  final passwordValue = TextEditingController();
  bool comprovarMail = false;
  bool insertarUsuario = false;
  @override
  Widget build(BuildContext context) {
    // RegisterPage.comprovarMail = false;
    //RegisterPage.insertarUsuario = false;
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

    final form = Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: false,
            // initialValue: 'pablo@gmail.com',
            controller: nameValue,

            decoration: InputDecoration(
              hintText: 'Nombre',
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
          SizedBox(height: 15.0),
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: false,
            // initialValue: 'pablo@gmail.com',
            controller: surnameValue,
            decoration: InputDecoration(
              hintText: 'Primer apellido',
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
          SizedBox(height: 15.0),
          TextFormField(
            keyboardType: TextInputType.text,
            autofocus: false,
            // initialValue: 'pablo@gmail.com',
            controller: surname2Value,
            decoration: InputDecoration(
              hintText: 'Segundo apellido',
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
          SizedBox(height: 15.0),
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
          SizedBox(height: 15.0),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            // initialValue: 'pablo@gmail.com',
            controller: emailValue,
            decoration: InputDecoration(
              hintText: 'Email',
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
          SizedBox(height: 15.0),
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
    final registerButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            mysql
                .query("SELECT * FROM USERS WHERE USERNAME = '" +
                    usernameValue.text +
                    "'")
                .whenComplete(() {
              if (mysql.name != "") {
                SweetAlert.show(context,
                    title: "Error",
                    subtitle: "El nombre de usuario ya existe!",
                    style: SweetAlertStyle.error);
              } else {
                mysql
                    .query("SELECT * FROM USERS WHERE EMAIL = '" +
                        emailValue.text +
                        "'")
                    .whenComplete(() {
                  if (mysql.name != "") {
                    SweetAlert.show(context,
                        title: "Error",
                        subtitle: "Este email ya existe!",
                        style: SweetAlertStyle.error);
                  } else {
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
                  }
                });
              }
            });
          }
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
          children: <Widget>[logo, form, registerButton],
        ),
      ),
    );
  }
}
