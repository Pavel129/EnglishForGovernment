import 'package:aseforenglish/data/models/audit.dart';
import 'package:aseforenglish/data/models/course.dart';
import 'package:aseforenglish/data/models/user.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/course_home_screen.dart';
import 'package:aseforenglish/ui/screen/course_main_screen.dart';
import 'package:aseforenglish/ui/widgets/ase_progress_bar.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';

/// Клас отображения элемента списка курсов, на экране выбора курса.
///
/// [course] - Обязательно передаем сам курс.
///
/// [user] - обязательно передаем пользвователя, для записи его в аудит.
class CourseListItemWidget extends StatefulWidget {
  final Course course;
  final User user;
  final String imageCourse;

  const CourseListItemWidget(
      {Key key,
      @required this.course,
      @required this.user,
      @required this.imageCourse})
      : super(key: key);

  @override
  _CourseListItemWidgetState createState() => _CourseListItemWidgetState();
}

class _CourseListItemWidgetState extends State<CourseListItemWidget> {
  int wordSize = 0;
  double inProsesParcent = 0.0;
  double leardedParcent = 0.0;

  bool isFirstEnter = true;

  @override
  void initState() {
    super.initState();
    getWordSize();
  }

  void getWordSize() async {
    String courseID = widget.course.uid;
    int size = await RepositoryLocal().getWordSizeInCourse(courseID);
    int inProgresSize = await RepositoryLocal().getWordSizeInProcess(courseID);
    int learnedSize = await RepositoryLocal().getWordSizeLearned(courseID);

    double tmpInProsesParcent = (inProgresSize / (size / 100)) / 100;
    double tmpLeardedParcent = (learnedSize / (size / 100)) / 100;
    setState(() {
      isFirstEnter = inProgresSize == 0 && learnedSize == 0;
      wordSize = size;
      inProsesParcent = tmpInProsesParcent;
      leardedParcent = tmpLeardedParcent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
        ),
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          onPressed: () async {
            var tmp = await RepositoryLocal().getLastAuth();
            Audit audit = Audit(
              userID: widget.user.login,
              courseID: widget.course.uid,
              topicID: tmp.topicID,
            );
            await RepositoryLocal().insertAudit(audit);
            Navigator.pushNamed(
              context,
              isFirstEnter ? CourseMainScreen.id : CourseHomeScreen.id,
              arguments: widget.course,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    child: Image.asset(
                      widget.imageCourse,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          wordSize.toString(),
                          style: kSFProR_White_34_Bold,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'слов и выражений',
                          style: kSFProR_White_16,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    padding: EdgeInsets.all(18.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(230, 255, 255, 255),
                          Color.fromARGB(230, 255, 255, 255),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: <Widget>[
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.ideographic,
                            children: <Widget>[
                              Text(
                                '${widget.course.name.length < 50 ? widget.course.name : widget.course.name.substring(0, 50) + '...'}',
                                style: kSFProR_Black_18_Bold,
                              ),
                              Text(
                                '${widget.course.grade}',
                                style: kSFProR_Black_14,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        aseProgresBar(
                            context: context,
                            progres: leardedParcent,
                            secondaryProgres: inProsesParcent),
                        Text(
                          'Вы продвигаетесь',
                          style: kSFProR_Grey_14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
