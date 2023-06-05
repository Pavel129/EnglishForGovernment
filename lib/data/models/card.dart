// card.dart
import 'package:flutter/material.dart';

import './../dao/card_dao.dart';
import './../../utils/constants.dart';
import './../../utils/ase_random.dart';

/// [Card] - Класс по работе с карточками. Ъранит в себе всю необходимую информацию для каточек.
///
/// [word] - Обязательное поле. Хранит в себе слово на английском.
///
/// [topicID] - Обязательное поле. Хранит в себе идентификатор родительской темы
///
/// [translate] - Обязательное поле. Хранит в себе перевод слова
///
/// [transcription] - Хранит в себе транскрипцию слова
///
/// [description] - Хранит в себе описание\комментарий слова
///
/// [position] - Позиция слова в калоде от 0 до МНОГО.
///
class Card {
  String uid;
  String word;
  String topicID;
  String translate;
  String transcription;
  String description;
  int position;

  Card({
    this.uid,
    @required this.word,
    @required this.topicID,
    @required this.translate,
    this.transcription = '',
    this.description = '',
    this.position = 0,
  }) {
    if (uid == null) uid = getRandomUID(kPrefixCards);
  }

  factory Card.fromMap(Map<String, dynamic> json) => new Card(
        uid: json[CardDAO.COLUMN_UID],
        word: json[CardDAO.COLUMN_WORD],
        topicID: json[CardDAO.COLUMN_TOPIC_ID],
        position: json[CardDAO.COLUMN_POSITION],
        translate: json[CardDAO.COLUMN_TRANSLATE],
        transcription: json[CardDAO.COLUMN_TRANSCRIPTION],
        description: json[CardDAO.COLUMN_DESCRIPTION],
      );

  Map<String, dynamic> toMap() => {
        CardDAO.COLUMN_UID: uid,
        CardDAO.COLUMN_WORD: word,
        CardDAO.COLUMN_TOPIC_ID: topicID,
        CardDAO.COLUMN_POSITION: position,
        CardDAO.COLUMN_TRANSLATE: translate,
        CardDAO.COLUMN_TRANSCRIPTION: transcription,
        CardDAO.COLUMN_DESCRIPTION: description,
      };
}
