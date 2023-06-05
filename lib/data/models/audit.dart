// audit.dart
import 'package:flutter/material.dart';

import '../dao/audit_dao.dart' as dao;
import './../../utils/constants.dart';
import './../../utils/ase_random.dart';

/// [Audit] - Класс по работе с аудитом действий пользователя.
///
/// - Позволяет определить, авторизовывался ли пользователь в приложении
/// - Позволяет определить, какой последний курс открывал пользователь.
/// - Так же данный класс можно расширять для хранения какой-либо информации по действиям пользователя.
///
/// [userID] - Обязательный пареметр для заполнения. Хранит в себе логин пользователя.
///
/// [topicID] - Хранит в себе идентификатор последнего открытой темы.
///
/// [courseID] - Обязательный пареметр для заполнения. Хранит в себе идентификатор курса.
///
/// [uid] - Идентификатор записи, подбирается автоматически.
///
/// [startDT] - Хранит в себе дату создания данного аудита.
///
/// [endDT] - На текущий момент играет роль такую же как и [startDT], в дальнейшем можно его использовать для разных целей.
class Audit {
  String uid;
  String userID;
  String topicID;
  String courseID;
  DateTime startDT;
  DateTime endDT;

  Audit({
    this.uid,
    @required this.userID,
    this.topicID = '',
    @required this.courseID,
    this.startDT,
    this.endDT,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixAudit);
    startDT = DateTime.now();
    endDT = DateTime.now();
  }

  factory Audit.fromMap(Map<String, dynamic> json) => new Audit(
        uid: json[dao.AuditDAO.COLUMN_UID],
        userID: json[dao.AuditDAO.COLUMN_USER_ID],
        topicID: json[dao.AuditDAO.COLUMN_TOPIC_ID],
        courseID: json[dao.AuditDAO.COLUMN_COURSE_ID],
        startDT: DateTime.parse(json[dao.AuditDAO.COLUMN_START_DT]),
        endDT: DateTime.parse(json[dao.AuditDAO.COLUMN_END_DT]),
      );

  Map<String, dynamic> toMap() => {
        dao.AuditDAO.COLUMN_UID: uid,
        dao.AuditDAO.COLUMN_USER_ID: userID,
        dao.AuditDAO.COLUMN_TOPIC_ID: topicID,
        dao.AuditDAO.COLUMN_COURSE_ID: courseID,
        dao.AuditDAO.COLUMN_START_DT: startDT.toString(),
        dao.AuditDAO.COLUMN_END_DT: endDT.toString(),
      };
}
