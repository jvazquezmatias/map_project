import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_sweet_alert/flutter_sweet_alert.dart';
import 'package:project/flutter_cupertino_settings.dart';

class MapPage extends StatefulWidget {
  static int _indexFormatMap = 0;
  static bool _value1 = false;
  static bool _value2 = false;
  static String tag = 'map-page';
  static MapType tipusMapa = MapType.normal;
  @override
  MapUiPage createState() => new MapUiPage();
}

class MapUiPage extends State<MapPage> {
  static double numZoom = 14.4746;

  static CameraPosition _position = CameraPosition(
    target: LatLng(41.38616, 2.1037613),
    zoom: numZoom,
  );
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController controllerMap;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      body: GoogleMap(
        mapType: MapPage.tipusMapa,
        initialCameraPosition: _position,
        onCameraMove: _updateCameraPosition,
        onMapCreated: (controller) {
          controllerMap = controller;
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
          SizedBox(height: size.height / 2.3),
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

  // void _addMarkers() {
  //   var markerIdVal = MyWayToGenerateId();
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //   // creating a new MARKER
  //   final Marker marker = Marker(
  //     markerId: markerId,
  //     position: LatLng(
  //       center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
  //       center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
  //     ),
  //     infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
  //     onTap: () {
  //       _onMarkerTapped(markerId);
  //     },
  //   );

  //   setState(() {
  //     // adding a new marker to map
  //     markers[markerId] = marker;
  //   });
  // }
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
      title: new Text("Filters"),
      content: Center(
        child: Column(
          children: <Widget>[
            CheckboxListTile(
              value: MapPage._value1,
              onChanged: (bool value) => setState(() {
                    MapPage._value1 = value;
                  }),
              title: Text('Parking'),
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.archive),
              activeColor: Colors.red,
            ),
            CheckboxListTile(
              value: MapPage._value2,
              onChanged: (bool value) => setState(() {
                    MapPage._value2 = value;
                  }),
              title: Text('Parking'),
              controlAffinity: ListTileControlAffinity.leading,
              secondary: Icon(Icons.archive),
              activeColor: Colors.red,
            ),
          ],
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
