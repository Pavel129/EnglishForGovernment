// topic.dart
import 'package:flutter/material.dart';

import './../dao/topic_dao.dart';
import './../../utils/constants.dart';
import './../../utils/ase_random.dart';

/// [Topic] - Класс по хранению данных по темам.
///
/// Fргументы:
///
/// [uid] - Идентификатор записи
///
/// [name] - Обязательное поле. Хранит в себе название темы.
///
/// [upID] - Для вормирования вложенности отображения Тем на странице выбора темы.
/// На текущий момент используется 2х уровневая вложенность.
/// В последующем, возможно потребуется увеличивать эту вложенность до 3х или 4х уровней.
///
/// [courseID] - идентификатор курса
///
/// [position] - позиция записи при выгрузки списка тем в курсе.
class Topic {
  String uid;
  String name;
  String upID;
  String courseID;
  int position;

  Topic({
    this.uid,
    @required this.name,
    this.upID = '',
    this.courseID = '',
    this.position = 0,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixTopic);
  }

  factory Topic.fromMap(Map<String, dynamic> json) => new Topic(
        uid: json[TopicDAO.COLUMN_UID],
        name: json[TopicDAO.COLUMN_NAME],
        upID: json[TopicDAO.COLUMN_UP_ID],
        courseID: json[TopicDAO.COLUMN_COURSE_ID],
        position: json[TopicDAO.COLUMN_POSITION],
      );

  Map<String, dynamic> toMap() => {
        TopicDAO.COLUMN_UID: uid,
        TopicDAO.COLUMN_NAME: name,
        TopicDAO.COLUMN_UP_ID: upID,
        TopicDAO.COLUMN_COURSE_ID: courseID,
        TopicDAO.COLUMN_POSITION: position,
      };
}
