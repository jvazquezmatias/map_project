import 'package:project/model/user.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';

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
      host: 'sql7.freemysqlhosting.net',
      port: 3306,
      user: 'sql7285849',
      password: '44gTZnjj5j',
      db: 'sql7285849'));

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

