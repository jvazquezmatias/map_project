import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';
import 'package:project/flutter_cupertino_settings.dart';
import 'package:project/ui/pages/marker_details.dart';
import 'package:project/model/my_marker.dart';
import 'package:project/widgets/mysql.dart' as mysql;

class MapPage extends StatefulWidget {
  static int _indexFormatMap = 0;
  static bool _value1 = false;
  static bool _value2 = false;
  static bool _value3 = false;
  static bool _value4 = false;
  static bool _value5 = false;
  static bool _value6 = false;
  static bool _value7 = false;
  static String tag = 'map-page';
  static MapType tipusMapa = MapType.normal;
  @override
  MapUiPage createState() => new MapUiPage();
}

class MapUiPage extends State<MapPage> {
  static double numZoom = 14.4746;
  static List<MyMarker> listMarkers = new List();
  static CameraPosition _position = CameraPosition(
    target: LatLng(41.38616, 2.1037613),
    zoom: numZoom,
  );
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
      body: GoogleMap(
        mapType: MapPage.tipusMapa,
        initialCameraPosition: _position,
        onCameraMove: _updateCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mysql.queryDownloadMarkers().whenComplete(() {
            _addMarkers();
          });
        },
        markers: Set<Marker>.of(markers.values),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "buttonFilter",
            onPressed: () {
              showDialog(context: context, builder: (_) => DialogFilter());
            },
            child: Icon(Icons.filter_list),
          ),
          SizedBox(height: size.height / 50),
          FloatingActionButton(
            heroTag: "buttonAddLocation",
            onPressed: () {},
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

  void _addMarkers() {
    listMarkers.forEach((element) {
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
                      builder: (context) => MarkerDetails(
                            id: element.getId(),
                            latitud: element.getLatitud(),
                            longitud: element.getLongitud(),
                            icono: element.getIcono(),
                            titulo: "Ausias March",
                            descripcion: "Centro Educativo",
                            estrellas: 4,
                            imagen: "ausias.png",
                          )))));
      setState(() {
        // adding a new marker to map
        markers[markerId] = marker;
      });
    });
  }
}

class DialogFilter extends StatefulWidget {
  DialogFilter({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FilterDialog createState() => new _FilterDialog();
}

class _FilterDialog extends State<DialogFilter> {
  String _selectedId;
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text("Filtros"),
      content: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CheckboxListTile(
                value: MapPage._value1,
                onChanged: (bool value) => setState(() {
                      MapPage._value1 = value;
                    }),
                title: Text('Parking día y noche',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage._value2,
                onChanged: (bool value) => setState(() {
                      MapPage._value2 = value;
                    }),
                title:
                    Text('Parking solo día', style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage._value3,
                onChanged: (bool value) => setState(() {
                      MapPage._value3 = value;
                    }),
                title: Text('Rodeado de naturaleza',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage._value4,
                onChanged: (bool value) => setState(() {
                      MapPage._value4 = value;
                    }),
                title:
                    Text('Área de servicios', style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage._value5,
                onChanged: (bool value) => setState(() {
                      MapPage._value5 = value;
                    }),
                title: Text('Solución de problemas',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage._value6,
                onChanged: (bool value) => setState(() {
                      MapPage._value6 = value;
                    }),
                title: Text('Área autocaravanas pública gratuita',
                    style: TextStyle(fontSize: 12.0)),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: Icon(Icons.archive),
                activeColor: Colors.red,
              ),
              CheckboxListTile(
                value: MapPage._value7,
                onChanged: (bool value) => setState(() {
                      MapPage._value7 = value;
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
          onPressed: () => Navigator.pop(context),
          child: Text("Aceptar"),
        ),
      ],
    );
  }
}
