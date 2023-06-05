import 'dart:convert';

import './../databases/db_content.dart';
import './../models/incorrect.dart';

/// [IncorrectDAO] - класс для получения данных типа Incorrect из базы данных.
class IncorrectDAO {
  static const String TABLE_NAME = 'incorrects';
  static const String COLUMN_UID = 'uid';
  static const String COLUMN_VALUE = 'value';
  static const String COLUMN_TYPE = 'type';
  static const String COLUMN_PARENT_ID = 'parent_id';

  static Incorrect incorrectsFromJson(String str) {
    final jsonData = json.decode(str);
    return Incorrect.fromMap(jsonData);
  }

  static String incorrectsToJson(Incorrect data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Добавление не верного варианта ответа в таблицу базы данных, на данный момент избыточно,
  /// но в дальнейшем потребуется.
  ///
  /// [incorrect] - Объект типа Incorrect, который нужно записать в таблицу.
  insert(Incorrect incorrect) async {
    final db = await DBContentProvider.db.database;
    var res = await db.insert(TABLE_NAME, incorrect.toMap());
    return res;
  }

  /// Получить список не корректных вариантов ответов которые были заведены при составлении контента.
  ///
  /// [parentID] - Идентификатор родительской карточки
  getIncorrects(String parentID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME,
        where: '$COLUMN_PARENT_ID = ?', whereArgs: [parentID]);
    List<Incorrect> list =
        res.isNotEmpty ? res.map((el) => Incorrect.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить список не корректных вариантов ответов по типу которые были заведены при составлении контента.
  ///
  /// [parentID] - Идентификатор родительской карточки.
  ///
  /// [type] - тип интересующего не верного варианта ответа. TRANSLATE или WORD
  /// TODO требуется добавить enum перечисления вариантов типа.
  getIncorrectType(String parentID, String type) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME,
        where: '$COLUMN_PARENT_ID = ? AND $COLUMN_TYPE = ?',
        whereArgs: [parentID, type]);
    List<Incorrect> list =
        res.isNotEmpty ? res.map((el) => Incorrect.fromMap(el)).toList() : [];
    return list;
  }
}
