import 'dart:convert';

import './../databases/db_content.dart';
import './../models/sourse.dart';

/// [SourseDAO] - класс для получения данных типа Sourse из базы данных.
class SourseDAO {
  static const String TABLE_NAME = 'sourses';
  static const String COLUMN_UID = 'uid';
  static const String COLUMN_PATH = 'path';
  static const String COLUMN_TYPE = 'type';
  static const String COLUMN_PARENT_ID = 'parent_id';

  static Sourse soursesFromJson(String str) {
    final jsonData = json.decode(str);
    return Sourse.fromMap(jsonData);
  }

  static String soursesToJson(Sourse data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Метод добавления источника в таблицу базы данных.
  ///
  /// [sourse] - источник, который необходимо записать в таблицу базы данных.
  insert(Sourse sourse) async {
    final db = await DBContentProvider.db.database;
    var res = await db.insert(TABLE_NAME, sourse.toMap());
    return res;
  }

  /// Метод для получения все источники для конкретной карточки.
  ///
  /// [parentID] - идентификатор карточки, для которой нужно получить источники
  getSourses(String parentID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME,
        where: '$COLUMN_PARENT_ID = ?', whereArgs: [parentID]);
    List<Sourse> list =
        res.isNotEmpty ? res.map((el) => Sourse.fromMap(el)).toList() : [];
    return list;
  }

  /// Метод для получения источникиов по их типу для конкретной карточки.
  ///
  /// [parentID] - идентификатор карточки, для которой нужно получить источники
  ///
  /// [type] -Тип источника
  getSourseType(String parentID, String type) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME,
        where: '$COLUMN_PARENT_ID = ? AND $COLUMN_TYPE = ?',
        whereArgs: [parentID, type]);
    Sourse source = res.isNotEmpty ? Sourse.fromMap(res.first) : null;
    return source;
  }

  /// Метод для получения источникиов типа `AUDIO` для конкретной карточки.
  ///
  /// [parentID] - идентификатор карточки, для которой нужно получить источники
  getSourseAudioType(String cardID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME,
        where: '$COLUMN_PARENT_ID = ? AND $COLUMN_TYPE = \'AUDIO\'',
        whereArgs: [cardID]);
    Sourse source = res.isNotEmpty ? Sourse.fromMap(res.first) : null;
    return source;
  }
}
