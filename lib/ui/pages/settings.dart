import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:project/flutter_cupertino_settings.dart';
import 'package:project/ui/pages/map_page.dart' as map;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SettingsPage extends StatefulWidget {
  static int _indexTipoMapa = 0;
  static int _indexFormatoMapa = 0;
  static int _indexIdioma = 0;
  static String tag = 'settings-page';
  @override
  SettingsTab createState() => new SettingsTab();
}

class SettingsTab extends State<SettingsPage> {
  List<String> locations = ['Español', 'Catalán', 'Inglés'];
  String _selectedLocation = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CupertinoSettings(
        items: <Widget>[
          CSHeader('Tipo de mapa:'),
          CSSelection(
            ['Carretera', 'Satélites', 'Terreno', 'Híbrido'],
            (int value) {
              setState(() {
                SettingsPage._indexTipoMapa = value;
                if (SettingsPage._indexTipoMapa == 0) {
                  map.MapPage.tipusMapa = MapType.normal;
                }
                if (SettingsPage._indexTipoMapa == 1) {
                  map.MapPage.tipusMapa = MapType.satellite;
                }
                if (SettingsPage._indexTipoMapa == 2) {
                  map.MapPage.tipusMapa = MapType.terrain;
                }
                if (SettingsPage._indexTipoMapa == 3) {
                  map.MapPage.tipusMapa = MapType.hybrid;
                }
              });
            },
            currentSelection: SettingsPage._indexTipoMapa,
          ),
          CSHeader('Formato del mapa:'),
          CSSelection(
            ['Kilómetros', 'Millas'],
            (int value) {
              setState(() {
                SettingsPage._indexFormatoMapa = value;
              });
            },
            currentSelection: SettingsPage._indexFormatoMapa,
          ),
          CSHeader('Idioma:'),
          CSSelection(
            ['Español', 'Catalán', 'Inglés'],
            (int value) {
              setState(() {
                SettingsPage._indexIdioma = value;
              });
            },
            currentSelection: SettingsPage._indexIdioma,
          ),
        ],
      ),
    );
  }
}
