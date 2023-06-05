import 'dart:convert';

import './../repo/repository.dart';
import './../databases/db_user_data.dart';
import './../models/process_learning.dart';
import './../models/topic.dart';

/// [ProcessLearningDAO] - класс для получения данных типа `ProcessLearning` из базы данных.
class ProcessLearningDAO {
  static const String TABLE_NAME = 'process_learning';
  static const String COLUMN_UID = 'uid';
  static const String COLUMN_UP_ID = 'up_id';
  static const String COLUMN_TOPIC_ID = 'topic_id';
  static const String COLUMN_USER_ID = 'user_dt';
  static const String COLUMN_PROGRESS = 'progress';
  static const String COLUMN_PROCESS_LEVEL = 'process_level';
  static const String COLUMN_START_DT = 'start_dt';
  static const String COLUMN_END_DT = 'end_dt';

  static ProcessLearning processLearningFromJson(String str) {
    final jsonData = json.decode(str);
    return ProcessLearning.fromMap(jsonData);
  }

  static String processLearningToJson(ProcessLearning data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Метод добавления записи типа `ProcessLearning` в базу данных
  ///
  /// [proc] - Объект типа `ProcessLearning` который необходимо добавить.
  insert(ProcessLearning proc) async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.insert(TABLE_NAME, proc.toMap());
    return res;
  }

  /// Метод обновления записи типа `ProcessLearning` в базе данных
  ///
  /// [proc] - Объект типа `ProcessLearning` который необходимо обновить.
  update(ProcessLearning proc) async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.update(TABLE_NAME, proc.toMap(),
        where: '$COLUMN_UID = ?', whereArgs: [proc.uid]);
    return res;
  }

  /// Получить последний (а он должен быть всего один) процесс типа `HEAD` для выбранной темы.
  ///
  /// [topicID] - идентификатор топика, по которому необходимо получить выбьрку процессов
  getHeadProcessInTopic(String topicID) async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE $COLUMN_TOPIC_ID = \'$topicID\''
        '   AND $COLUMN_UP_ID IS NULL'
        '   AND $COLUMN_END_DT = \'\''
        ' LIMIT 1'
        '');
    ProcessLearning result =
        res.isNotEmpty ? ProcessLearning.fromMap(res.first) : null;
    return result;
  }

  /// Метод позволяющий получить последний открытый процесс по  выбранной теме
  ///
  /// [topicID] - идентификатор необходимой темы, по которой нужно получить последний открытый процесс
  getLastProc(String topicID) async {
    final db = await DBUserDataProvider.db.database;
    ProcessLearning head = await getHeadProcessInTopic(topicID);
    var res = head == null
        ? []
        : await db.rawQuery(''
            'SELECT *'
            '  FROM $TABLE_NAME'
            ' WHERE $COLUMN_UP_ID = ${head.uid}'
            '   AND $COLUMN_END_DT = \'\''
            ' ORDER BY $COLUMN_PROCESS_LEVEL DESC'
            '');
    ProcessLearning result =
        res.isNotEmpty ? ProcessLearning.fromMap(res.first) : null;
    return result;
  }

  /// Метод позволяющий получить все доступные головные процессы типа `HEAD` по курсу
  getHeadProcess(String courseID) async {
    final db = await DBUserDataProvider.db.database;
    List<Topic> topics = await RepositoryLocal().getTopics(courseID);
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE $COLUMN_UP_ID IS NULL'
        '   AND $COLUMN_UID IN ('
        '       SELECT $COLUMN_UP_ID '
        '         FROM $TABLE_NAME'
        '        WHERE $COLUMN_TOPIC_ID IN ( ${_topicsToString(topics)} )'
        '          AND $COLUMN_PROCESS_LEVEL NOT IN (0, 10) )'
        '');
    List<ProcessLearning> result = res.isNotEmpty
        ? res.map((el) => ProcessLearning.fromMap(el)).toList()
        : [];
    return result;
  }

  /// Пполучить все процессы без исключения
  ///
  /// Используется для получения всех уникальных идентификаторов в системе.
  /// Возможно не оптимальное решение.
  getAllProcess() async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        '');
    List<ProcessLearning> result = res.isNotEmpty
        ? res.map((el) => ProcessLearning.fromMap(el)).toList()
        : [];
    return result;
  }

  /// Метод получения всех `открытых` процессов по данному курсу `текущей` и `прошедшей` датой,
  /// не показываются процессы типа `HEAD` и `LEARNING`
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  getPrevRepeat(String courseID) async {
    final db = await DBUserDataProvider.db.database;
    List<Topic> topics = await RepositoryLocal().getTopics(courseID);
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE DATE($COLUMN_START_DT) <= CURRENT_DATE'
        '   AND $COLUMN_END_DT = \'\''
        '   AND $COLUMN_UP_ID IS NOT NULL'
        '   AND $COLUMN_PROCESS_LEVEL NOT IN (0, 10)' // 10 - HEAD, 0 - LEARNING
        '   AND $COLUMN_TOPIC_ID IN ( ${_topicsToString(topics)} )'
        ' ORDER BY $COLUMN_PROCESS_LEVEL DESC'
        '');
    List<ProcessLearning> result = res.isNotEmpty
        ? res.map((el) => ProcessLearning.fromMap(el)).toList()
        : [];
    return result;
  }

  /// Метод получения информации, находится ди указанная тема сегодня на повторении
  ///
  /// [topicID] - Идентификатор тебы, которая нас интересует
  getTopicInRepeateNow(String topicID) async {
    final db = await DBUserDataProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE DATE($COLUMN_START_DT) <= CURRENT_DATE'
        '   AND $COLUMN_END_DT = \'\''
        '   AND $COLUMN_UP_ID IS NOT NULL'
        '   AND $COLUMN_PROCESS_LEVEL NOT IN (0, 10)' // 10 - HEAD, 0 - LEARNING
        '   AND $COLUMN_TOPIC_ID = \'$topicID\''
        ' ORDER BY $COLUMN_PROCESS_LEVEL DESC'
        '');
    ProcessLearning result =
        res.isNotEmpty ? ProcessLearning.fromMap(res.first) : null;
    return result;
  }

  /// Метод получения всех `открытых` процессов по данному курсу `Будущей` датой,
  /// не показываются процессы типа `HEAD` и `LEARNING`
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  getNextRepeat(String courseID) async {
    final db = await DBUserDataProvider.db.database;
    List<Topic> topics = await RepositoryLocal().getTopics(courseID);
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE DATE($COLUMN_START_DT) > CURRENT_DATE'
        '   AND $COLUMN_END_DT = \'\''
        '   AND $COLUMN_UP_ID IS NOT NULL'
        '   AND $COLUMN_PROCESS_LEVEL NOT IN (0, 10)' // 10 - HEAD, 0 - LEARNING
        '   AND $COLUMN_TOPIC_ID IN ( ${_topicsToString(topics)} )'
        ' ORDER BY $COLUMN_PROCESS_LEVEL DESC'
        '');
    List<ProcessLearning> result = res.isNotEmpty
        ? res.map((el) => ProcessLearning.fromMap(el)).toList()
        : [];
    return result;
  }

  /// Метод получения всех `открытых` процессов по данному курсу `вне зависимости от даты`,
  /// не показываются процессы типа `HEAD` и `LEARNING`
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  getAllRepeat(String courseID) async {
    final db = await DBUserDataProvider.db.database;
    List<Topic> topics = await RepositoryLocal().getTopics(courseID);
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE $COLUMN_END_DT = \'\''
        '   AND $COLUMN_UP_ID IS NOT NULL'
        '   AND $COLUMN_PROCESS_LEVEL NOT IN (0, 10)' // 10 - HEAD, 0 - LEARNING
        '   AND $COLUMN_TOPIC_ID IN ( ${_topicsToString(topics)} )'
        ' ORDER BY $COLUMN_PROCESS_LEVEL DESC'
        '');
    List<ProcessLearning> result = res.isNotEmpty
        ? res.map((el) => ProcessLearning.fromMap(el)).toList()
        : [];
    return result;
  }

  /// Метод получения всех `закрытых` процессов по данному курсу
  /// не показываются процессы типа `HEAD`
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  getAllEndedRepeat(String courseID) async {
    final db = await DBUserDataProvider.db.database;
    List<Topic> topics = await RepositoryLocal().getTopics(courseID);
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE $COLUMN_END_DT <> \'\''
        '   AND $COLUMN_UP_ID IS NULL'
        '   AND $COLUMN_PROCESS_LEVEL = 10' // 10 - HEAD, 0 - LEARNING
        '   AND $COLUMN_TOPIC_ID IN ( ${_topicsToString(topics)} )'
        '');
    List<ProcessLearning> result = res.isNotEmpty
        ? res.map((el) => ProcessLearning.fromMap(el)).toList()
        : [];
    return result;
  }

  /// Метод получения количества слов `изученных за все время` по выбранному курсу
  /// (не считая сброшенный прогресс)
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  getWordSizeLearned(String courseID) async {
    int result = 0;
    List<ProcessLearning> process = await getAllEndedRepeat(courseID);
    for (int i = 0; i < process.length; i++) {
      int topicWordSize =
          await RepositoryLocal().getCountCardsInTopic(process[i].topicID);
      result += topicWordSize;
    }
    return result;
  }

  /// Метод получения количества слов `в процессе обучения` по выбранному курсу
  ///
  /// [courseID] - Идентификатор курса, по которому необходимо получить все доступные процессы.
  getWordSizeInProcess(String courseID) async {
    int result = 0;
    List<ProcessLearning> process = await getAllRepeat(courseID);
    for (int i = 0; i < process.length; i++) {
      int topicWordSize =
          await RepositoryLocal().getCountCardsInTopic(process[i].topicID);
      result += topicWordSize;
    }
    return result;
  }

  /// Приматный метод для перевода списка тем в строку перечисления идентификаторов тем
  /// используется для получения процессов по идентификаторам данных тем.
  /// Таблицы используются разные, по этому используется данный метод.
  String _topicsToString(List<Topic> list) {
    String result = '';
    for (Topic topic in list) {
      result += '\'${topic.uid}\', ';
    }
    if (result.length > 0) result = result.substring(0, result.length - 2);

    return result;
  }
}
