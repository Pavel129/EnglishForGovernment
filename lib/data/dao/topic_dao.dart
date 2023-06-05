import 'dart:convert';

import 'package:aseforenglish/data/databases/db_content.dart';
import 'package:aseforenglish/data/models/topic.dart';

/// [TopicDAO] - класс для получения данных типа Topic из базы данных.
class TopicDAO {
  static const String TABLE_NAME = 'topics';
  static const String COLUMN_UID = 'uid';
  static const String COLUMN_NAME = 'name';
  static const String COLUMN_UP_ID = 'up_id';
  static const String COLUMN_COURSE_ID = 'course_id';
  static const String COLUMN_POSITION = 'position';

  static Topic topicsFromJson(String str) {
    final jsonData = json.decode(str);
    return Topic.fromMap(jsonData);
  }

  static String topicsToJson(Topic data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Метод добавления записи в таблицу бызы данных
  ///
  /// [topic] - объект типа Topic который необходимо записать в БД
  insert(Topic topic) async {
    final db = await DBContentProvider.db.database;
    var res = await db.insert(TABLE_NAME, topic.toMap());
    return res;
  }

  /// Метод получения Темы по идентификатору.
  ///
  /// [uid] - идентификатор интересуемой темы.
  getTopic(String uid) async {
    final db = await DBContentProvider.db.database;
    var res =
        await db.query(TABLE_NAME, where: '$COLUMN_UID = ?', whereArgs: [uid]);
    Topic result = res.isNotEmpty ? Topic.fromMap(res.first) : null;
    return result;
  }

  /// получить все темы без исключений.
  getAllTopic() async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME);
    List<Topic> list =
        res.isNotEmpty ? res.map((el) => Topic.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить все темы по выбранному курсу.
  ///
  /// [courseID] - идентификатор выбранного курса.
  getTopicsForCourse(String courseID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME,
        where: '$COLUMN_COURSE_ID = ?', whereArgs: [courseID]);
    List<Topic> list =
        res.isNotEmpty ? res.map((el) => Topic.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить все темы типа `GROUP` по выбранному курсу.
  ///
  /// [courseID] - идентификатор курса
  getParentTopics(String courseID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(
      TABLE_NAME,
      where: '$COLUMN_COURSE_ID = ? AND $COLUMN_UP_ID = \'\'',
      whereArgs: [courseID],
    );
    List<Topic> list =
        res.isNotEmpty ? res.map((el) => Topic.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить все темы типа `TOPIC` по выбранному курсу.
  ///
  /// [courseID] - идентификатор курса
  getTopics(String courseID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(
      TABLE_NAME,
      where: '$COLUMN_COURSE_ID = ? AND $COLUMN_UP_ID <> \'\'',
      whereArgs: [courseID],
    );
    List<Topic> list =
        res.isNotEmpty ? res.map((el) => Topic.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить все группы наслудуемые от GROUP топика.
  ///
  /// [parentID] - идентификатор групповой темы.
  getParentTopicsChild(String parentID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(
      TABLE_NAME,
      where: '$COLUMN_UP_ID = ?',
      whereArgs: [parentID],
    );
    List<Topic> list =
        res.isNotEmpty ? res.map((el) => Topic.fromMap(el)).toList() : [];
    return list;
  }
}
