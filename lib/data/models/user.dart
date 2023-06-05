// user.dart
import './../dao/user_dao.dart' as dao;

/// [User] - Класс по хранению данных о больщователе
///
/// Поля:
///
/// [login] - Логин пользователя. Является Primary Key
///
/// [password] - Пароль пользователа.
/// TODO трубуется сделать шифрование данного поля + добавить соли.
///
/// [name] - ФИО пользователя, хранить в виде `Ивано Иванович И.`
class User {
  String login;
  String password;
  String name;

  User({
    this.login,
    this.password,
    this.name,
  });

  factory User.fromMap(Map<String, dynamic> json) => new User(
        password: json[dao.UserDAO.COLUMN_PASSWORD],
        login: json[dao.UserDAO.COLUMN_LOGIN],
        name: json[dao.UserDAO.COLUMN_NAME],
      );

  Map<String, dynamic> toMap() => {
        dao.UserDAO.COLUMN_PASSWORD: password,
        dao.UserDAO.COLUMN_LOGIN: login,
        dao.UserDAO.COLUMN_NAME: name,
      };
}
