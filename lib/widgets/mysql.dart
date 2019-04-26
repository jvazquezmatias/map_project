import 'package:project/model/user.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:project/model/my_marker.dart';
import 'package:project/ui/pages/map_page.dart';

User user;
String name = "";
String surname = "";
String surname2 = "";
String username = "";
String password = "";
String email = "";
bool connection = false;

Future<String> query(var query) async {
  name = "";
  surname = "";
  surname2 = "";
  username = "";
  password = "";
  email = "";
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  var results = await conn.query(query);
  for (var row in results) {
    name = row[0];
    surname = row[1];
    surname2 = row[2];
    username = row[3];
    email = row[4];
    password = row[5];
    connection = true;
  }
  user = new User(
      name: name,
      surname: surname,
      surname2: surname2,
      username: username,
      password: password,
      email: email);
  // Finally, close the connection
  await conn.close();
}

Future<String> queryChangePassword(var query) async {
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  await conn.query(query);

  // Finally, close the connection
  await conn.close();
}

Future<String> queryDownloadMarkers() async {
  String id = "";
  double latitud = 0;
  double longitud = 0;
  String icono = "";

  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  var results = await conn.query("SELECT * FROM MARKERS");
  for (var row in results) {
    id = row[0];
    latitud = row[1];
    longitud = row[2];
    icono = row[3];
    MyMarker marker = new MyMarker(id: id, latitud: latitud, longitud: longitud, icono: icono);
    MapUiPage.listMarkers.add(marker);
  }
  // Finally, close the connection
  await conn.close();
}

User getUser() {
  return user;
}

bool getConnection() {
  return connection;
}
