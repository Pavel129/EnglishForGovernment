import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/bug_screen.dart';
import 'package:aseforenglish/ui/screen/catalog_screen.dart';
import 'package:aseforenglish/ui/screen/course_home_screen.dart';
import 'package:aseforenglish/ui/screen/find_screen.dart';
import 'package:aseforenglish/ui/screen/setting_screen.dart';
import 'package:aseforenglish/ui/widgets/topic.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';

// Обычный AppBar
class AseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;

  const AseAppBar({Key key, this.height = 125, @required this.title})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8.0,
          ),
          Row(
            children: [
              FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () => Navigator.pop(context),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.chevron_left,
                      size: 24.0,
                      color: Colors.blue,
                    ),
                    Text(
                      'Назад',
                      style: TextStyle(
                          fontFamily: 'SFPro-Regular',
                          fontSize: 18.0,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.search,
              //     size: 24.0,
              //     color: Colors.blue,
              //   ),
              //   onPressed: () {},
              // ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SFPro-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}

/// Позволяет отобразить AppBar + скрывающуюся область для отображения названия курса.
///
/// Используется на текущий момент на экранах `CourseMain` и `CalendarScreen`
class AseSliverAppBar extends SliverPersistentHeaderDelegate {
  final String title;
  final String courseTitle;
  final String courseRang;
  final double expandedHeight;
  final double height;
  final Function onHelpPressed;

  AseSliverAppBar({
    this.expandedHeight = 165,
    this.height = 100,
    @required this.title,
    @required this.courseTitle,
    @required this.courseRang,
    this.onHelpPressed,
  });

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            AseAppBar(title: title),
            Container(
              child: Opacity(
                opacity: (1 - shrinkOffset / expandedHeight),
                child: TopicTitleCourse(
                  title: courseTitle,
                  description: courseRang,
                  onPressed: onHelpPressed,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

// AppBar на минималках
class AseAppBarMinimum extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// Виджет AppBar, отображает Заголовок страницы + поиск
  ///
  /// Обязательный параметр title
  const AseAppBarMinimum({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: kAppBarColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SFPro-Regular',
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
                color: Colors.black,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 24.0,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pushNamed(context, FindScreen.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
// AppBar поисковик
class AseAppBarFinder extends StatelessWidget implements PreferredSizeWidget {

  final TextEditingController controller;

  const AseAppBarFinder({Key key, @required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: kAppBarColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 24.0,
            width: 24.0,
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.chevron_left, size: 24, color: kStandartBlueColor,),
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: TextField(
              controller: this.controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: kBlueBackgroundX50,
                border: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(9.0),
                  borderSide: BorderSide.none,
                ),

                hintText: 'Введите текст',
              ),
            ),
          ),
          SizedBox(width: 37.0),
          // FlatButton(
          //   onPressed: () {},
          //   child: Text(
          //     'Искать',
          //     style: kSFProR_Blue_18,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// ignore: must_be_immutable
class AseCardsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final audioStop;

  const AseCardsAppBar({Key key, @required this.title, this.audioStop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: kAppBarColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: kSFProR_Black_18_Bold,
          ),
          Row(
            children: [
              FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  if (audioStop != null) audioStop();
                  Navigator.pop(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.chevron_left,
                      size: 24.0,
                      color: Colors.blue,
                    ),
                    Text(
                      'Назад',
                      style: TextStyle(
                          fontFamily: 'SFPro-Regular',
                          fontSize: 18.0,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(),
              ),
              // IconButton(
              //   icon: ImageIcon(
              //     AssetImage('assets/images/icons/bug_light_blue.png'),
              //     size: 24.0,
              //     color: Colors.blue,
              //   ),
              //   onPressed: () {}, //TODO в будущем требуется реализовать поиск
              // ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// Нижнее меню
// ignore: must_be_immutable
class BottomMenu extends StatelessWidget {
  MenuItemPosition selectItemNumber;
  BuildContext context;

  /// Виджет для отображения нижнего меню, вставляем в конце страницы.
  ///
  /// [selectItemNumber] обязательный параметр, отвечает за отображение ативного пункта меню.
  /// [context] - обязательный парметр, отвечает за контекст приложения.
  BottomMenu({Key key, @required this.selectItemNumber, @required this.context})
      : super(key: key);

  var _icons = [
    AssetImage('assets/images/icons/learning.png'),
    AssetImage('assets/images/icons/course.png'),
    AssetImage('assets/images/icons/settings.png'),
    AssetImage('assets/images/icons/bug.png'),
    AssetImage('assets/images/icons/record.png'),
  ];

  var _titles = [
    'Изучение',
    'Курсы',
    'Настройки',
    'Что-то не так',
    'Рекорд',
  ];

  int _getPositionNumber(MenuItemPosition position) {
    if (position == MenuItemPosition.COURSE) return 1;
    if (position == MenuItemPosition.SETTINGS) return 2;
    if (position == MenuItemPosition.BUG) return 3;
    if (position == MenuItemPosition.RECORD)
      return 4;
    else
      return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        height:
        60.0, //TODO проверить как оно на Айфонах работает с их плашкой HOME или как она там называется....
        color: Color(0xFFF8F8F8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getMenuItem(0),
            getMenuItem(1),
            getMenuItem(2),
            getMenuItem(3),
          ],
        ),
      ),
    );
  }

  void _selectItem(int position) async {
    if (position == _getPositionNumber(selectItemNumber)) return;
    switch (position) {
      case 1:
        var course = await RepositoryLocal().getLastCourse();
        Navigator.pushNamed(context, CatalogScreen.id, arguments: course);
        break;
      case 2:
        Navigator.pushNamed(context, SettingScreen.id);
        break;
      case 3:
        Navigator.pushNamed(context, BugScreen.id);
        break;
      default:
        var course = await RepositoryLocal().getLastCourse();
        Navigator.pushNamed(context, CourseHomeScreen.id, arguments: course);
        break;
    }
  }

  Widget getMenuItem(int position) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () => _selectItem(position),
      child: aseMenuItem(
        icon: _icons[position],
        title: _titles[position],
        active: _getPositionNumber(selectItemNumber) == position,
      ),
    );
  }

  Widget aseMenuItem({AssetImage icon, String title, bool active}) {
    return Column(
      children: <Widget>[
        ImageIcon(icon, color: active ? Colors.blue : Colors.grey, size: 30.0),
        Text(
          title,
          style: TextStyle(
              fontSize: 9.0, color: active ? Colors.blue : Colors.grey),
        ),
      ],
    );
  }
}

enum MenuItemPosition { LEARN, COURSE, SETTINGS, BUG, RECORD }
