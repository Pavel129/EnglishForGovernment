import 'package:aseforenglish/data/models/user.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/auth_screen.dart';
import 'package:aseforenglish/ui/screen/course_home_screen.dart';
import 'package:aseforenglish/utils/ase_random.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';



/// Экран отображения прогрузки, так же в фоне тут идет определение,
/// в первый ли раз мы зашли в приложение.
class IntroScreen extends StatelessWidget {
  static final String id = 'intro_screen';

  // Проверяем была ли аутентификация на данном устройстве,
  // если да, то попадаем в приложение
  // усли нет, то переходим на экран аутентификации.
  void runApp(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        var repo = RepositoryLocal();
        User user = await repo.getLastAuthUser();
        await initRandomList();
        if (user == null)
          Navigator.pushNamed(context, AuthScreen.id);
        else
          Navigator.pushNamed(context, CourseHomeScreen.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    runApp(context);
    return Material(
      child: Scaffold(
        backgroundColor: kWhite100,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(kBkgImgBackground),
                    alignment: Alignment.center,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(40),
                    alignment: Alignment.topCenter,
                    child: Image.asset(kBkgImgLogo, width: 212, height: 72),
                  ),
                  SizedBox(
                    height: 14,
                    width: 14,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(kBkgImgTitle, width: 205, height: 65),
                  ),
                  SizedBox(
                    height: 43,
                    width: 43,
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Image.asset(kBkgImgCompany, width: 190, height: 50),
                  ),
                ],
              ),
              Container(
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: SpinKitCircle(
                  size: 45.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
