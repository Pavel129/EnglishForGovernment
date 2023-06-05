import 'dart:convert';

import './../databases/db_content.dart';
import './../dao/topic_dao.dart';
import './../dao/card_dao.dart';
import './../models/card.dart';
import './../models/course.dart';

/// [CourseDAO] - класс для получения данных типа Course из базы данных.
class CourseDAO {
  static const String TABLE_NAME = 'courses';
  static const String COLUMN_UID = 'uid';
  static const String COLUMN_NAME = 'name';
  static const String COLUMN_GRADE = 'grade';
  static const String COLUMN_IMAGE = 'image';
  static const String COLUMN_POSITION = 'position';

  static Course coursesFromJson(String str) {
    final jsonData = json.decode(str);
    return Course.fromMap(jsonData);
  }

  static String coursesToJson(Course data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Добавление курса в таблицу базы данных, на данный момент избыточно,
  /// но в дальнейшем потребуется.
  ///
  /// [course] - Объект типа Course, который нужно записать в таблицу.
  insert(Course course) async {
    final db = await DBContentProvider.db.database;
    var res = await db.insert(TABLE_NAME, course.toMap());
    return res;
  }

  /// Получить конкрентный курс по идентификатору
  ///
  /// [uid] - идентификатор курса
  getCourse(String uid) async {
    final db = await DBContentProvider.db.database;
    var res =
        await db.query(TABLE_NAME, where: '$COLUMN_UID = ?', whereArgs: [uid]);
    Course result = res.isNotEmpty ? Course.fromMap(res.first) : null;
    return result;
  }

  /// Получить все доступные курсы
  getAllCourse() async {
    final db = await DBContentProvider.db.database;
    var res = await db.query(TABLE_NAME, orderBy: COLUMN_POSITION);
    List<Course> list =
        res.isNotEmpty ? res.map((el) => Course.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить количество слов по курсу.
  ///
  /// [courseID] - идентификатор курса, по которому нужно получить количество слов.
  getWordSizeInCourse(String courseID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM ${CardDAO.TABLE_NAME}'
        ' WHERE ${CardDAO.COLUMN_TOPIC_ID} IN (SELECT ${TopicDAO.COLUMN_UID}'
        '                                        FROM ${TopicDAO.TABLE_NAME}'
        '                                       WHERE ${TopicDAO.COLUMN_COURSE_ID} = \'$courseID\')');
    var list = res.isNotEmpty ? res.map((el) => Card.fromMap(el)).toList() : [];
    var result = list.length;
    return result;
  }
}
