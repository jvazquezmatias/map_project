import 'package:flutter/material.dart';
import 'package:project/model/my_marker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:project/ui/pages/marker_details.dart';
import 'package:project/widgets/mysql.dart' as mysql;
import 'package:flutter/src/widgets/basic.dart' as basic;
import 'package:project/ui/pages/home_page.dart';

class FavoritePage extends StatefulWidget {
  static String tag = 'favorite-page';
  @override
  FavoritePageState createState() => new FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  final TextEditingController _filter = new TextEditingController();
  final marker = new MyMarker();
  String _searchText = "";
  static List<dynamic> names = new List();
  List<dynamic> filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Favoritos');

  FavoritePageState() {
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
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: _buildBar(context),
          body: Container(
            child: _buildList(),
          ),
          resizeToAvoidBottomPadding: false,
        ));
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      backgroundColor: Colors.yellow,
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
        Size size = MediaQuery.of(context).size;
        return new GestureDetector(
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
                            fav: true,
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
                          fav: true,
                          myIcon: myIcon,
                          favorites: favorites,
                        ),
                  ),
                );
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.0),
              ),
              margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                child: basic.Row(
                  children: <Widget>[
                    Container(
                        width: size.width * 0.77,
                        child: Text(
                          filteredNames[index].getTitulo(),
                          style: TextStyle(fontSize: 18.0),
                        )),
                    new Image(
                      image: new AssetImage("assets/img/icons/" +
                          filteredNames[index].getIcono() +
                          ".png"),
                      width: size.width * 0.05,
                    )
                  ],
                ),
              ),
            ));
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
        this._appBarTitle = new Text('Favoritos');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    names.clear();
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

    var results = await conn.query(
        "SELECT m.ID,m.LATITUD,m.LONGITUD,m.ICONO,i.TITULO,i.DESCRIPCION,i.ESTRELLAS FROM USERS_FAVORITES_MARKERS f JOIN MARKERS m ON f.IDMARKER = m.ID JOIN USERS u ON f.USERNAME = u.USERNAME JOIN MARKERS_INFO i ON m.ID=i.ID WHERE u.USERNAME = '" +
            mysql.getUser().username.toString() +
            "'");
    for (var row in results) {
      id = row[0];
      latitud = row[1];
      longitud = row[2];
      icono = row[3];
      titulo = row[4];
      descripcion = row[5];
      estrellas = row[6];
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

  Future<bool> _onWillPop() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHome()));
  }
}
