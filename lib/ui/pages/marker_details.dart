import 'package:flutter/material.dart';

class MarkerDetails extends StatelessWidget {
  String id;
  double latitud;
  double longitud;
  String icono;
  String titulo;
  String descripcion;
  int estrellas;
  String imagen;

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
    return Scaffold(
      body: Text(
        id + titulo + estrellas.toString()
      ),
    );
  }
}
