import 'package:flutter/material.dart';
import 'package:project/ui/pages/map_page.dart';

class HomeTab extends StatelessWidget {
  static String tag = 'my-home';
  static bool disabled = true;

  static void cuentaCorrecta() {
    disabled = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Container(
            height: size.height*0.15,
            child: new FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPage.tag);
              },
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/mapa.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height*0.03),
            height: size.height*0.15,
            child: new FlatButton(
              onPressed: null,
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/alrededor.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height*0.03),
            height: size.height*0.15,
            child: new FlatButton(
              onPressed: null,
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/mapa.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height*0.03),
            height: size.height*0.15,
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
