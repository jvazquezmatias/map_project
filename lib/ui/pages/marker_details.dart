import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';
import 'package:project/ui/pages/favorite_page.dart';

class PageMarkerDetails extends StatefulWidget {
  String id;
  double latitud;
  double longitud;
  List<String> favorites;
  String icono;
  String titulo;
  String descripcion;
  int estrellas;
  String imagen;
  IconData myIcon;
  bool fav;
  PageMarkerDetails(
      {this.id,
      this.latitud,
      this.longitud,
      this.icono,
      this.titulo,
      this.descripcion,
      this.estrellas,
      this.imagen,
      this.myIcon,
      this.favorites,
      this.fav});
  @override
  MarkerDetails createState() => MarkerDetails(
      id: id,
      latitud: latitud,
      longitud: longitud,
      icono: icono,
      titulo: titulo,
      descripcion: descripcion,
      estrellas: estrellas,
      imagen: imagen,
      myIcon: myIcon,
      fav:fav,
      favorites: favorites);
}

class MarkerDetails extends State<PageMarkerDetails> {
  IconData myIcon;
  List<String> favorites;
  static bool iconoEstrellaVacio;
  String id;
  double latitud;
  double longitud;
  String icono;
  String titulo;
  String descripcion;
  int estrellas;
  String imagen;
  bool fav;
  var rating = 0.0;
  MarkerDetails(
      {crearIcono(),
      this.id,
      this.latitud,
      this.longitud,
      this.icono,
      this.titulo,
      this.descripcion,
      this.estrellas,
      this.imagen,
      this.myIcon,
      this.favorites,
      this.fav});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    return new WillPopScope(
      onWillPop: _onWillPop,
          child: new Scaffold(
            appBar: AppBar(
              elevation: 5.0,
              titleSpacing: 0,
              title: Text(titulo),
              backgroundColor: Colors.green,
              actions: <Widget>[
                IconButton(
                  icon: Icon(myIcon),
                  onPressed: () {
                    if (mysql.getConnection()) {
                      setState(
                        () {
                          if (myIcon == Icons.star_border) {
                            myIcon = Icons.star;
                            mysql
                                .insertMarkerToFavorites(
                                    id, mysql.getUser().getUsername())
                                .whenComplete(() {});
                          } else if (myIcon == Icons.star) {
                            myIcon = Icons.star_border;
                            mysql
                                .removeMarkerToFavorites(
                                    id, mysql.getUser().getUsername())
                                .whenComplete(() {
                              //favorites.remove(id);
                              print(favorites);
                            });
                          }
                        },
                      );
                    } else {
                      SweetAlert.dialog(
                        type: AlertType.ERROR,
                        cancelable: true,
                        title: "Inicia sesión para añadir un nuevo a tus favoritos",
                        showCancel: false,
                        closeOnConfirm: true,
                        confirmButtonText: "Aceptar",
                      );
                    }
                  },
                ),
              ],
            ),
            body: ListView(
              children: <Widget>[
                CarouselSlider(
                  scrollDirection: Axis.horizontal,
                  aspectRatio: 2.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.9,
                  height: 160.0,
                  items: ['mapa', 'favoritos', 'busqueda'].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.only(
                              top: 25.0, left: 9.0, bottom: 9.0, right: 9.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            child: Image(
                              image: new AssetImage('assets/img/' + i + '.png'),
                              fit: BoxFit.cover,
                              width: 500.0,
                              height: 300.0,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              latitud.toString() + ", " + longitud.toString(),
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*3*/
                      Icon(
                        Icons.star,
                        color: Colors.red[500],
                      ),
                      Text(estrellas.toString()),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.call, color: color),
                            onPressed: () {},
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 0),
                            child: Text(
                              "CALL",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.near_me, color: color),
                            onPressed: () {},
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              "ROUTE",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.share, color: color),
                            onPressed: () {},
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              "SHARE",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    descripcion,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ));
        }
      
        Future<bool> _onWillPop() {
          if(fav) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritePage()));
          } else {
            Navigator.pop(context, true);
          }

  }
}
