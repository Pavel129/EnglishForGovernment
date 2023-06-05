import 'dart:convert';

import './../databases/db_user_data.dart';
import './../models/audit.dart';

/// [AuditDAO] - ДАО объект по работе с базой данных аудита.
/// позволяет хранить в себе информацию о заходе пользователя в приложение
///
/// Так же сохраняет в себя последние открытые курсы, для получения этих данных в
/// нижнем меню, для получения последнего открытого курса.
class AuditDAO {
  static const String TABLE_NAME = 'audit';
  static const String COLUMN_UID = 'uid';

  /// USER_ID = user login
  static const String COLUMN_USER_ID = 'user_id';
  static const String COLUMN_TOPIC_ID = 'topic_id';
  static const String COLUMN_COURSE_ID = 'course_id';
  static const String COLUMN_START_DT = 'start_dt';
  static const String COLUMN_END_DT = 'end_dt';

  static Audit auditFromJson(String str) {
    final jsonData = json.decode(str);
    return Audit.fromMap(jsonData);
  }

  static String auditToJson(Audit data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Добавить запись захода в приложение и выбор курсов в базу.
  ///
  /// [audit] - Аудит, который требуется записать в таблицу.
  insert(Audit audit) async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.insert(TABLE_NAME, audit.toMap());
    return res;
  }

  /// Метод получения всех записей аудита
  getAudits() async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM ${AuditDAO.TABLE_NAME}'
        '');
    List<Audit> result =
        res.isNotEmpty ? res.map((el) => Audit.fromMap(el)).toList() : [];
    return result;
  }

  /// Метод очистки данных, так как у нас на 1 устройстве по  умолчанию
  /// 1 пользолватель, при выходи из приложения, чистим аудит, и делов
  audinDeleteData() async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.rawQuery(''
        'DELETE'
        '  FROM ${AuditDAO.TABLE_NAME}'
        '');
    List<Audit> result =
        res.isNotEmpty ? res.map((el) => Audit.fromMap(el)).toList() : [];
    return result.length == 0;
  }

  /// Получить последнее действие пользователя
  ///
  /// Если более ранних заходов в приложения не было, то возвращается [null].
  getLastAudit() async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM ${AuditDAO.TABLE_NAME}'
        ' WHERE ${AuditDAO.COLUMN_START_DT} = (SELECT MAX(${AuditDAO.COLUMN_START_DT})'
        '                                        FROM ${AuditDAO.TABLE_NAME})'
        ' LIMIT 1'
        '');
    Audit result = res.isNotEmpty ? Audit.fromMap(res.first) : null;
    return result;
  }
}
