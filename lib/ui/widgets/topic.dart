import 'package:aseforenglish/utils/constants.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:flutter/material.dart';

/// Виджет отображения нижней части AppBar и отображения названия текущего курса.
///
/// Входит в компонент `AseSliverAppBar`
/// Используется на текущий момент на экранах `CourseMain` и `CalendarScreen`
///
/// Служит для отображения названия курса на данных экранах,
/// при прокрутке экрана скрывается.
class TopicTitleCourse extends StatelessWidget {
  final String title;
  final String description;
  final Function onPressed;

  TopicTitleCourse({
    @required this.title,
    @required this.onPressed,
    this.description = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: 65.0,
        color: kGreyBackground,
        child: Padding(
          padding: EdgeInsets.only(
            left: 24.0,
            top: 8.0,
            right: 12.0,
            bottom: 8.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${title.length <= 31 ? '$title' : '${title.substring(0, 30)}...'}',
                      style: kSFProR_Black_18_Bold,
                    ),
                    Text(
                      description,
                      style: kSFProR_Black_14,
                    ),
                  ],
                ),
              ),
              // ---------------------------------------------------------------
              // TODO иконка отображения информации по экрану.
              //      При реализации, заменить `SizedBox` на `IconButton`
              //      При нажатии на эту эконку, должна показываться информация по страницк
              SizedBox(
                height: 24,
                width: 24,
              ),
              // IconButton(
              //   icon: Icon(Icons.info_outline, size: 24.0, color: Colors.blue),
              //   onPressed: onPressed,
              // ),
              // ---------------------------------------------------------------
            ],
          ),
        ),
      ),
    );
  }
}

/// Виджет отобрадения элементов в нутри списка на экране `CourseMainScreen`
///
/// В зависимости от `type` отображаем `_groupWidget` или `_topicWidget`
class TopicItemList extends StatelessWidget {
  final String title;
  final int wordSize;
  final TopicType type;
  final Function onPressed;

  TopicItemList({
    @required this.title,
    @required this.wordSize,
    @required this.type,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: type == TopicType.TOPIC ||
              type == TopicType.TOPIC_LAST ||
              type == TopicType.TOPIC_REPEAT
          ? _topicWidget(title, wordSize, type, onPressed)
          : _groupWidget(title, type, onPressed),
    );
  }
}

/// Воджет отоюражающий Группы Тем, в списке
///
/// Может находиться в активном состоянии а так же в неактиыном (спасибо Кэп!)
Widget _groupWidget(
  String title,
  TopicType type,
  Function onPressed,
) {
  return FlatButton(
    padding: EdgeInsets.all(0.0),
    onPressed: onPressed,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 3.0,
      ),
      color: kBlueBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'SFPro-Regular',
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              width: 24.0,
            ),
            SizedBox(
              width: 24.0,
            ),
            Icon(
              type == TopicType.GROUP_CLOSE
                  ? Icons.chevron_right
                  : Icons.keyboard_arrow_down,
              size: 24.0,
              color: kIconGreyColor,
            )
          ],
        ),
      ),
    ),
  );
}

/// Воджет отоюражающий темы на изучение, в списке
///
/// В зависимости от type отображаем бэкграунд последнего открытого курса (если на бэк нажмем)
Widget _topicWidget(
  String title,
  int wordSize,
  TopicType type,
  Function onPressed,
) {
  return FlatButton(
    padding: EdgeInsets.all(0.0),
    onPressed: onPressed,
    child: Container(
      color: type == TopicType.TOPIC || type == TopicType.TOPIC_REPEAT
          ? kAppBarColor
          : kStandartYellowColor20,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: type != TopicType.TOPIC_REPEAT
                              ? Colors.black
                              : Colors.grey[400],
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: type != TopicType.TOPIC_REPEAT
                              ? Colors.grey[500]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          wordSize.toString(),
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                // Icon(Icons.notifications_none, size: 33.0, cть на Катеную картинку....
              ],
            ),
          ),
          Container(
            height: 1.0,
            width: double.infinity,
            color: Color(0xFFC8C7CC),
          ),
        ],
      ),
    ),
  );
}
