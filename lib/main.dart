import 'dart:io';
import 'package:aseforenglish/data/databases/db_content.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/auth_screen.dart';
import 'package:aseforenglish/ui/screen/bug_screen.dart';
import 'package:aseforenglish/ui/screen/calendar_screen.dart';
import 'package:aseforenglish/ui/screen/card_screen.dart';
import 'package:aseforenglish/ui/screen/catalog_screen.dart';
import 'package:aseforenglish/ui/screen/course_home_screen.dart';
import 'package:aseforenglish/ui/screen/course_main_screen.dart';
import 'package:aseforenglish/ui/screen/find_screen.dart';
import 'package:aseforenglish/ui/screen/intro_screen.dart';
import 'package:aseforenglish/ui/screen/process_learning_screen.dart';
import 'package:aseforenglish/ui/screen/result_screen.dart';
import 'package:aseforenglish/ui/screen/setting_screen.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // Копируем данные в Базу данных.
  Future<File> get _copyDB async {
    // Для корректной работы замекны базы данных, тредуется заврыть открытые базы, если они открыты.
    await RepositoryLocal()
        .closeDB(); // Добавил закрытие Юазы сюда, для того что бы копирование не свершалось при открытой базе данных.

    // Получаем директорию приложения
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = '${directory.path}/${DBContentProvider.BASE_NAME}';

    // Получаем побайтово заготовленную базу данных
    ByteData data = await rootBundle
        .load("assets/data/database/${DBContentProvider.BASE_NAME}");
    // Копируем базу данных
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return await File(dbPath).writeAsBytes(bytes);
  }

  @override
  Widget build(BuildContext context) {
    _copyDB;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: kAppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: IntroScreen.id,
      routes: {
        BugScreen.id: (_) => BugScreen(),
        AuthScreen.id: (_) => AuthScreen(),
        CardScreen.id: (_) => CardScreen(),
        FindScreen.id: (_) => FindScreen(),
        IntroScreen.id: (_) => IntroScreen(),
        ResultScreen.id: (_) => ResultScreen(),
        SettingScreen.id: (_) => SettingScreen(),
        CatalogScreen.id: (_) => CatalogScreen(),
        CalendarScreen.id: (_) => CalendarScreen(),
        CourseMainScreen.id: (_) => CourseMainScreen(),
        CourseHomeScreen.id: (_) => CourseHomeScreen(),
        ProcessLearningScreen.id: (_) => ProcessLearningScreen(),
      },
    );
  }
}
