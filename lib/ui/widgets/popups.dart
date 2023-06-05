import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// -----------------------------------------------------------------------------
// Poput контент с двумя кнопками
class AsePopupTwoButtons extends ModalRoute {
  final BuildContext context;
  final Color bgColor;
  final String title;
  final String description;
  final Function okPressed;

  Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  AsePopupTwoButtons({
    Key key,
    this.bgColor,
    @required this.context,
    @required this.title,
    @required this.description,
    @required this.okPressed,
  }) {
    child = _AsePopupTwoButtons(
      title: this.title,
      description: this.description,
      okPressed: this.okPressed,
      cancelFoo: () => Navigator.pop(context),
    );
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class _AsePopupTwoButtons extends StatelessWidget {
  final String title;
  final String description;
  final Function cancelFoo;
  final Function okPressed;

  final Color backgroundColor = Color(0xFFF2F2F2);
  final String btnCancalTitle = 'Отмена';
  final String btnOKTitle = 'Сбросить';

  _AsePopupTwoButtons({
    @required this.title,
    @required this.description,
    @required this.cancelFoo,
    @required this.okPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 180.0,
        width: 270.0,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(18.0))),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 18.0, left: 18.0, top: 18.0),
              child: Column(
                children: [
                  Text(
                    this.title,
                    style: kSFProR_Black_18_Bold,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                  Text(
                    this.description,
                    style: kSFProR_Black_14,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 13.0,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1.0,
                            color: kGreyBorderColor,
                          ),
                          right: BorderSide(
                            width: 1.0,
                            color: kGreyBorderColor,
                          ),
                        ),
                      ),
                      child: FlatButton(
                        onPressed: cancelFoo,
                        child: Center(
                          child: Text(
                            btnCancalTitle,
                            style: kSFProR_Blue_18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 1.0,
                            color: kGreyBorderColor,
                          ),
                        ),
                      ),
                      child: FlatButton(
                        onPressed: okPressed,
                        child: Center(
                          child: Text(
                            btnOKTitle,
                            style: kSFProR_Blue_18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
// -----------------------------------------------------------------------------
