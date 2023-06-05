
import 'dart:math';

import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:flutter/material.dart';
import './../data/models/card.dart' as c;


/// Хранит в себе все доступные идентификаторы приложения.
List<String> tmpRandomList = List<String>();

/// Метод получающий все идентификаторы системы, для того что бы не было шанса
/// получить не уникальный идентификатор и упасть с ошибкой.
Future initRandomList() async {
  var audits = await RepositoryLocal().getAudits();
  if (audits != null) {
    audits.map((audit) => tmpRandomList.add(audit.uid));
  }
  var process = await RepositoryLocal().getAllProcess();
  if (process != null) {
    process.map((proc) => tmpRandomList.add(proc.uid));
  }
}

/// Метод получения рандомного идентификаотора, для создания записей в Таблицах Базы данных.
/// В основном данный метод нужен для таблиц [Audit] и [Process]
/// остальные таблици не добавляются в приложении
///
/// [prefix] - необходимый префикс, для уникальности идентификаторов, описанны в константах
///
/// Audit - 9999;
/// Course - 1000;
/// Topic - 2000;
/// Cards - 3000;
/// Incorrects - 3100;
/// Sourse - 3200;
/// Process - 5000;
String getRandomUID(String prefix) {
  String random;
  while (true) {
    random = '$prefix${Random().nextInt(1000000000) + 1000000000}';
    if (!tmpRandomList.contains(random)) {
      tmpRandomList.add(random);
      break;
    }
  }
  return random;
}

/// Метод получения рандомного цвета.
Color getRandomColor() {
  return Color.fromARGB(
    150,
    Random().nextInt(175),
    Random().nextInt(175),
    Random().nextInt(175),
  );
}

/// Идея данного метода, получить масив из двух цифр, Данные цифры являются индексами
/// уникальных, не верных значений для копок выбора.
void putUnuqueRandomNumber(List<int> list, int lenght) {
  while (true) {
    int number = Random().nextInt(lenght);
    if (list.contains(number)) continue;
    list.add(number);
    break;
  }
}

/// По идее при прогрузке CardForProcces получает лист Остальных карточек для получения не верных вариантов
/// Данным методом, получаем рандомно, уникальное значение для неверных вариантов.
/// При выбросе неверного ванианта, мы выбрасываем "избранного" из доступных ариантов
String getRandomIncorrextString(List<c.Card> list, Mechanics mechanics) {
  int position = Random().nextInt(list.length);
  String result = mechanics == Mechanics.M1
      ? list[position].translate // Механика 1
      : list[position].word; // Механика 2
  list.remove(list[position]);
  return result;
}

