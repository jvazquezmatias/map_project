import 'package:flutter/material.dart';
import 'package:project/ui/pages/home_page.dart';
import 'package:project/ui/pages/home.dart' as home;

class HomeLoginPage extends StatelessWidget {
  static String tag = 'home-page';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final imgUser = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          //backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(
              'https://pixel.nymag.com/imgs/daily/vulture/2017/06/14/14-tom-cruise.w700.h700.jpg'),
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Bienvenido!',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final successful = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Has iniciado sesión correctamente',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      ),
    );

    final backButton = Container(
        margin: EdgeInsets.only(top: size.height * 0.1),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircleAvatar(
            radius: 72.0,
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/img/backImg.png'),
            child: new FlatButton(onPressed: () {
              home.HomeTab
                  .cuentaCorrecta(); // Esto se tiene que ejecutar al pulsar login correcto
              //Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
              Navigator.of(context).pop();
            }),
          ),
        ));

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.green,
          Colors.lightGreenAccent,
        ]),
      ),
      child: Column(
        children: <Widget>[imgUser, welcome, successful, backButton],
      ),
    );

    return Scaffold(
      body: body,
    );
  }
}
