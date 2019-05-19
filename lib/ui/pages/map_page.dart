import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:ui';
import 'package:project/ui/pages/marker_details.dart';
import 'package:project/model/my_marker.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:project/ui/pages/home.dart';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';

class MapPage extends StatefulWidget {
  static int _indexFormatMap = 0;

  static bool parkingDiaYNoche = true;
  static bool parkingSoloDia = true;
  static bool rodeadoDeNaturaleza = true;
  static bool areaDeServicios = true;
  static bool solucionDeProblemas = true;
  static bool areaAutocaravanasPublicaGratuita = true;
  static bool zonaDePicnic = true;

  static bool mostrarBotonesAbajo = false;
  static bool verBotonesAbajo = false;

  static BuildContext context;
  static List<String> filtrosActivos;
  static String tag = 'map-page';
  static MapType tipusMapa = MapType.normal;
  static Marker newMarker;
  static MarkerId newMarkerId;

  @override
  MapUiPage createState() => new MapUiPage();
}

class MapUiPage extends State<MapPage> {
  static double numLatitud;
  static double numLongitud;
  static double numZoom;
  static List<MyMarker> listMarkers = new List();
  LatLng actualPosition;
  MarkerId oldPositionMarker;
  MarkerId idMarkerUpdateMarker;
  static CameraPosition _position = CameraPosition(
    target: LatLng(numLatitud, numLongitud),
    zoom: numZoom,
  );

  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Future<bool> _onBackPressed() {
    MapPage.mostrarBotonesAbajo = false;
    Navigator.pop(context);
  }

  @override
  void initState() {
    _resetCamera(numLatitud, numLongitud, numZoom);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapPage.context = context;
    Size size = MediaQuery.of(context).size;
    actualPosition = _position.target;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          body: GoogleMap(
            mapType: MapPage.tipusMapa,
            initialCameraPosition: _position,
            onCameraMove: (position) {
              _updateCameraPosition(position);
              actualPosition = position.target;
              if (MapPage.newMarker != null) {
                _updateMarkerPosition(actualPosition);
              }
            },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              cargarMarkersConFilros();
            },
            markers: Set<Marker>.of(markers.values),
            myLocationEnabled: true,
          ),
          floatingActionButton: MapPage.mostrarBotonesAbajo
              ? Visibility(
                  visible: true,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
                    alignment: Alignment.bottomCenter,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: size.width * 0.20),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          color: Colors.green,
                          child: const Text(
                            'Siguiente',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () {
                            setState(() {
                              MarkerId myNewMarkerID = MarkerId("newMarker");
                              Marker myNewMarker;
                              if (MapPage.newMarkerId == null) {
                                myNewMarker = Marker(
                                  markerId: myNewMarkerID,
                                  position:
                                      markers[idMarkerUpdateMarker].position,
                                  infoWindow: InfoWindow(title: 'New Place'),
                                  draggable: false,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                );
                              } else {
                                myNewMarker = Marker(
                                  markerId: myNewMarkerID,
                                  position:
                                      markers[MapPage.newMarkerId].position,
                                  infoWindow: InfoWindow(title: 'New Place'),
                                  draggable: false,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                );
                              }
                              if (oldPositionMarker != null) {
                                markers.remove(oldPositionMarker);
                                oldPositionMarker = null;
                              }
                              markers.remove(MapPage.newMarkerId);
                              MapPage.mostrarBotonesAbajo = false;
                              MapPage.verBotonesAbajo = false;
                              MapPage.newMarkerId = null;
                              MapPage.newMarker = null;
                              showDialog(
                                  context: context,
                                  builder: (_) => DialogNewMarker(
                                      key: Key("nuevoLugar"),
                                      marker: myNewMarker,
                                      mapPage: this));
                              //markers[myNewMarkerID] = (myNewMarker);
                            });
                          },
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          color: Colors.red,
                          child: const Text(
                            'Cancelar',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          onPressed: () {
                            setState(() {
                              MapPage.mostrarBotonesAbajo = false;
                              MapPage.verBotonesAbajo = false;
                              if (MapPage.newMarker != null) {
                                markers.remove(MapPage.newMarkerId);
                                markers.remove(oldPositionMarker);
                                MapPage.newMarker = null;
                                MapPage.newMarkerId = null;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                        height: size.height * 0.1,
                        child: FittedBox(
                            child: FloatingActionButton(
                          heroTag: "buttonFilter",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) => DialogFilter(
                                    key: Key("filtros"),
                                    title: "filtosTitulo",
                                    pageMap: this));
                          },
                          child: Icon(Icons.filter_list),
                        ))),
                    SizedBox(height: size.height * 0.01),
                    Container(
                        height: size.height * 0.1,
                        child: FittedBox(
                            child: FloatingActionButton(
                          heroTag: "buttonAddLocation",
                          onPressed: () {
                            HomeTab.disabled
                                ? SweetAlert.dialog(
                                    type: AlertType.ERROR,
                                    cancelable: true,
                                    title:
                                        "Inicia sesión para añadir un nuevo lugar",
                                    showCancel: false,
                                    closeOnConfirm: true,
                                    confirmButtonText: "Aceptar",
                                  )
                                : _setBotonesAbajo();
                          },
                          child: Icon(Icons.location_on),
                        ))),
                    SizedBox(height: size.height * 0.38),
                    Container(
                        height: size.height * 0.08,
                        child: FittedBox(
                            child: FloatingActionButton(
                          heroTag: "buttonFormatMap",
                          onPressed: () {
                            _formatMap();
                          },
                          child: Icon(Icons.layers),
                        ))),
                    SizedBox(height: size.height * 0.01),
                    Container(
                        height: size.height * 0.08,
                        child: FittedBox(
                            child: FloatingActionButton(
                          heroTag: "buttonAdd",
                          onPressed: () {
                            _zoomIn();
                          },
                          child: Icon(Icons.add),
                        ))),
                    SizedBox(height: size.height * 0.01),
                    Container(
                        height: size.height * 0.08,
                        child: FittedBox(
                            child: FloatingActionButton(
                          heroTag: "buttonRemove",
                          onPressed: () {
                            _zoomOut();
                          },
                          child: Icon(Icons.remove),
                        ))),
                    SizedBox(height: size.height * 0.08),
                  ],
                ),
        ));
  }

  void _setBotonesAbajo() {
    setState(() {
      MapPage.mostrarBotonesAbajo = true;
      _onAddPlacePressed();
    });
  }

  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.zoomTo(_position.zoom + 1));
    });
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _controller.future;
    setState(() {
      controller.animateCamera(CameraUpdate.zoomTo(_position.zoom - 1));
    });
  }

  Future<void> _resetCamera(
      double latitud, double longitud, double zoom) async {
    final GoogleMapController controller = await _controller.future;

    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          new CameraPosition(zoom: zoom, target: LatLng(latitud, longitud))));
    });
  }

  void _formatMap() {
    MapPage._indexFormatMap++;
    if (MapPage._indexFormatMap == 0) {
      setState(() {
        MapPage.tipusMapa = MapType.normal;
      });
    }
    if (MapPage._indexFormatMap == 1) {
      setState(() {
        MapPage.tipusMapa = MapType.satellite;
      });
    }
    if (MapPage._indexFormatMap == 2) {
      setState(() {
        MapPage.tipusMapa = MapType.terrain;
      });
    }
    if (MapPage._indexFormatMap == 3) {
      setState(() {
        MapPage.tipusMapa = MapType.hybrid;
      });
      MapPage._indexFormatMap = -1;
    }
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void _onAddPlacePressed() async {
    setState(() {
      MapPage.newMarkerId = MarkerId("_pendingMark");
      MapPage.newMarker = Marker(
        markerId: MapPage.newMarkerId,
        position: actualPosition,
        infoWindow: InfoWindow(title: 'New Place'),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      markers[MapPage.newMarkerId] = (MapPage.newMarker);
    });
  }

  void _updateMarkerPosition(LatLng _position) {
    setState(() {
      if (oldPositionMarker != null) {
        markers.remove(oldPositionMarker);
        oldPositionMarker = null;
      }
      if (MapPage.newMarkerId != null) {
        markers.remove(MapPage.newMarkerId);
        MapPage.newMarkerId = null;
      }
      idMarkerUpdateMarker = MarkerId(_position.toString());
      oldPositionMarker = idMarkerUpdateMarker;
      Marker marker = Marker(
        markerId: idMarkerUpdateMarker,
        position: _position,
        infoWindow: InfoWindow(title: 'New Place'),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      markers[idMarkerUpdateMarker] = marker;
    });
  }

  void _addMarkers() {
    listMarkers.forEach(
      (element) {
        var markerIdVal = element.getId();
        final MarkerId markerId = MarkerId(markerIdVal);
        final Marker marker = Marker(
          markerId: markerId,
          icon: BitmapDescriptor.fromAsset(
              "assets/img/icons/" + element.getIcono() + ".png"),
          position: LatLng(element.getLatitud(), element.getLongitud()),
          infoWindow: InfoWindow(
              title: element.getTitulo(),
              snippet: element.getDescripcion().length > 30
                  ? element.getDescripcion().substring(0, 30) + ".."
                  : element.getDescripcion(),
              onTap: () {
                IconData myIcon;
                List<String> favorites = new List<String>();

                if (mysql.getConnection()) {
                  mysql
                      .obtenerMarkerToFavorites(mysql.getUser().getUsername())
                      .whenComplete(() {
                    favorites = mysql.getFavorites();

                    MarkerDetails.iconoEstrellaVacio = true;

                    favorites.forEach((elemento) {
                      if (elemento == element.getId()) {
                        MarkerDetails.iconoEstrellaVacio = false;
                      }
                    });

                    if (MarkerDetails.iconoEstrellaVacio) {
                      myIcon = Icons.star_border;
                    } else {
                      myIcon = Icons.star;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => new PageMarkerDetails(
                              id: element.getId(),
                              latitud: element.getLatitud(),
                              longitud: element.getLongitud(),
                              icono: element.getIcono(),
                              titulo: element.getTitulo(),
                              descripcion: element.getDescripcion(),
                              estrellas: element.getEstrellas(),
                              imagen: element.getImagen(),
                              myIcon: myIcon,
                              fav: false,
                              favorites: favorites,
                            ),
                      ),
                    );
                  });
                } else {
                  myIcon = Icons.star_border;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => new PageMarkerDetails(
                            id: element.getId(),
                            latitud: element.getLatitud(),
                            longitud: element.getLongitud(),
                            icono: element.getIcono(),
                            titulo: element.getTitulo(),
                            descripcion: element.getDescripcion(),
                            estrellas: element.getEstrellas(),
                            imagen: element.getImagen(),
                            fav: false,
                            myIcon: myIcon,
                            favorites: favorites,
                          ),
                    ),
                  );
                }
              }),
        );
        setState(
          () {
            // adding a new marker to map
            markers[markerId] = marker;
          },
        );
      },
    );
  }

  void cargarMarkersConFilros() {
    setState(() {
      MapUiPage.listMarkers.clear();
      markers.clear();
    });
    MapPage.filtrosActivos = new List();
    if (MapPage.parkingDiaYNoche)
      MapPage.filtrosActivos.add(mysql.parkingDiaNoche);
    if (MapPage.parkingSoloDia)
      MapPage.filtrosActivos.add(mysql.parkingSoloDia);
    if (MapPage.rodeadoDeNaturaleza)
      MapPage.filtrosActivos.add(mysql.rodeadoNaturaleza);
    if (MapPage.areaDeServicios)
      MapPage.filtrosActivos.add(mysql.areaDeServicio);
    if (MapPage.solucionDeProblemas)
      MapPage.filtrosActivos.add(mysql.solucionDeProblemas);
    if (MapPage.areaAutocaravanasPublicaGratuita)
      MapPage.filtrosActivos.add(mysql.areaAutocaravanasPublica);
    if (MapPage.zonaDePicnic) MapPage.filtrosActivos.add(mysql.zonaPicnic);

    if (MapPage.filtrosActivos.isNotEmpty) {
      mysql.queryDownloadMarkersAndFilter().whenComplete(() {
        _addMarkers();
      });
    }
  }
}

class DialogFilter extends StatefulWidget {
  MapUiPage pageMap;
  DialogFilter({Key key, this.title, this.pageMap}) : super(key: key);

  final String title;

  @override
  _FilterDialog createState() => new _FilterDialog(mapPage: pageMap);
}

class _FilterDialog extends State<DialogFilter> {
  String _selectedId;
  MapUiPage mapPage;
  _FilterDialog({this.mapPage});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: new Text("Filtros"),
      content: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                value: MapPage.parkingDiaYNoche,
                onChanged: (bool value) => setState(() {
                      MapPage.parkingDiaYNoche = value;
                    }),
                title: Text('Parking día y noche',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 0.0),
                  child: Image(
                    image: AssetImage("assets/img/icons/parkingDiaNoche.png"),
                    width: size.width * 0.1,
                  ),
                ),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.parkingSoloDia,
                onChanged: (bool value) => setState(() {
                      MapPage.parkingSoloDia = value;
                    }),
                title:
                    Text('Parking solo día', style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 0.0),
                  child: Image(
                    image: AssetImage("assets/img/icons/parkingDia.png"),
                    width: size.width * 0.1,
                  ),
                ),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.rodeadoDeNaturaleza,
                onChanged: (bool value) => setState(() {
                      MapPage.rodeadoDeNaturaleza = value;
                    }),
                title: Text('Rodeado de naturaleza',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 9.0, right: 0.0),
                  child: Image(
                    image: AssetImage("assets/img/icons/naturaleza.png"),
                    width: size.width * 0.09,
                  ),
                ),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.areaDeServicios,
                onChanged: (bool value) => setState(() {
                      MapPage.areaDeServicios = value;
                    }),
                title:
                    Text('Área de servicios', style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 13.0),
                  child: Image(
                    image: AssetImage("assets/img/icons/areaDeServicio.png"),
                    width: size.width * 0.1,
                  ),
                ),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.solucionDeProblemas,
                onChanged: (bool value) => setState(() {
                      MapPage.solucionDeProblemas = value;
                    }),
                title: Text('Solución de problemas',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 17.0, right: 5.0),
                  child: Image(
                    image: AssetImage("assets/img/icons/solucionProblemas.png"),
                    width: size.width * 0.06,
                  ),
                ),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.areaAutocaravanasPublicaGratuita,
                onChanged: (bool value) => setState(() {
                      MapPage.areaAutocaravanasPublicaGratuita = value;
                    }),
                title: Text('Área autocaravanas pública gratuita',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 0.0),
                  child: Image(
                    image: AssetImage(
                        "assets/img/icons/autocaravanaPublicaGratis.png"),
                    width: size.width * 0.1,
                  ),
                ),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.zonaDePicnic,
                onChanged: (bool value) => setState(() {
                      MapPage.zonaDePicnic = value;
                    }),
                title: Text('Zona de picnic', style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 0.0),
                  child: Image(
                    image: AssetImage("assets/img/icons/zonaPicnic.png"),
                    width: size.width * 0.12,
                  ),
                ),
                activeColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            mapPage.cargarMarkersConFilros();
            Navigator.pop(context);
          },
          child: Text("Aceptar"),
        ),
      ],
    );
  }
}

class DialogNewMarker extends StatefulWidget {
  MapUiPage mapPage;
  Marker marker;
  DialogNewMarker({Key key, this.marker, this.mapPage}) : super(key: key);
  @override
  DialogNewMarkerPage createState() =>
      new DialogNewMarkerPage(marker: marker, mapPage: mapPage);
}

class DialogNewMarkerPage extends State<DialogNewMarker> {
  final _formKeyIconoLugar = GlobalKey<FormState>();
  final _formKeyNombreLugar = GlobalKey<FormState>();
  final _formKeyDescripcionLugar = GlobalKey<FormState>();
  final nombreLugar = TextEditingController();
  final descripcionLugar = TextEditingController();
  String valorIcono;
  String nombreIcono;
  Marker marker;
  MapUiPage mapPage;
  DialogNewMarkerPage({this.marker, this.mapPage});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Color myColor = Colors.green;
    return new AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        width: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Form(
              key: _formKeyIconoLugar,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  hintText: 'Icono',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
                  border: InputBorder.none,
                ),
                items: [
                  DropdownMenuItem(
                    value: "1",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image: AssetImage(
                                "assets/img/icons/parkingDiaNoche.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Parking dia y noche",
                          ),
                        )
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "2",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image:
                                AssetImage("assets/img/icons/parkingDia.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Parking solo dia",
                          ),
                        )
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "3",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image:
                                AssetImage("assets/img/icons/naturaleza.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Rodeado de naturaleza",
                          ),
                        )
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "4",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image: AssetImage(
                                "assets/img/icons/areaDeServicio.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Área de servicios",
                          ),
                        )
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "5",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image: AssetImage(
                                "assets/img/icons/solucionProblemas.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Solución de problemas",
                          ),
                        )
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "6",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image: AssetImage(
                                "assets/img/icons/autocaravanaPublicaGratis.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Área pública gratuita",
                          ),
                        ),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: "7",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Image(
                            image:
                                AssetImage("assets/img/icons/zonaPicnic.png"),
                            width: size.width * 0.05,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 20.0),
                          child: Text(
                            "Zona de picnic",
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    valorIcono = value;
                    if (valorIcono == "1") {
                      nombreIcono = "parkingDiaNoche";
                    } else if (valorIcono == "2") {
                      nombreIcono = "ParkingDia";
                    } else if (valorIcono == "3") {
                      nombreIcono = "naturaleza";
                    } else if (valorIcono == "4") {
                      nombreIcono = "areaDeServicio";
                    } else if (valorIcono == "5") {
                      nombreIcono = "solucionProblemas";
                    } else if (valorIcono == "6") {
                      nombreIcono = "autocaravanaPublicaGratis";
                    } else if (valorIcono == "7") {
                      nombreIcono = "zonaPicnic";
                    }
                  });
                },
                value: valorIcono,
                validator: (value) {
                  if (value == null) {
                    return 'Selecciona un icono';
                  }
                },
              ),
              autovalidate: false,
              onChanged: () {
                FormState();
              },
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Form(
              key: _formKeyNombreLugar,
              child: TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                controller: nombreLugar,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Nombre del lugar',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'No puedes dejar el campo vacío';
                  }
                },
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Divider(
              color: Colors.grey,
              height: 4.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 30.0, right: 30.0),
              child: (Form(
                key: _formKeyDescripcionLugar,
                child: TextFormField(
                  controller: descripcionLugar,
                  decoration: InputDecoration(
                    hintText: "Descripcion del sitio",
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'No puedes dejar el campo vacío';
                    }
                  },
                ),
              )),
            ),
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                  color: myColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0)),
                ),
                child: Text(
                  "Guardar",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                if ((_formKeyIconoLugar.currentState.validate()) &&
                    (_formKeyNombreLugar.currentState.validate()) &&
                    (_formKeyDescripcionLugar.currentState.validate())) {
                  mysql
                      .insertNewMarker(nombreLugar.text, nombreIcono,
                          descripcionLugar.text, marker)
                      .whenComplete(() {
                    mapPage.setState(() {
                      mapPage.cargarMarkersConFilros();
                      Navigator.pop(context);
                    });
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
