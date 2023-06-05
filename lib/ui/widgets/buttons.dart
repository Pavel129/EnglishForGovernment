import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';

class ThreeButtonsWithQuestions extends StatelessWidget {
  final List<String> questions;
  final Function onClick;
  final int currentAnswerPosition;
  final int userAnswerPosition;

  /// [questions] - Лист строк, необходимо передавать три строки
  /// [currentAnswerPosition] - Индекс правильного ответа, не болжно превысить длины [questions].
  /// [userAnswerPosition] - используется при ответе пользователя.
  ThreeButtonsWithQuestions({
    @required this.questions,
    @required this.onClick,
    @required this.currentAnswerPosition,
    this.userAnswerPosition = -1,
  });

  TextStyle _getStyle([String textPosition]) {
    TextStyle result = kSFProR_Black_18;
    if (userAnswerPosition != -1) {
      if (userAnswerPosition == currentAnswerPosition)
        result = kSFProR_Green_18;
      else if (textPosition == questions[userAnswerPosition])
        result = kSFProR_LightRed_18;
      else
        result = kSFProR_Grey_18;
    }
    return result;
  }

  Border _getBorderStyle() {
    Border result = Border.all(color: Colors.grey, width: 1.0);
    if (userAnswerPosition != 0 && userAnswerPosition == currentAnswerPosition)
      result = Border.all(color: Colors.blue, width: 1.0);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: questions.map((text) {
          return AseSingleAnswerButton(
            title: text,
            onClick: onClick,
            style: _getStyle(text),
            borderStyle: _getBorderStyle(),
          );
        }).toList(),
      ),
    );
  }
}

class AseSingleAnswerButton extends StatelessWidget {
  final Function onClick;
  final TextStyle style;
  final String title;
  final Border borderStyle;

  AseSingleAnswerButton({
    @required this.title,
    @required this.onClick,
    @required this.style,
    @required this.borderStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: FlatButton(
        onPressed: onClick,
        padding: EdgeInsets.all(0.0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(18.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: borderStyle),
          child: Text(
             title,
            style: style,
          ),
        ),
      ),
    );
  }
}

class AseStandartButton extends StatelessWidget {
  final String title;
  final Function onClick;

  AseStandartButton({@required this.title, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      onPressed: onClick,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
            color: kPeacockBlue85, borderRadius: BorderRadius.circular(3.9)),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
      ),
    );
  }
}
