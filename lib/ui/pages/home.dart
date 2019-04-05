import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  static String tag = 'my-home';
  static bool disabled = true;

  static void cuentaCorrecta() {
    disabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            child: new FlatButton(
              onPressed: null,
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/mapa.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 100,
            width: 100,
            child: new FlatButton(
              onPressed: null,
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/mapa.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 100,
            width: 100,
            child: new FlatButton(
              onPressed: null,
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/mapa.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            height: 110,
            width: 100,
            child: new FlatButton(
              onPressed: null,
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: disabled
                    ? Image(image: new AssetImage('assets/img/mapa.png'))
                    : Image(image: new AssetImage('assets/img/backImg.png')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
