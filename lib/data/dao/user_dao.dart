import 'dart:convert';

import './../../data/databases/db_content.dart';
import './../../data/models/user.dart';

/// [TopicDAO] - класс для получения данных типа User из базы данных.
class UserDAO {
  static const String TABLE_NAME = 'users';
  static const String COLUMN_PASSWORD = 'password';
  static const String COLUMN_LOGIN = 'login';
  static const String COLUMN_NAME = 'name';

  static User usersFromJson(String str) {
    final jsonData = json.decode(str);
    return User.fromMap(jsonData);
  }

  static String usersToJson(User data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Метод добавления пользователей в систему.
  ///
  /// [user] - пользователь, которого нужно добавить в систему.
  insert(User user) async {
    final db = await DBContentProvider.db.database;
    var res = await db.insert(TABLE_NAME, user.toMap());
    return res;
  }

  /// Получить пользователя, по логину.
  ///
  /// [login] - логин пользователя, по которому нужно его получить из БД
  getUser(String login) async {
    final db = await DBContentProvider.db.database;
    var res = await db
        .query(TABLE_NAME, where: '$COLUMN_LOGIN = ?', whereArgs: [login]);
    User user = res.isNotEmpty ? User.fromMap(res.first) : null;
    return user;
  }
}
