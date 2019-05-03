import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/ui/pages/home.dart' as home;
import 'package:project/ui/pages/home_page.dart';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';

class AccountSettings extends StatefulWidget {
  static String tag = 'account-settings';
  @override
  AccountTabSettings createState() => new AccountTabSettings();
}

class AccountTabSettings extends State<AccountSettings> {
  String newPassword = '';
  @override
  Widget build(BuildContext context) {
    Size sizeMedia = MediaQuery.of(context).size;
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.green.withOpacity(0.6)),
            clipper: getClipper(),
          ),
          Positioned(
            width: sizeMedia.width*1,
            top: sizeMedia.height * 0.04,
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
                SizedBox(height: sizeMedia.height * 0.03),
                Text(
                  mysql.getUser().getName() +
                      " " +
                      mysql.getUser().getSurname(),
                  style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: sizeMedia.height * 0.01),
                Text(
                  mysql.getUser().getEmail(),
                  style: TextStyle(
                      fontSize: 17.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 25.0),
                Container(
                  height: sizeMedia.height * 0.06,
                  width: sizeMedia.width * 0.4,
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
                                      obscureText: true,
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
                                      SweetAlert.dialog(
                                        type: AlertType.SUCCESS,
                                        cancelable: true,
                                        title:
                                            "Contraseña cambiada correctamente",
                                        showCancel: false,
                                        closeOnConfirm: true,
                                        confirmButtonText: "Aceptar",
                                      );
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
                SizedBox(height: sizeMedia.height * 0.03),
                Container(
                  height: sizeMedia.height * 0.06,
                  width: sizeMedia.width * 0.3,
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
                        SweetAlert.dialog(
                          type: AlertType.WARNING,
                          cancelable: true,
                          title: "¿Seguro que quieres cerrar sesión?",
                          content: " ",
                          showCancel: true,
                          cancelButtonText: "No",
                          confirmButtonText: "Si",
                          closeOnConfirm: true,
                          closeOnCancel: true,
                        ).then((value) {
                          if (value) {
                            mysql.connection = false;
                            home.HomeTab.disabled = true;
                            mysql.user = null;
                            Navigator.of(context).pushNamed(MyHome.tag);
                          }
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: sizeMedia.height * 0.03),
                Container(
                  height: sizeMedia.height * 0.06,
                  width: sizeMedia.width * 0.3,
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
                        SweetAlert.dialog(
                          type: AlertType.WARNING,
                          cancelable: true,
                          title: "¿Quieres eliminar la cuenta?",
                          content: "Se borraran todos tus datos",
                          showCancel: true,
                          cancelButtonText: "No",
                          confirmButtonText: "Si",
                          closeOnConfirm: false,
                          closeOnCancel: true,
                        ).then((value) {
                          if (value) {
                            mysql
                                .query("DELETE FROM USERS WHERE USERNAME = '" +
                                    mysql.getUser().getUsername() +
                                    "' AND EMAIL = '" +
                                    mysql.getUser().getEmail() +
                                    "'")
                                .whenComplete(() {
                              SweetAlert.update(
                                type: AlertType.SUCCESS,
                                cancelable: true,
                                title: "Cuenta borrada",
                                content: " ",
                                showCancel: false,
                                closeOnConfirm: true,
                                confirmButtonText: "Aceptar",
                              ).then((value) {
                                mysql.connection = false;
                                home.HomeTab.disabled = true;
                                mysql.user = null;
                                Navigator.of(context).pushNamed(MyHome.tag);
                              });
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

    path.lineTo(0.0, size.height * 0.4);
    path.lineTo(size.width + 100, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
