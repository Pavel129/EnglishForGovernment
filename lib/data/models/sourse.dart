// sourse.dart
import 'package:flutter/material.dart';

import './../dao/sourse_dao.dart';
import './../../utils/constants.dart';
import './../../utils/ase_random.dart';

/// [Sourse] - кдасс для хранения ссылок на ресурсы
///
/// поля:
///
/// [uid] - Идентификатор записи, для каждой записи идентификатор в системе задан при составлении контента
///
/// [path] - Обязательное поле. Собственно ссылка на ресурс.
///
/// [type] - Обязательное поле. Тип ресурса AUDIO или IMAGE
/// AUDIO есть два типа ресурсов, для слова и для примечания.
///
/// [parentID] - Обязательное поле. Идентификатор родителя, к которому относятся данные
///
class Sourse {
  String uid;
  String path;
  String type;
  String parentID;

  Sourse({
    this.uid,
    @required this.path,
    @required this.type,
    @required this.parentID,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixSourse);
  }

  factory Sourse.fromMap(Map<String, dynamic> json) => new Sourse(
        uid: json[SourseDAO.COLUMN_UID],
        path: json[SourseDAO.COLUMN_PATH],
        type: json[SourseDAO.COLUMN_TYPE],
        parentID: json[SourseDAO.COLUMN_PARENT_ID],
      );

  Map<String, dynamic> toMap() => {
        SourseDAO.COLUMN_UID: uid,
        SourseDAO.COLUMN_PATH: path,
        SourseDAO.COLUMN_TYPE: type,
        SourseDAO.COLUMN_PARENT_ID: parentID,
      };
}
