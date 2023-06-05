// incorrect.dart
import 'package:flutter/material.dart';

import './../dao/incorrect_dao.dart';
import './../../utils/constants.dart';
import './../../utils/ase_random.dart';

/// [Incorrect] - кдасс для хранения данных по не заранее заведенным не верным вариантам.
/// Если слов заранее не заведено, то отображать в качестве не верных вариантов слова из калоды.
///
/// поля:
///
/// [uid] - Идентификатор записи, для каждой записи идентификатор в системе задан при составлении контента
///
/// [value] - Обязательное поле. Значение, хранить в виде перечисления с сепаратором `;`
///
/// [type] - Обязательное поле. Тип не верных вариантов ответов, могут быть как Переводы. так и не верные слова.
///
/// [parentID] - Обязательное поле. Идентификатор родителя, к которому относятся данные не верные варианты ответов.
///
class Incorrect {
  String uid;
  String value;
  String type;
  String parentID;

  Incorrect({
    this.uid,
    @required this.value,
    @required this.type,
    @required this.parentID,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixIncorrects);
  }

  factory Incorrect.fromMap(Map<String, dynamic> json) => new Incorrect(
        uid: json[IncorrectDAO.COLUMN_UID],
        value: json[IncorrectDAO.COLUMN_VALUE],
        type: json[IncorrectDAO.COLUMN_TYPE],
        parentID: json[IncorrectDAO.COLUMN_PARENT_ID],
      );

  Map<String, dynamic> toMap() => {
        IncorrectDAO.COLUMN_UID: uid,
        IncorrectDAO.COLUMN_VALUE: value,
        IncorrectDAO.COLUMN_TYPE: type,
        IncorrectDAO.COLUMN_PARENT_ID: parentID,
      };
}
