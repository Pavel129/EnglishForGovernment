import 'package:aseforenglish/data/models/audit.dart';
import 'package:aseforenglish/data/models/course.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/calendar_screen.dart';
import 'package:aseforenglish/ui/screen/course_main_screen.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



/// Домашняя страница курса.
class CourseHomeScreen extends StatefulWidget {
  static final String id = 'course_home_screen';

  @override
  _CourseHomeScreenState createState() => _CourseHomeScreenState();
}

class _CourseHomeScreenState extends State<CourseHomeScreen> {
  Course course;
  String title = '';
  int learnCount = 0;
  int processCount = 0;
  int repeatCount = 0;

  @override
  void initState() {
    changeData();
    super.initState();
  }

  void changeData() async {
    Audit audit = await RepositoryLocal().getLastAuth();
    if (audit != null) {
      Course tmpCourse = await RepositoryLocal().getCourse(audit.courseID);

      int tmplearnCount =
          await RepositoryLocal().getWordSizeLearned(tmpCourse.uid);
      int tmpProcessCount =
          await RepositoryLocal().getWordSizeInProcess(tmpCourse.uid);

      var repeats = await RepositoryLocal().getPrevRepeats(tmpCourse.uid);

      setState(() {
        title = tmpCourse.name;
        learnCount = tmplearnCount;
        processCount = tmpProcessCount;
        repeatCount = repeats.length;
      });
    }
  }

  // Тут грабля, надо исправлять
  void getNavigationButton(bool isRepeat) {
    Navigator.pushNamed(
      context,
      isRepeat ? CalendarScreen.id : CourseMainScreen.id,
      arguments: course,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AseAppBarMinimum(title: 'Изучение'),
          body: Column(
            children: <Widget>[
              Expanded(
                child: getCourseHomePage(
                  context,
                  title,
                  learnCount,
                  processCount,
                  repeatCount,
                ),
              ),
              BottomMenu(
                selectItemNumber: MenuItemPosition.LEARN,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getCourseHomePage(
  BuildContext context,
  String title,
  int learnedCount,
  int inProgresCount,
  int repeatCount,
) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(kBkgImgCourseHome),
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    ),
    child: Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Вы изучаете курс',
            style: kSFProR_White_16,
          ),
          Text(
            title,
            style: kSFProR_White_34_Bold,
            textAlign: TextAlign.center,
          ),
          Text(
            'Upper Intermediate',
            style: kSFProR_White_16,
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getCircleProgress(
                  learnedCount.toString(),
                  'слов' '\n' 'изучено',
                  kImgCircleLearned,
                ),
                getCircleProgress(
                  inProgresCount.toString(),
                  'слов на' '\n' 'изучение',
                  kImgCircleRepeat,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            'Каков ваш план на сегодня?',
            style: kSFProR_White_16,
          ),
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                getHomeButton(
                  context,
                  'Изучать',
                  'новое',
                  Container(),
                  0,
                  () => Navigator.pushNamed(context, CourseMainScreen.id),
                  false,
                ),
                SizedBox(
                  width: 16.0,
                ),
                getHomeButton(
                    context,
                    'Повторять',
                    'пройденое',
                    // --------------------------------------
                    //TODO Заменить эту гадость, чем-то более нормальным.
                    repeatCount == 0
                        ? Container()
                        : Container(
                            padding: EdgeInsets.all(8.0),
                            alignment: Alignment.topRight,
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  width: 35.0,
                                  height: 35.0,
                                  child: Icon(
                                    Icons.notifications_none,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  repeatCount.toString(),
                                  style: TextStyle(color: Colors.orange),
                                ),
                              ],
                            ),
                          ),
                    // --------------------------------------
                    0,
                    () => Navigator.pushNamed(context, CalendarScreen.id),
                    true),
              ],
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            'Если у Вас есть темы на повторении,\n'
            'рекомендуем начать именно с них.',
            style: kSFProR_White_16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget getCircleProgress(String count, String title, String imageSource) {
  return Container(
    height: 145.0,
    width: 145.0,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(imageSource),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              count,
              style: TextStyle(
                fontSize: 52.0,
                color: Colors.white,
              ),
            ),
            Text(title, textAlign: TextAlign.center, style: kSFProR_White_16),
          ],
        ),
      ],
    ),
  );
}

Widget getHomeButton(
  BuildContext context,
  String title,
  String description,
  Container image,
  int repeatNumber,
  Function onPressed,
  bool isRepeat,
) {
  // void checkPhessed() {
  //   Navigator.pushNamed(
  //       context, isRepeat ? CalendarScreen.id : CourseMainScreen.id, arguments: course);
  // }

  return Container(
    height: 150.0,
    width: 160.0,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      border: Border.all(width: 1.0, color: Color(0xFF5AABFD)),
    ),
    // margin: EdgeInsets.symmetric(horizontal: 16.0),
    child: FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: onPressed,
      child: Stack(
        children: [
          image,
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: isRepeat ? Colors.red : Colors.green),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
