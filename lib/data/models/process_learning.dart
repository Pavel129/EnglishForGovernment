import 'package:flutter/material.dart';

import './../dao/process_learning_dao.dart';
import './../../utils/ase_random.dart';
import './../../utils/constants.dart';
import './../../utils/enums.dart';

/// [ProcessLearning] - Класс для хранения процессов обуцения.
///
/// Параметры:
///
/// [uid] - уникальный идентификатор, подбирается уникальный идентификатор.
/// Смотри `lib \ util \ ase_rundom` метод `getRandomUID(String)`
///
/// [upID] - Идентификатор робительского процесса `HEAD`,
/// у процесса `HEAD` upID должен быть `пустой строкой`, но не `null`
///
/// [topicID] - Обязательный атрибут, содержит в себе идентификатор Темы,
/// по которой проходит процесс обучения
///
/// [userID] - Обязательный атрибут. собержит в себе идентификатор пользователя.
/// ЗЫ: Честно не знаю зачем, но если в дальнейшем у нас будет возможность выхода из приложения.
/// Данный параметр будет нужен.
///
/// [processLevel] - тип\уровень процесса,
/// может быть `HEAD`, `LEARNING` или `REPEAT_01` - `REPEAT_07`
/// описанны в перечислениях `lib \ util \ enums` enum `ProcessLevel`
/// Для хранения в БД переводятся в строковый вариант.
///
/// [progress] - в данное поле записывается строка с прогрессом пользователя.
///
/// [startDT] - Дата старта процесса. Для определенных шагов повторений, задается будущая дата.
/// интервалы описаны в `lib \ util \ enums` метод `getIntervalRepeat(processLevel)`
/// Интервалы задаются конкретно для процессов типа `REPEAT_01` - `REPEAT_07`
/// Для остальных процессов назначается текущее время.
///
/// [endDT] - по умолчанию дата завершения проставляется при завершении процесса.
/// у `HEAD` процесса данная дата проставляется при завершении `REPEAT_07`
///
class ProcessLearning {
  String uid;
  String upID;
  String topicID;
  String userID;
  String progress;
  ProcessLevel processLevel;
  DateTime startDT;
  DateTime endDT;

  ProcessLearning({
    this.uid,
    this.upID,
    @required this.topicID,
    @required this.userID,
    @required this.processLevel,
    this.progress = '',
    this.startDT,
    this.endDT,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixProcess);
    if (startDT == null) startDT = DateTime.now();
  }

  factory ProcessLearning.fromMap(Map<String, dynamic> json) {
    final startDT = json[ProcessLearningDAO.COLUMN_START_DT];
    final endDT = json[ProcessLearningDAO.COLUMN_END_DT];
    return new ProcessLearning(
      uid: json[ProcessLearningDAO.COLUMN_UID],
      upID: json[ProcessLearningDAO.COLUMN_UP_ID],
      topicID: json[ProcessLearningDAO.COLUMN_TOPIC_ID],
      userID: json[ProcessLearningDAO.COLUMN_USER_ID],
      progress: json[ProcessLearningDAO.COLUMN_PROGRESS],
      processLevel: getIntToProcessLevel(
        json[ProcessLearningDAO.COLUMN_PROCESS_LEVEL],
      ),
      startDT: startDT == '' ? null : DateTime.parse(startDT),
      endDT: endDT == '' ? null : DateTime.parse(endDT),
    );
  }

  Map<String, dynamic> toMap() => {
        ProcessLearningDAO.COLUMN_UID: uid,
        ProcessLearningDAO.COLUMN_UP_ID: upID,
        ProcessLearningDAO.COLUMN_TOPIC_ID: topicID,
        ProcessLearningDAO.COLUMN_USER_ID: userID,
        ProcessLearningDAO.COLUMN_PROGRESS: progress,
        ProcessLearningDAO.COLUMN_PROCESS_LEVEL:
            getProcessLevelToInt(processLevel),
        ProcessLearningDAO.COLUMN_START_DT:
            startDT == null ? '' : startDT.toString(),
        ProcessLearningDAO.COLUMN_END_DT: endDT == null ? '' : endDT.toString(),
      };
}
