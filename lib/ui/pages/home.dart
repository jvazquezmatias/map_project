import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool disabled = true;
    return new Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: <Widget>[
          Card(
            
              child: SizedBox(
                  width: 90,
                  height: 90,
                  child: FlatButton(
                    
                    color: Colors.red,
                    disabledColor: Colors.blue,
                  ))),
          Card(
              margin: const EdgeInsets.only(top: 30),
              child: SizedBox(
                  width: 90,
                  height: 90,
                  child: FlatButton(
                    color: Colors.red,
                    disabledColor: Colors.blue,
                  ))),
          Card(
              margin: const EdgeInsets.only(top: 30),
              child: SizedBox(
                  width: 90,
                  height: 90,
                  child: FlatButton(
                    child: Container(
                      child: ConstrainedBox(
                        constraints: BoxConstraints.expand(),
                        child: Ink.image(image: AssetImage('assetName'),
                        fit: BoxFit.fill,
                        //child: InkWell(
                         // onTap: null,
                        //),
                        ),
                    ),)
                    color: Colors.red,
                    disabledColor: Colors.blue,
                  ))),
          Card(
              margin: const EdgeInsets.only(top: 30),
              child: SizedBox(
                  width: 90,
                  height: 90,
                  child: FlatButton(
                    onPressed: disabled ? null : null,
                    color: Colors.red,
                    disabledColor: Colors.blue,
                  ))),
        ],
      ),
    );
  }
}
