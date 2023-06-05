import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import '../dao/user_dao.dart';
import '../dao/course_dao.dart';
import '../dao/topic_dao.dart';
import '../dao/card_dao.dart';
import '../dao/incorrect_dao.dart';
import '../dao/sourse_dao.dart';

/// [DBContentProvider] - Класс провайдер для работы с базой данных.
/// Данная БД содержит в себе контент который мы получаем из вне.
/// По идее в данной базе не предполагается каких либо изменений со стороны пользователя.
/// при пуске приложения, файл базы данных следует заменять обновленной базой данных
/// для того что бы получать актуальные данные для отображения в приложении.
class DBContentProvider {
  static const String BASE_NAME = 'ase.content.db';

  DBContentProvider._();
  static final DBContentProvider db = DBContentProvider._();
  factory DBContentProvider() {
    db._userDAO = db.getUserDAO();
    db._cardDAO = db.getCardDAO();
    db._topicDAO = db.getTopicDAO();
    db._sourseDAO = db.getSourseDAO();
    db._courseDAO = db.getCourseDAO();
    db._incorrectDAO = db.getIncorrectDAO();
    return db;
  }

  static Database _database;

  UserDAO _userDAO;
  CardDAO _cardDAO;
  TopicDAO _topicDAO;
  SourseDAO _sourseDAO;
  CourseDAO _courseDAO;
  IncorrectDAO _incorrectDAO;

  UserDAO getUserDAO() => _userDAO == null ? UserDAO() : _userDAO;
  CardDAO getCardDAO() => _cardDAO == null ? CardDAO() : _cardDAO;
  TopicDAO getTopicDAO() => _topicDAO == null ? TopicDAO() : _topicDAO;
  SourseDAO getSourseDAO() => _sourseDAO == null ? SourseDAO() : _sourseDAO;
  CourseDAO getCourseDAO() => _courseDAO == null ? CourseDAO() : _courseDAO;
  IncorrectDAO getIncorrectDAO() =>
      _incorrectDAO == null ? IncorrectDAO() : _incorrectDAO;

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
    var path = '${directory.path}/$BASE_NAME';

  return await openDatabase(
      path = path,
      version: 2,
      onOpen: (db) {},
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion == 1 && newVersion == 2) {
          await db.execute(''
              'ALTER TABLE ${CourseDAO.TABLE_NAME}'
              '  ADD COLUMN ${CourseDAO.COLUMN_GRADE} TEXT'
              '');
        }
      },
      onCreate: (Database db, int version) async {
        // Создание таблицы `users`
        await db.execute(
          'CREATE TABLE ${UserDAO.TABLE_NAME} '
          '('
          '   ${UserDAO.COLUMN_LOGIN} TEXT PRIMARY KEY,'
          '   ${UserDAO.COLUMN_PASSWORD} TEXT NOT NULL,'
          '   ${UserDAO.COLUMN_NAME} TEXT NOT NULL'
          ')',
        );
        // Создание таблицы `courses`
        await db.execute(
          'CREATE TABLE ${CourseDAO.TABLE_NAME} '
          '('
          '   ${CourseDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${CourseDAO.COLUMN_NAME} TEXT NOT NULL UNIQUE,'
          '   ${CourseDAO.COLUMN_GRADE} TEXT NOT NULL,'
          '   ${CourseDAO.COLUMN_IMAGE} TEXT NOT NULL,'
          '   ${CourseDAO.COLUMN_POSITION} INTEGER DEFAULT 0'
          ')',
        );
        // Создание таблицы `topics`
        await db.execute(
          'CREATE TABLE ${TopicDAO.TABLE_NAME} '
          '('
          '   ${TopicDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${TopicDAO.COLUMN_NAME} TEXT NOT NULL,'
          '   ${TopicDAO.COLUMN_UP_ID} TEXT NOT NULL,'
          '   ${TopicDAO.COLUMN_COURSE_ID} TEXT NOT NULL,'
          '   ${TopicDAO.COLUMN_POSITION} INTEGER DEFAULT 0,'
          '   FOREIGN KEY (${TopicDAO.COLUMN_COURSE_ID}) '
          '   REFERENCES ${CourseDAO.TABLE_NAME}(${CourseDAO.COLUMN_UID})'
          ')',
        );
        // Создание таблицы `cards`
        await db.execute(
          'CREATE TABLE ${CardDAO.TABLE_NAME} '
          '('
          '   ${CardDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${CardDAO.COLUMN_WORD} TEXT NOT NULL,'
          '   ${CardDAO.COLUMN_TOPIC_ID} TEXT NOT NULL,'
          '   ${CardDAO.COLUMN_TRANSLATE} TEXT NOT NULL,'
          '   ${CardDAO.COLUMN_TRANSCRIPTION} TEXT NOT NULL,'
          '   ${CardDAO.COLUMN_DESCRIPTION} TEXT NOT NULL,'
          '   ${CardDAO.COLUMN_POSITION} INTEGER DEFAULT 0,'
          '   FOREIGN KEY (${CardDAO.COLUMN_TOPIC_ID}) '
          '   REFERENCES ${TopicDAO.TABLE_NAME}(${TopicDAO.COLUMN_UID})'
          ')',
        );
        // Создание таблицы `incorrects`
        await db.execute(
          'CREATE TABLE ${IncorrectDAO.TABLE_NAME} '
          '('
          '   ${IncorrectDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${IncorrectDAO.COLUMN_VALUE} TEXT NOT NULL,'
          '   ${IncorrectDAO.COLUMN_PARENT_ID} TEXT NOT NULL,'
          '   ${IncorrectDAO.COLUMN_TYPE} TEXT NOT NULL,'
          '   FOREIGN KEY (${IncorrectDAO.COLUMN_PARENT_ID}) '
          '   REFERENCES ${CardDAO.TABLE_NAME}(${CardDAO.COLUMN_UID})'
          ')',
        );
        // Создание таблицы `sourses`
        await db.execute(
          'CREATE TABLE ${SourseDAO.TABLE_NAME} '
          '('
          '   ${SourseDAO.COLUMN_UID} TEXT PRIMARY KEY,'
          '   ${SourseDAO.COLUMN_PATH} TEXT NOT NULL,'
          '   ${SourseDAO.COLUMN_PARENT_ID} TEXT NOT NULL,'
          '   ${SourseDAO.COLUMN_TYPE} TEXT NOT NULL,'
          '   FOREIGN KEY (${IncorrectDAO.COLUMN_PARENT_ID}) '
          '   REFERENCES ${CardDAO.TABLE_NAME}(${CardDAO.COLUMN_UID})'
          ')',
        );
      },
    );
  }
}
