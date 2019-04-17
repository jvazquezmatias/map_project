import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/ui/pages/home.dart' as home;
import 'package:project/ui/pages/home_page.dart';
import 'package:sweetalert/sweetalert.dart';

class AccountSettings extends StatefulWidget {
  static String tag = 'account-settings';
  @override
  AccountTabSettings createState() => new AccountTabSettings();
}

class AccountTabSettings extends State<AccountSettings> {
  String newPassword = '';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.green.withOpacity(0.6)),
            clipper: getClipper(),
          ),
          Positioned(
            width: 390,
            top: MediaQuery.of(context).size.height / 7,
            child: Column(
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 7.0, color: Colors.black)
                      ]),
                ),
                SizedBox(height: 40.0),
                Text(
                  mysql.getUser().getName() +
                      " " +
                      mysql.getUser().getSurname(),
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 15.0),
                Text(
                  mysql.getUser().getEmail(),
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 30.0,
                  width: 140.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.greenAccent,
                    color: Colors.green,
                    elevation: 7.0,
                    child: GestureDetector(
                      child: Center(
                        child: Text(
                          'Cambiar contraseña',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      onTap: () {
                        return showDialog<String>(
                          context: context,
                          barrierDismissible:
                              false, // dialog is dismissible with a tap on the barrier
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Cambiar contraseña'),
                              content: new Row(
                                children: <Widget>[
                                  new Expanded(
                                    child: new TextField(
                                      autofocus: true,
                                      decoration: new InputDecoration(
                                          hintText: 'Nueva contraseña'),
                                      onChanged: (value) {
                                        newPassword = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Aceptar'),
                                  onPressed: () {
                                    mysql
                                        .queryChangePassword(
                                            "UPDATE USERS SET PASSWORD='" +
                                                newPassword +
                                                "' WHERE USERNAME='" +
                                                mysql.getUser().getUsername() +
                                                "' AND EMAIL ='" +
                                                mysql.getUser().getEmail() +
                                                "'")
                                        .whenComplete(() {
                                      Navigator.of(context).pop();
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 30.0,
                  width: 115.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.redAccent,
                    color: Colors.green,
                    elevation: 7.0,
                    child: GestureDetector(
                      child: Center(
                        child: Text(
                          'Cerrar sesión',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      onTap: () {
                        return showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('¿Seguro que quieres cerrar sesión?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Si'),
                                  onPressed: () {
                                    mysql.connection = false;
                                    home.HomeTab.disabled = true;
                                    mysql.user = null;
                                    Navigator.of(context).pushNamed(MyHome.tag);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: 30.0,
                  width: 115.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.redAccent,
                    color: Colors.red,
                    elevation: 7.0,
                    child: GestureDetector(
                      child: Center(
                        child: Text(
                          'Eliminar cuenta',
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'Montserrat'),
                        ),
                      ),
                      onTap: () {
                        SweetAlert.show(context,
                            title: "Quieres eliminar la cuenta?",
                            subtitle: "Se borraran todos tus datos",
                            style: SweetAlertStyle.confirm,
                            showCancelButton: true, onPress: (bool isConfirm) {
                          if (isConfirm) {
                            mysql
                                .query("DELETE FROM USERS WHERE USERNAME = '" +
                                    mysql.getUser().getUsername() +
                                    "' AND EMAIL = '" +
                                    mysql.getUser().getEmail() +
                                    "'")
                                .whenComplete(() {
                              mysql.connection = false;
                              home.HomeTab.disabled = true;
                              mysql.user = null;
                              Navigator.of(context).pushNamed(MyHome.tag);
                            });
                          }
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.6);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
