import 'dart:convert';

import './../../data/databases/db_content.dart';
import './../../data/models/card.dart';

/// [CardDAO] - класс для получения данных типа Card из базы данных.
class CardDAO {
  static const String TABLE_NAME = 'cards';
  static const String COLUMN_UID = 'uid';
  static const String COLUMN_WORD = 'word';
  static const String COLUMN_TOPIC_ID = 'topic_id';
  static const String COLUMN_POSITION = 'position';
  static const String COLUMN_TRANSLATE = 'translate';
  static const String COLUMN_TRANSCRIPTION = 'transcription';
  static const String COLUMN_DESCRIPTION = 'description';

  static Card cardsFromJson(String str) {
    final jsonData = json.decode(str);
    return Card.fromMap(jsonData);
  }

  static String cardsToJson(Card data) {
    final dyn = data.toMap();
    return json.encode(dyn);
  }

  /// Добавление Карточки в таблицу базы данных, на данный момент избыточно,
  /// но в дальнейшем потребуется.
  ///
  /// [card] - Объект типа Card, который нужно записать в таблицу.
  insert(Card card) async {
    final db = await DBContentProvider.db.database;
    var res = await db.insert(TABLE_NAME, card.toMap());
    return res;
  }

  /// Получить конкретную карточку по идентификатору
  ///
  /// [uid] - идентифификатор необходимой записи из базы данных.
  getCard(String uid) async {
    final db = await DBContentProvider.db.database;
    var res =
        await db.query(TABLE_NAME, where: '$COLUMN_UID = ?', whereArgs: [uid]);
    Card result = res.isNotEmpty ? Card.fromMap(res.first) : null;
    return result;
  }

  /// Получить все карточи топика ио идентификатору.
  ///
  /// [topicID] - идентификатор топика, по которуму делается выборка из таблицы базы данных.
  getAllCardsTopic(String topicID) async {
    final db = await DBContentProvider.db.database;
    var res = await db
        .query(TABLE_NAME, where: '$COLUMN_TOPIC_ID = ?', whereArgs: [topicID]);
    List<Card> list =
        res.isNotEmpty ? res.map((el) => Card.fromMap(el)).toList() : [];
    return list;
  }

  findCards(String likeWord) async {
    final db = await DBContentProvider.db.database;
    var res = await db.rawQuery(
      'SELECT *'
      '  FROM $TABLE_NAME'
      ' WHERE $COLUMN_WORD like \'%$likeWord%\''
    );
    List<Card> list =
    res.isNotEmpty ? res.map((el) => Card.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить варианты не верных ответов слов для механик М1 и М2
  ///
  /// [cardID] - идентификатор слова, к которому необходимо подобрать неверные варианты ответов.
  getIncorrectCards(String cardID) async {
    final db = await DBContentProvider.db.database;
    var res = await db.rawQuery(''
        'SELECT *'
        '  FROM $TABLE_NAME'
        ' WHERE $COLUMN_UID <> \'$cardID\''
        '   AND $COLUMN_TOPIC_ID IN (SELECT $COLUMN_TOPIC_ID'
        '                              FROM $TABLE_NAME'
        '                             WHERE $COLUMN_UID = \'$cardID\')');
    var list = res.isNotEmpty ? res.map((el) => Card.fromMap(el)).toList() : [];
    return list;
  }

  /// Получить количество слов в калоде по текущей теме.
  ///
  /// [topicID] - идентификатор темы, для которой необходимо получить количество
  /// слов в калоде данной темы
  getCountCardsInTopic(String topicID) async {
    List<Card> list = await getAllCardsTopic(topicID);
    return list.length;
  }
}
