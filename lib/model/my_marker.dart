class MyMarker {
  String id;
  double latitud;
  double longitud;
  String icono;
  String titulo;
  String descripcion;
  int estrellas;
  String imagen = "";

  MyMarker(
      {this.id,
      this.latitud,
      this.longitud,
      this.icono,
      this.titulo,
      this.descripcion,
      this.estrellas});

  String getId() {
    return id;
  }

  double getLatitud() {
    return latitud;
  }

  double getLongitud() {
    return longitud;
  }

  String getIcono() {
    return icono;
  }

  String getTitulo() {
    return titulo;
  }

  String getDescripcion() {
    return descripcion;
  }

  int getEstrellas() {
    return estrellas;
  }

  String getImagen() {
    return imagen;
  }
}
