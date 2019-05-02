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
  static bool parkingDiaYNoche = false;
  static bool parkingSoloDia = false;
  static bool rodeadoDeNaturaleza = false;
  static bool areaDeServicios = false;
  static bool solucionDeProblemas = false;
  static bool areaAutocaravanasPublicaGratuita = false;
  static bool zonaDePicnic = false;
  static bool mostrarBotonesAbajo = false;
  static bool verBotonesAbajo = false;
  static BuildContext context;
  static List<String> filtrosActivos;
  static String tag = 'map-page';
  static MapType tipusMapa = MapType.normal;
  @override
  MapUiPage createState() => new MapUiPage();
}

class MapUiPage extends State<MapPage> {
  static double numZoom = 14.4746;
  static List<MyMarker> listMarkers = new List();
  LatLng actualPosition;
  static CameraPosition _position = CameraPosition(
    target: LatLng(41.38616, 2.1037613),
    zoom: numZoom,
  );
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    MapPage.context = context;
    Size size = MediaQuery.of(context).size;
    actualPosition = _position.target;
    return new Scaffold(
      body: GoogleMap(
        mapType: MapPage.tipusMapa,
        initialCameraPosition: _position,
        onCameraMove: (position) {
          _updateCameraPosition;
          actualPosition = position.target;
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mysql.queryDownloadMarkers().whenComplete(() {
            _addMarkers();
          });
        },
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: MapPage.mostrarBotonesAbajo
          ? botonesAbajo
          : Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
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
                ),
                SizedBox(height: size.height / 50),
                FloatingActionButton(
                  heroTag: "buttonAddLocation",
                  onPressed: () {
                    HomeTab.disabled
                        ? SweetAlert.dialog(
                            type: AlertType.ERROR,
                            cancelable: true,
                            title: "Inicia sesión para añadir un nuevo lugar",
                            showCancel: false,
                            closeOnConfirm: true,
                            confirmButtonText: "Aceptar",
                          )
                        : {
                            MapPage.verBotonesAbajo = true,
                            MapPage.mostrarBotonesAbajo = true,
                            _onAddPlacePressed(),
                          };
                  },
                  child: Icon(Icons.location_on),
                ),
                SizedBox(height: size.height / 2.6),
                FloatingActionButton(
                  heroTag: "buttonFormatMap",
                  onPressed: () {
                    _formatMap();
                  },
                  child: Icon(Icons.layers),
                ),
                SizedBox(height: size.height / 50),
                FloatingActionButton(
                  heroTag: "buttonAdd",
                  onPressed: () {
                    _zoomIn();
                  },
                  child: Icon(Icons.add),
                ),
                SizedBox(height: size.height / 50),
                FloatingActionButton(
                  heroTag: "buttonRemove",
                  onPressed: () {
                    _zoomOut();
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(height: size.height / 15),
              ],
            ),
    );
  }

  var botonesAbajo = Visibility(
    visible: MapPage.verBotonesAbajo,
    child: Container(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
      alignment: Alignment.bottomCenter,
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            color: Colors.blue,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () {},
          ),
          RaisedButton(
            color: Colors.red,
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            onPressed: () {
              MapPage.mostrarBotonesAbajo = false;
              MapPage.verBotonesAbajo = false;
            },
          ),
        ],
      ),
    ),
  );

  Future<void> _zoomIn() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(_position.zoom + 1));
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.zoomTo(_position.zoom - 1));
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
      final MarkerId markerId = MarkerId("ddd");
      final newMarker = Marker(
        markerId: markerId,
        position: actualPosition,
        infoWindow: InfoWindow(title: 'New Place'),
        draggable: true,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
      markers[markerId] = (newMarker);
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
            title: "Ausias March",
            snippet: "pruebaa",
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PageMarkerDetails(
                          id: element.getId(),
                          latitud: element.getLatitud(),
                          longitud: element.getLongitud(),
                          icono: element.getIcono(),
                          titulo: element.getTitulo(),
                          descripcion: element.getDescripcion(),
                          estrellas: element.getEstrellas(),
                          imagen: element.getImagen(),
                        ),
                  ),
                ),
          ),
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
    return new AlertDialog(
      title: new Text("Filters"),
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
                secondary: Icon(Icons.archive),
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
                secondary: Icon(Icons.archive),
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
                secondary: Icon(Icons.archive),
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
                secondary: Icon(Icons.archive),
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
                secondary: Icon(Icons.archive),
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
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage.zonaDePicnic,
                onChanged: (bool value) => setState(() {
                      MapPage.zonaDePicnic = value;
                    }),
                title: Text('Zona de picnic', style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            mapPage.setState(() {
              MapUiPage.listMarkers.clear();
              mapPage.markers.clear();
            });
            MapPage.filtrosActivos = new List();
            if (MapPage.parkingDiaYNoche)
              MapPage.filtrosActivos.add(mysql.parkingDiaNoche);
            if (MapPage.parkingSoloDia)
              MapPage.filtrosActivos.add(mysql.parkingSoloDia);

            if (MapPage.filtrosActivos.isNotEmpty) {
              mysql.queryDownloadMarkersAndFilter().whenComplete(() {
                mapPage._addMarkers();
              });
            }

            Navigator.pop(context);
          },
          child: Text("Aceptar"),
        ),
      ],
    );
  }
}
