import 'package:aseforenglish/data/models/process_learning.dart';
import 'package:aseforenglish/data/models/topic.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/course_home_screen.dart';
import 'package:aseforenglish/ui/widgets/buttons.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:flutter/material.dart';



/// Экран результатов прохождения обучения.
///
/// не важно, "Изучение" это или "Повторение"
/// Но разница в их отображении есть. определяется ниже.
class ResultScreen extends StatefulWidget {
  static final String id = 'result_screen';

  const ResultScreen({Key key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Widget page = Container();
  ProcessLearning _process;

  bool isRepeat = false;

  @override
  void initState() {
    super.initState();
  }

  // По сути единственный вспомогательный метод, в котором полчаем все данные
  // и выкатываем в переменную page
  void getPage() async {
    RouteSettings settings = ModalRoute.of(context).settings;
    _process = settings.arguments;
    Topic topic = await RepositoryLocal().getTopic(_process.topicID);
    int wordSize =
        await RepositoryLocal().getCountCardsInTopic(_process.topicID);
    ProcessLearning nextProcess =
        await RepositoryLocal().getLastProcess(_process.topicID);
    Widget _page;
    bool _isRepeat = _process.processLevel != ProcessLevel.LEARNING;

    if (_isRepeat) {
      // Это отображается при Повторении
      _page = Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Поздравляем!',
              style: kSFProR_Blue_30_Bold,
            ),
            Text('Вы успешно повторили тему\n"${topic.name}"',
                textAlign: TextAlign.center, style: kSFProR_Blue_16),
            Container(
              height: 250.0,
              width: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(kImgCircleResult),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(wordSize.toString(), style: kSFProR_Blue_52),
                  Text('новых\nслов изучено',
                      textAlign: TextAlign.center, style: kSFProR_Blue_16),
                ],
              ),
            ),
            Text(
              'Повторите слова  еще несколько раз,\nи вы больше никогда их не забудете!',
              textAlign: TextAlign.center,
              style: kSFProR_Blue_16,
            ),
            Text(
              'Следующее повторение\n${nextProcess.startDT.toString().substring(0, 10)}.',
              style: kSFProR_Blue_16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      // Это отображается при Изучении
      _page = Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Поздравляем!',
              style: kSFProR_Blue_30_Bold,
            ),
            Container(
              height: 250.0,
              width: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(kImgCircleResult),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(wordSize.toString(), style: kSFProR_Blue_52),
                  Text('новых\nслов изучено',
                      textAlign: TextAlign.center, style: kSFProR_Blue_16),
                ],
              ),
            ),
            Text(
              'Повторите слова 7 раз, и вы больше\nникогда их не забудете!',
              textAlign: TextAlign.center,
              style: kSFProR_Blue_16,
            ),
            Text('Следующее повторение завтра.', style: kSFProR_Blue_16),
          ],
        ),
      );
    }

    setState(() {
      page = _page;
      isRepeat = _isRepeat;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_process == null) getPage();
    return Container(
      child: Material(
        child: SafeArea(
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(kBkgImgResScreen),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: page,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: AseStandartButton(
                      title: 'На главную',
                      onClick: () =>
                          Navigator.pushNamed(context, CourseHomeScreen.id),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
