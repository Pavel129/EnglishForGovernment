import 'package:aseforenglish/data/model_for_view/topic_for_view.dart';
import 'package:aseforenglish/data/models/audit.dart';
import 'package:aseforenglish/data/models/course.dart';
import 'package:aseforenglish/data/models/process_learning.dart';
import 'package:aseforenglish/data/models/topic.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/card_screen.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/ui/widgets/topic.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:flutter/material.dart';



/// Экран отображения выбора тем.
///
/// Тут отображается лист с виджемаи.
/// На текущий момент есть
/// 2а состоянии групп тем
/// 3и состояния самиъх тем.
///
/// Свернутая и развернутая группа (для отображения в листе)
/// Свернутая, не имеет потомков, стрелка смотрит в право
///
/// Развернутая, имеет под собой темы, наследники, и стрелка смотри в низ
///
/// Обычная тема - Которую пользователь, Пользователь ее не открывал,
///                или давно, Изучать не начинал
///       Просто отображаем
///
/// Тема, которую пользователь просмотрел недавно, и другой больше не открывал.
///                но изучение по ней не прошел
///       Отображаем с желтым фоном
///
/// Тема, которую пользователь изучил, и она попала на процесс повторения.
///       Отображаем серым
class CourseMainScreen extends StatefulWidget {
  static final String id = 'course_main_screen';

  CourseMainScreen({Key key}) : super(key: key);

  @override
  _CourseMainScreenState createState() => _CourseMainScreenState();
}

class _CourseMainScreenState extends State<CourseMainScreen> {
  final String _title = 'Изучение нового';

  static Course course;
  static TopicForView selectTopic;

  String courseTitle = '';
  String courseGrade = '';

  List<TopicForView> list = [];

  Future changeList() async {
    var audit = await RepositoryLocal().getLastAuth();
    course = await RepositoryLocal().getLastCourse();
    var tmplist = await RepositoryLocal().getParentTopics(course.uid);
    List<TopicForView> newList = [];

    for (Topic topic in tmplist) {
      var check = isDisclosed(topic);
      newList.add(await TopicForView.topicConstructor(
          topic, check ? TopicType.GROUP_OPEN : TopicType.GROUP_CLOSE));
      if (check) {
        var childsList =
            await RepositoryLocal().getParentTopicsChild(topic.uid);
        for (Topic chield in childsList) {
          var topicType = chield.uid == audit.topicID
              ? TopicType.TOPIC_LAST
              : TopicType.TOPIC;
          List<ProcessLearning> processList =
              await RepositoryLocal().getHeadProcess(topic.courseID);

          for (ProcessLearning proc in processList) {
            if (proc.topicID == chield.uid) topicType = TopicType.TOPIC_REPEAT;
          }

          newList.add(await TopicForView.topicConstructor(
            chield,
            topicType,
          ));
        }
      }
    }

    setState(() {
      courseTitle = course.name;
      courseGrade = course.grade;
      list = newList;
    });
  }

  isDisclosed(Topic topic) {
    return selectTopic != null && selectTopic.uid == topic.uid;
  }

  clickItem(TopicForView topic) => () async {
        if (topic.type == TopicType.TOPIC ||
            topic.type == TopicType.TOPIC_LAST ||
            topic.type == TopicType.TOPIC_REPEAT) {
          topic.type = TopicType.TOPIC_LAST;
          var lastAudit = await RepositoryLocal().getLastAuth();
          var newAudit = Audit(
            userID: lastAudit.userID,
            courseID: lastAudit.courseID,
            topicID: topic.uid,
          );
          await RepositoryLocal().insertAudit(newAudit);
          await changeList();
          Navigator.pushNamed(context, CardScreen.id, arguments: topic);
        } else {
          if (topic.type == TopicType.GROUP_CLOSE) {
            topic.type = TopicType.GROUP_OPEN;
            selectTopic = topic;
          } else {
            topic.type = TopicType.GROUP_CLOSE;
            selectTopic = null;
          }
          changeList();
        }
      };

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) changeList();
    return SafeArea(
      child: Material(
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
                return TopicItemList(
                  title: element.title,
                  wordSize: element.countWords,
                  type: element.type,
                  onPressed: clickItem(element),
                );
              },
              childCount: list.length,
            ))
          ],
        ),
      ),
    );
  }
}
