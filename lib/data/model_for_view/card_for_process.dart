import 'package:flutter/material.dart' as m;

import './../models/card.dart';
import './../../utils/enums.dart';

/// [CardForProcess] - Вспомогательный класс модель для отображения Карточек в списках и листалках
/// так же данный класс помогает процессу обучения, для формироавния определенной "кучи"
/// имеющей последовательность, от "первого" до "последнего" и "текущей" позицей
///
/// поля:
///
/// [card] - Оригинальная модель карточки.
///
/// [nextCard] - Ссылка на следующую карточку в колоде.
///
/// [prevCard] - Ссылка на предыдущую карту в калоде.
///
/// [mechanic] - Текущая механика, которую необходимо обрабатывать в процессе
/// обучения, при отображении карты
///
class CardForProcess {
  /// Текущая выбранная карточка в колоде во время процесса обучения
  static CardForProcess currendCard;

  /// Первая карточка в колоде во время процесса обучения
  static CardForProcess firstCard;

  /// Последняя карточка в колоде во время процесса обучения
  static CardForProcess lastCard;


  Card card;
  CardForProcess nextCard;
  CardForProcess prevCard;
  Mechanics mechanic;
  int result; // Верно, не верно, не было реакции
  // 1, -1, 0
  List<Card> incorrectCards =
      []; // Немного избыточно, так как используются перечисления описанные ниже
  List<String> incorrectWords = [];
  List<String> incorrectTranslate = [];
  String randowWordsM4; //выбор фразы для 4 механики

  CardForProcess({
    @m.required this.card,
    @m.required this.mechanic,
    this.result = 0,
  });

  /// Метод который необходимо вызывать при завершении процесса обучения, или выхода из него.
  /// Для безопастности, следует вызывать данный метод и при старте процесса обучения.
  /// для избежания непредвидимых ошибок.
  static void clearData() {
    currendCard = null;
    firstCard = null;
    lastCard = null;
  }
}
