import 'package:aseforenglish/data/models/audit.dart';
import 'package:aseforenglish/data/models/course.dart';
import 'package:aseforenglish/data/models/user.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/ui/widgets/course_view.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



/// Страница отображения Каталога
class CatalogScreen extends StatefulWidget {
  static final String id = 'catalog_screen';
  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}
List<String> coursesImage = [
  gradientDarkBlue,
  gradientOrange,
  gradientViolet,
  gradientBlue
];

class _CatalogScreenState extends State<CatalogScreen> {
  List<Course> list = [];
  Course lastCourse;
  User user;

  // Получаем данные из таблицы Курсов.
  void setList() async {
    var tmpList = await RepositoryLocal().getAllCourse();
    Audit tmpAudit = await RepositoryLocal().getLastAuth();
    Course tmpCourse = await RepositoryLocal().getCourse(tmpAudit.courseID);
    User tmpUser = await RepositoryLocal().getUser(tmpAudit.userID);

    setState(() {
      lastCourse = tmpCourse;
      user = tmpUser;
      list = tmpList;
    });
  }
  
  @override
  void initState() {
    super.initState();
    setList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AseAppBarMinimum(title: 'Курсы'),
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: kCatalogBackgroundColor,
                  padding: EdgeInsets.symmetric(horizontal: 40.0,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: list.length,
                          padding: EdgeInsets.all(0),
                          itemBuilder: (BuildContext context, int index) {
                            var course = list[index];
                            var courseImage = coursesImage[index];
                            return CourseListItemWidget(course: course, user: user, imageCourse: courseImage);
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomMenu(selectItemNumber: MenuItemPosition.COURSE, context: context,),
            ],
          ),
        ),
      ),
    );
  }
}
