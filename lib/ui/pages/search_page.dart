import 'package:flutter/material.dart';
import 'package:project/model/my_marker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project/ui/pages/marker_details.dart';
import 'package:project/widgets/mysql.dart' as mysql;

class SearchPage extends StatefulWidget {
  static String tag = 'search-page';
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final TextEditingController _filter = new TextEditingController();
  final marker = new MyMarker();
  String _searchText = "";
  List<dynamic> names = new List();
  List<dynamic> filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Buscar');

  SearchPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      backgroundColor: Colors.redAccent,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .getTitulo()
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
            title: Text(filteredNames[index].getTitulo()),
            onTap: () {
              IconData myIcon;
              List<String> favorites = new List<String>();

              if (mysql.getConnection()) {
                print(mysql.getFavorites());
                mysql
                    .obtenerMarkerToFavorites(mysql.getUser().getUsername())
                    .whenComplete(() {
                  favorites = mysql.getFavorites();
                  print("2 " + favorites.toString());

                  MarkerDetails.iconoEstrellaVacio = true;

                  favorites.forEach((elemento) {
                    if (elemento == filteredNames[index].getId()) {
                      print("ELEMENTO 1: " + elemento);
                      print("ELEMENTO 2: " + filteredNames[index].getId());
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
                            id: filteredNames[index].getId(),
                            latitud: filteredNames[index].getLatitud(),
                            longitud: filteredNames[index].getLongitud(),
                            icono: filteredNames[index].getIcono(),
                            titulo: filteredNames[index].getTitulo(),
                            descripcion: filteredNames[index].getDescripcion(),
                            estrellas: filteredNames[index].getEstrellas(),
                            imagen: filteredNames[index].getImagen(),
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
                          id: filteredNames[index].getId(),
                          latitud: filteredNames[index].getLatitud(),
                          longitud: filteredNames[index].getLongitud(),
                          icono: filteredNames[index].getIcono(),
                          titulo: filteredNames[index].getTitulo(),
                          descripcion: filteredNames[index].getDescripcion(),
                          estrellas: filteredNames[index].getEstrellas(),
                          imagen: filteredNames[index].getImagen(),
                          fav: false,
                          myIcon: myIcon,
                          favorites: favorites,
                        ),
                  ),
                );
              }
            });
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Buscar...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Buscar');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    String id = "";
    double latitud = 0;
    double longitud = 0;
    String icono = "";
    String titulo = "";
    String descripcion = "";
    int estrellas = 0;
    String imagen = "";

    final conn = await MySqlConnection.connect(new ConnectionSettings(
        host: 'labs.iam.cat',
        port: 3306,
        user: 'a17pabsanrod_adm',
        password: 'pablo1234',
        db: 'a17pabsanrod_projectefinal'));

    var results = await conn
        .query("SELECT * FROM MARKERS m JOIN MARKERS_INFO i ON m.ID=i.ID");
    for (var row in results) {
      id = row[0];
      latitud = row[1];
      longitud = row[2];
      icono = row[3];
      titulo = row[5];
      descripcion = row[6];
      estrellas = row[7];
      MyMarker marker = new MyMarker(
          id: id,
          latitud: latitud,
          longitud: longitud,
          icono: icono,
          titulo: titulo,
          descripcion: descripcion,
          estrellas: estrellas);
      setState(() {
        names.add(marker);
        names.shuffle();
        filteredNames = names;
      });
    }

    await conn.close();
  }
}
