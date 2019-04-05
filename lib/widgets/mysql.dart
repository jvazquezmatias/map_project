import 'package:project/model/user.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';

User user;
String name="";
String surname="";
String surname2="";
String username="";
String password="";
String email="";
bool connection=false;

Future<String> query(var query) async {
  // Open a connection (testdb should already exist) javi123456_
  final conn = await MySqlConnection.connect(new ConnectionSettings(
      host: 'labs.iam.cat',
      port: 3306,
      user: 'a17pabsanrod_adm',
      password: 'pablo1234',
      db: 'a17pabsanrod_projectefinal'));

  // Query the database using a parameterized query
  var results = await conn
      .query(query);
  for (var row in results) {
    username = row[0];
    password = row[1];
    connection=true;
  }
    //print(getFinalizado());
  user = new User(name: name,surname: surname,surname2: surname2,username: username,password: password,email: email);

  // Finally, close the connection
  await conn.close();
}

User getUser(){
  return user;
}
bool getConnection() {
  return connection;
}

