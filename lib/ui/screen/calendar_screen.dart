import 'package:aseforenglish/data/model_for_view/topic_for_view.dart';
import 'package:aseforenglish/data/models/process_learning.dart';
import 'package:aseforenglish/data/models/topic.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/process_learning_screen.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:flutter/material.dart';



/// Экран отображения Календаря повторений.
///
/// Записи в данный экран попазают после прохождения первого шага процесса
/// обучения LEARNING, в дальнейшим пользователь должен работать с данным экраном.
class CalendarScreen extends StatefulWidget {
  static final String id = 'calendar_screen';

  const CalendarScreen({Key key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final String _title = 'Календарь повторений';

  final String _textLineFirst = 'Повторить сегодня';
  final String _textLineSecond = 'Запланированные повторения';

  // В данный лист записываются сами процессы повторения, так же другие
  // элементы интерфеса, если таки существуют.
  List<Widget> list = [];

  // Базовые переменные, которые отображаются на экране
  String courseTitle = '';
  String courseGrade = '';

  @override
  void initState() {
    setList();
    super.initState();
  }

  // Метод "сборки" нашего листа
  void setList() async {
    List<Widget> result = [];
    var lastCourse = await RepositoryLocal().getLastCourse();
    // Получаем все процессы прошедшей и текущей даты
    var prevProcessList =
        await RepositoryLocal().getPrevRepeats(lastCourse.uid);
    // Получаем процесс которые нужно будет повторять в будущем
    var nextProcessList =
        await RepositoryLocal().getNextRepeats(lastCourse.uid);

    if (prevProcessList.isNotEmpty) {
      // Добавляем плаху текущих повторений
      result.add(titleRow(_textLineFirst));
      // преобразовываем лист процессов в лист тем для представления
      List<TopicForView> topicsForView =
          await getTopicForViewList(prevProcessList);
      // Результат формируем в виджеты и добавляем в лист
      result.addAll(
        topicsForView.map(
          (topic) => CalendarItemList(
            onPress: () {
              Navigator.pushNamed(context, ProcessLearningScreen.id,
                  arguments: topic);
            },
            title: topic.title,
            date: '${topic.process.startDT}',
            wordSize: '${topic.countWords}',
            processLevel: topic.process.processLevel,
          ),
        ),
      );
    }

    if (nextProcessList.isNotEmpty) {
      // Добавляем плаху будущих повторений
      result.add(titleRow(_textLineSecond));
      // преобразовываем лист процессов в лист тем для представления
      List<TopicForView> topicsForView =
          await getTopicForViewList(nextProcessList);
      // Результат формируем в виджеты и добавляем в лист
      result.addAll(
        topicsForView.map(
          (topic) => CalendarItemList(
            onPress: null,
            title: topic.title,
            date: '${topic.process.startDT}',
            wordSize: '${topic.countWords}',
            processLevel: topic.process.processLevel,
          ),
        ),
      );
    }

    setState(() {
      courseTitle = lastCourse.name;
      courseGrade = lastCourse.grade;
      list = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: kGreyBackground,
        child: CustomScrollView(
          slivers: [
            // Отображение Названия курса в AppBar
            SliverPersistentHeader(
              delegate: AseSliverAppBar(
                title: _title,
                courseTitle: courseTitle,
                courseRang: courseGrade,
              ),
              pinned: true,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, int index) {
                var element = list[index];
                return element;
              },
              childCount: list.length,
            ))
          ],
        ),
      ),
    );
  }
}

/// Асинхронный метод способный переформировать лист Процессов в лист Тем для представления.
///
/// В основном нужно для получения информации которой нет в процессах
/// а именно названия Темы и количества слов в данной теме
///
/// Данная информация отображается в листе
///
/// [list] - соответственно лист процессов.
Future<List<TopicForView>> getTopicForViewList(
    List<ProcessLearning> list) async {
  List<TopicForView> topicsForView = [];
  for (int i = 0; i < list.length; i++) {
    ProcessLearning proc = list[i];
    Topic topic = await RepositoryLocal().getTopic(proc.topicID);
    int wordSize = await RepositoryLocal().getCountCardsInTopic(proc.topicID);
    topicsForView.add(
      TopicForView(
        uid: topic.uid,
        title: topic.name,
        type: TopicType.TOPIC,
        parentID: topic.upID,
        process: proc,
        countWords: wordSize,
      ),
    );
  }
  return topicsForView;
}

/// Виджет для отображения плашек в листе
/// "Запланированые повторения" и "Повторить сегодня"
///
/// [title] - текстовое поле
Widget titleRow(String title) {
  return Container(
    width: double.infinity,
    color: kGreyBackground,
    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    child: Text(
      title,
      textAlign: TextAlign.start,
      style: kSFProR_Grey_14,
    ),
  );
}

/// Виджет отображения элеменотв списка повторений
///
/// [title] - Название темы
///
/// [date] - Дата повторения
///
/// [wordSize] - Количество слов в теме
///
/// [processLevel] - позиция в процессе повторения
///
/// [onPress] - Функция отработки нажатия
///
class CalendarItemList extends StatelessWidget {
  final String title;
  final String date;
  final String wordSize;
  final ProcessLevel processLevel;

  final Function onPress;

  CalendarItemList({
    @required this.title,
    @required this.date,
    @required this.wordSize,
    @required this.processLevel,
    @required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: onPress,
      child: Container(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
              color: kWhite100,
              border: Border.all(
                color: kGreyBackground,
                width: 0.5,
              )),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '$title',
                      style: kSFProR_Black_18,
                    ),
                    Row(
                      children: <Widget>[
                        //TODO тут в если задание просрочено, то подсвечиваем красным.
                        Text(
                          date.substring(0, 10),
                          style: kSFProR_Black_14,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.0,
                            vertical: 0.5,
                          ),
                          decoration: BoxDecoration(
                            color: kWordSizeBasckground,
                            borderRadius: BorderRadius.all(
                              Radius.circular(9.0),
                            ),
                          ),
                          child: Text(
                            wordSize,
                            style: kSFProR_White_16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${getProcessLevelToInt(processLevel)} из 7',
                style: kSFProR_Grey_14,
              ),
              Icon(
                Icons.chevron_right,
                size: 24.0,
                color: kWordSizeBasckground,
              )
            ],
          ),
        ),
      ),
    );
  }
}
