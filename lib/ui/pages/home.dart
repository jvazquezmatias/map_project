import 'package:flutter/material.dart';
import 'package:project/ui/pages/map_page.dart';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';
import 'package:project/ui/pages/search_page.dart';
import 'package:project/ui/pages/favorite_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeTab extends StatelessWidget {
  static String tag = 'my-home';
  double latitud;
  double longitud;
  static bool disabled = true;
  int permisoYes;
  static void cuentaCorrecta() {
    disabled = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: Table(
        children: [
          TableRow(children: [
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      MapUiPage.numLatitud = 39.1814828;
                      MapUiPage.numLongitud = -3.7411756;
                      MapUiPage.numZoom = 5;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(),
                        ),
                      );
                    },
                    padding: EdgeInsets.only(
                        bottom: 25.0, right: 25.0, left: 25.0, top: 45.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Image(
                          height: size.height * 0.20,
                          image: new AssetImage(
                              'assets/img/IconoMapaPrincipal.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Mapa",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      checkingPermission().whenComplete(() {
                        if (permisoYes == 2) {
                          locateUser().whenComplete(() {
                            MapUiPage.numLatitud = latitud;
                            MapUiPage.numLongitud = longitud;
                            MapUiPage.numZoom = 14;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapPage(),
                              ),
                            );
                          });
                        } else {
                          SweetAlert.dialog(
                            type: AlertType.WARNING,
                            cancelable: true,
                            title:
                                "No tienes permisos!, ¿Quieres dar permisos de localización?",
                            content: " ",
                            showCancel: true,
                            cancelButtonText: "No",
                            confirmButtonText: "Si",
                            closeOnConfirm: false,
                            closeOnCancel: true,
                          ).then((value) {
                            if (value) {
                              requestPermission().whenComplete(() {
                                Navigator.pop(context);
                              });
                            }
                          });
                        }
                      });
                    },
                    padding: EdgeInsets.only(
                        bottom: 25.0, right: 25.0, left: 25.0, top: 45.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Image(
                          height: size.height * 0.20,
                          image: new AssetImage(
                              'assets/img/IconoAlrededorPrincipal.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Alrededor",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]),
          TableRow(children: [
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      if (disabled) {
                        SweetAlert.dialog(
                          type: AlertType.ERROR,
                          cancelable: true,
                          title: "Inicia sesión para ver tus favoritos",
                          showCancel: false,
                          closeOnConfirm: true,
                          confirmButtonText: "Aceptar",
                        );
                      } else {
                        Navigator.of(context).pushNamed(FavoritePage.tag);
                      }
                    },
                    padding: EdgeInsets.only(
                        bottom: 25.0, right: 25.0, left: 25.0, top: 70.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Image(
                          height: size.height * 0.20,
                          image: new AssetImage(
                              'assets/img/IconoFavoritosPrincipal.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Favoritos",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TableCell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SearchPage.tag);
                    },
                    padding: EdgeInsets.only(
                        bottom: 25.0, right: 25.0, left: 25.0, top: 70.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Image(
                          height: size.height * 0.20,
                          image: new AssetImage(
                              'assets/img/IconoBuscarPrincipal.png'),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0),
                          child: Text(
                            "Buscar",
                            style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ])
        ],
      ),
    );
  }

  Future<Position> locateUser() async {
    Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(Geolocator().checkGeolocationPermissionStatus());

    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) {
      if (location != null) {
        print("Location: ${location.latitude},${location.longitude}");
        latitud = location.latitude;
        longitud = location.longitude;
      }
      return location;
    });
  }

  Future requestPermission() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.location]);
  }

  Future checkingPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);
    permisoYes = permission.value;
  }
}

/*
return new Scaffold(
      body: ListView(
        
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Container(
            height: size.height * 0.15,
            child: new FlatButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapPage(
                              latitud: 39.1814828,
                              longitud: -3.7411756,
                              zoom: 5,
                            )));
              },
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/mapa.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.03),
            height: size.height * 0.15,
            child: new FlatButton(
              onPressed: () {
                checkingPermission().whenComplete(() {
                  if (permisoYes == 2) {
                    locateUser().whenComplete(() {
                      print(latitud);
                      print(longitud);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapPage(
                                    latitud: latitud,
                                    longitud: longitud,
                                    zoom: 14,
                                  )));
                    });
                  } else {
                    SweetAlert.dialog(
                      type: AlertType.WARNING,
                      cancelable: true,
                      title:
                          "No tienes permisos!, ¿Quieres dar permisos de localización?",
                      content: " ",
                      showCancel: true,
                      cancelButtonText: "No",
                      confirmButtonText: "Si",
                      closeOnConfirm: false,
                      closeOnCancel: true,
                    ).then((value) {
                      if (value) {
                        requestPermission().whenComplete(() {
                          Navigator.pop(context);
                        });
                      }
                    });
                  }
                });
              },
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/alrededor.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.03),
            height: size.height * 0.15,
            child: new FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SearchPage.tag);
              },
              child: new ConstrainedBox(
                constraints: new BoxConstraints.expand(),
                child: Image(image: new AssetImage('assets/img/busqueda.png')),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: size.height * 0.03),
            height: size.height * 0.15,
            child: disabled
                ? FlatButton(
                    onPressed: () {
                      SweetAlert.dialog(
                        type: AlertType.ERROR,
                        cancelable: true,
                        title: "Inicia sesión para ver tus favoritos",
                        showCancel: false,
                        closeOnConfirm: true,
                        confirmButtonText: "Aceptar",
                      );
                    },
                    child: new ConstrainedBox(
                      constraints: new BoxConstraints.expand(),
                      child: Image(
                        image:
                            new AssetImage('assets/img/favoritosDisabled.png'),
                      ),
                    ),
                  )
                : FlatButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(FavoritePage.tag),
                    child: new ConstrainedBox(
                      constraints: new BoxConstraints.expand(),
                      child: Image(
                        image: new AssetImage('assets/img/favoritos.png'),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
*/
