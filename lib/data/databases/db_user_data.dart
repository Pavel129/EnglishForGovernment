import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import './../dao/audit_dao.dart';
import './../dao/process_learning_dao.dart';

/// [DBUserDataProvider] - Класс провайдер для работы с базой данных.
/// Данная таблица используется для локального хранения действий пользователя,
/// а так же для хранения прогреса пользователя по изучению слов.
/// данная таблица не должна перезатираться или удаляться в процессе работы приложения.
class DBUserDataProvider {
  DBUserDataProvider._();
  static final DBUserDataProvider db = DBUserDataProvider._();
  factory DBUserDataProvider() {
    db._auditDAO = db.getAuditDAO();
    return db;
  }

  static Database _database;

  AuditDAO _auditDAO;
  ProcessLearningDAO _processLearningDAO;

  AuditDAO getAuditDAO() => _auditDAO == null ? AuditDAO() : _auditDAO;
  ProcessLearningDAO getProcessLearningDAO() =>
      _processLearningDAO == null ? ProcessLearningDAO() : _processLearningDAO;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future close() async {
    if (_database != null) {
      await _database.close();
      _database = null;
    }
  }

  Future open() async {
    if (_database == null) _database = await initDB();
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}/ase.user_data.db';

    return await openDatabase(
      path = path,
      version: 2,
      onOpen: (db) {},
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute(''
              'ALTER TABLE ${AuditDAO.TABLE_NAME}'
              '  ADD COLUMN ${AuditDAO.COLUMN_TOPIC_ID} TEXT'
              '');
        }
      },
      onCreate: (Database db, int version) async {
        // Создание таблицы `audit`
        await db.execute(
          'CREATE TABLE ${AuditDAO.TABLE_NAME} '
          '('
          '   ${AuditDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${AuditDAO.COLUMN_USER_ID} TEXT NOT NULL,'
          '   ${AuditDAO.COLUMN_TOPIC_ID} TEXT,'
          '   ${AuditDAO.COLUMN_COURSE_ID} TEXT NOT NULL,'
          '   ${AuditDAO.COLUMN_START_DT} TEXT NOT NULL,'
          '   ${AuditDAO.COLUMN_END_DT} TEXT NOT NULL'
          ')',
        );
        // Создание таблицы `process_learning`
        await db.execute(
          'CREATE TABLE ${ProcessLearningDAO.TABLE_NAME} '
          '('
          '   ${ProcessLearningDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${ProcessLearningDAO.COLUMN_UP_ID} TEXT,'
          '   ${ProcessLearningDAO.COLUMN_TOPIC_ID} TEXT NOT NULL,'
          '   ${ProcessLearningDAO.COLUMN_USER_ID} TEXT NOT NULL,'
          '   ${ProcessLearningDAO.COLUMN_PROGRESS} TEXT NOT NULL,'
          '   ${ProcessLearningDAO.COLUMN_PROCESS_LEVEL} INTEGER,'
          '   ${ProcessLearningDAO.COLUMN_START_DT} TEXT,'
          '   ${ProcessLearningDAO.COLUMN_END_DT} TEXT'
          ')',
        );
      },
    );
  }
}
