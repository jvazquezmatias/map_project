class User {
  String name;
  String surname;
  String surname2;
  String username;
  String password;
  String email;

  User(
      {this.name,
      this.surname,
      this.surname2,
      this.username,
      this.password,
      this.email});

  String getName() {
    return name;
  }

  String getSurname() {
    return surname;
  }

  String getSurname2() {
    return surname2;
  }

  String getUsername() {
    return username;
  }

  String getPassword() {
    return password;
  }

  String getEmail() {
    return email;
  }
}
