import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';

/// Экран обратной связи и отправки сообщений
class BugScreen extends StatelessWidget {
  static final String id = 'bug_screen';

  final String _title = 'Обратная связь';

  const BugScreen({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: AseAppBarMinimum(title: _title),
            body: Container(
              color: kGreyBackground,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text(
                        'Все вопросы и предложения просьба\nприсылать на s.moskovskaya@ase-ec.ru.',
                        style: kSFProR_Black_18,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  BottomMenu(
                    context: context,
                    selectItemNumber: MenuItemPosition.BUG,
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
