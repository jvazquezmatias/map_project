import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class PageMarkerDetails extends StatefulWidget {
  String id;
  double latitud;
  double longitud;
  String icono;
  String titulo;
  String descripcion;
  int estrellas;
  String imagen;
  PageMarkerDetails(
      {this.id,
      this.latitud,
      this.longitud,
      this.icono,
      this.titulo,
      this.descripcion,
      this.estrellas,
      this.imagen});
  @override
  MarkerDetails createState() => MarkerDetails(
      id: id,
      latitud: latitud,
      longitud: longitud,
      icono: icono,
      titulo: titulo,
      descripcion: descripcion,
      estrellas: estrellas,
      imagen: imagen);
}

class MarkerDetails extends State<PageMarkerDetails> {
  IconData myIcon = Icons.star_border;
  String id;
  double latitud;
  double longitud;
  String icono;
  String titulo;
  String descripcion;
  int estrellas;
  String imagen;
  var rating = 0.0;
  MarkerDetails(
      {this.id,
      this.latitud,
      this.longitud,
      this.icono,
      this.titulo,
      this.descripcion,
      this.estrellas,
      this.imagen});
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          elevation: 5.0,
          titleSpacing: 0,
          title: Text(titulo),
          backgroundColor: Colors.green,
          actions: <Widget>[
            IconButton(
              icon: Icon(myIcon),
              onPressed: () {
                setState(
                  () {
                    if (myIcon == Icons.star_border) {
                      myIcon = Icons.star;
                    } else if (myIcon == Icons.star) {
                      myIcon = Icons.star_border;
                    }
                  },
                );
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
              alignment: Alignment(0.1, 0.1),
              child: SmoothStarRating(
                allowHalfRating: false,
                onRatingChanged: (v) {
                  rating = v;
                  setState(() {});
                },
                starCount: 5,
                rating: rating,
                size: 40.0,
                color: Colors.yellow,
                borderColor: Colors.yellow,
              ),
            ),
            
          ],
        ));
  }
}
