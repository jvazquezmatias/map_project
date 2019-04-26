class MyMarker {
  String id;
  double latitud;
  double longitud;
  String icono;

  MyMarker(
      {this.id,
      this.latitud,
      this.longitud,
      this.icono});

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
}
