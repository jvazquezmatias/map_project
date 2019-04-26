class MarkerInfo {
  String id;
  String titulo;
  String descripcion;
  int estrellas;

  MarkerInfo(
      {this.id,
      this.titulo,
      this.descripcion,
      this.estrellas});

  String getId() {
    return id;
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
}
