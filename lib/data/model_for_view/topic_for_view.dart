import 'package:flutter/material.dart';

import './../dao/card_dao.dart';
import './../models/process_learning.dart';
import './../models/topic.dart';
import './../../utils/enums.dart';

/// [TopicForView] - Вспомогательный класс модель для отображения тем в листах и перечислениях
///
/// поля:
///
/// [uid] - Идентификатор
///
/// [title] - Название темы
///
/// [type] - Тип темы
///
/// [parentID] - Родитель темы
///
/// [description] - Описание темы
///
/// [isCheck] - Испозуется у Тем типа GROUP, от него зависит, раскрыта группа или нет.
///
/// [countWords] - Хранит в себе количество слов в теме.
///
/// [process] - Процесс по данной теме.
///
class TopicForView {
  final String uid;
  final String parentID;
  final String title;
  final String description;
  bool isCheck;
  final int countWords;
  TopicType type;
  ProcessLearning process;

  int cardViewPosition;

  Icon notification;

  TopicForView({
      @required this.uid,
      @required this.title,
      @required this.type,
      @required this.parentID,
      this.description = '',
      this.isCheck = false,
      this.countWords = 0,
      this.process,
      this.cardViewPosition = 0,
    });

  static Future<TopicForView> topicConstructor(
      Topic topic, TopicType type) async {
    return TopicForView(
      uid: topic.uid,
      parentID: topic.upID,
      title: topic.name,
      type: type,
      countWords: await CardDAO().getCountCardsInTopic(topic.uid),
      description: 'description', // Избыточно
      isCheck: false,
    );
  }
}
