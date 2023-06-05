import 'package:aseforenglish/data/models/audit.dart';
import 'package:aseforenglish/data/models/user.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/catalog_screen.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Экран аутентификации пользователя.
class AuthScreen extends StatefulWidget {
  static final String id = 'auth_screen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String userName;
  String password;
  String _errFText = 'Ошибка.';
  String _errSText = 'Неверный логин и пароль';

  String _infoTextFirst =
      'Введите имя пользователя и пароль для учетной записи Рекорд mobile.';
  String _infoTextSecond =
      'Если вы новый сотрудник, действуйте по инструкции, высланной на ваш  рабочий e-mail.';

  String _hintLogin = 'Логин';
  String _hintPassword = 'Пароль';
  String _incorrectPassword = 'Неверный пароль.';
  String _incorrectLoginAndPassword = 'Не верные логин и пароль!';

  bool _errInputData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(kBkgImgAuthScreen),
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _errInputData ? '$_errFText\n$_errSText' : ' \n ',
                        style: kErrorTextStyle_17,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: _hintLogin,
                        ),
                        onChanged: (value) {
                          userName = value;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: _hintPassword,
                          ),
                          onChanged: (value) {
                            password = value;
                          }),
                      SizedBox(height: 32.0),
                      // Text(
                      //   'Я ЗАБЫЛ ПАРОЛЬ',
                      //   style: kSFProR_Black_14,
                      // ),
                    ],
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: kPeacockBlue100,
                  onPressed: () async {
                    User user = await RepositoryLocal()
                        .getUser(userName == null ? '' : userName);
                    if (user != null && user.password == password) {
                      RepositoryLocal().insertAudit(Audit(
                        userID: user.login,
                        courseID: kBaseCourse,
                      ));
                      Navigator.pushNamed(context, CatalogScreen.id);
                    } else if (user != null) {
                      setState(() {
                        _errSText = _incorrectPassword;
                        _errInputData = true;
                      });
                    } else {
                      setState(() {
                        _errSText = _incorrectLoginAndPassword;
                        _errInputData = true;
                      });
                    }
                  },
                  child: Container(
                    height: 48.0,
                    child: Center(
                      child: Text(
                        'Войти',
                        style: kButtonWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _infoTextFirst,
                          textAlign: TextAlign.center,
                          style: kInfoTextStyle01,
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          _infoTextSecond,
                          textAlign: TextAlign.center,
                          style: kInfoTextStyle01,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
