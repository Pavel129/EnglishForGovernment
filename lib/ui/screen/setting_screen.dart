import 'package:aseforenglish/data/models/user.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/ui/widgets/popups.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'auth_screen.dart';

/// Экран настроек
/// TODO требуется реализоывать.
class SettingScreen extends StatefulWidget {
  static final String id = 'setting_screen';

  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final String title = 'Настройки';

  String versionApp = '';
  String userName = '';

  intStrings() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    final User user = await RepositoryLocal().getLastAuthUser();

    setState(() {
      versionApp = version;
      userName = user.name;
    });
  }

  @override
  void initState() {
    super.initState();
    intStrings();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: AseAppBarMinimum(title: title),
            body: Container(
              color: kGreyBackground,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -------------------
                        // Блок выхода из системы
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Text(
                            'АККАУНТ\nВы вошли как $userName',
                            style: kSFProR_Grey_14,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          color: Color(0xFFFFFFFF),
                          child: FlatButton(
                            onPressed: () => Navigator.push(
                              context,
                              AsePopupTwoButtons(
                                context: context,
                                title:
                                    'Вы действительно хотите выйти из системы?',
                                description: 'Текущий прогресс будет сброшен по' +
                                    ' всем темам без возможности восстановления',
                                okPressed: () {
                                  RepositoryLocal().audinDeleteData();
                                  Navigator.pushNamed(context, AuthScreen.id);
                                },
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.0,
                                vertical: 18.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Выйти',
                                      style: kSFProR_Black_18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 24.0,
                                    color: kIconGreyColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // -------------------
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      'Версия приложения: $versionApp',
                      style: kSFProR_Grey_14,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  BottomMenu(
                    context: context,
                    selectItemNumber: MenuItemPosition.SETTINGS,
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
