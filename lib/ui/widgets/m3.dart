import 'package:aseforenglish/ui/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import './../../utils/constants.dart';

class MThird extends StatelessWidget {

  final String content;
  final String currentAnswer;
  final String currentAnswerForViewResult;
  final bool isAnswered;
  final bool isUserAnswerCorrect;
  final List<Widget> inputs;
  final List<FocusNode> focusList;
  final List<TextEditingController> controllersList;

  final Function userAnswer;
  final Function skippMove;
  final Function playAudio;

  MThird({
    @required this.content,
    @required this.currentAnswer,
    @required this.currentAnswerForViewResult,
    @required this.isAnswered,
    @required this.isUserAnswerCorrect,
    @required this.inputs,
    @required this.focusList,
    @required this.controllersList,
    @required this.userAnswer,
    @required this.skippMove,
    @required this.playAudio,
  }) {
    print('');
  }

  getAnswer() {
    var userInputResult = '';
    controllersList.forEach((controll) {
      userInputResult +=
      '${userInputResult.length == 0 ? '' : ' '}${controll.text}';
    });
    final current = currentAnswer.trim().toLowerCase();
    final result = userInputResult.trim().toLowerCase();
    return result == current ? '1' : '0';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Html(
                              data: content,
                              style: {
                                '*': Style(
                                  margin: EdgeInsets.all(0.0),
                                  padding: EdgeInsets.all(0.0),
                                  fontSize: FontSize(18.0),
                                ),
                                'b': Style(
                                  fontWeight: FontWeight.normal,
                                  backgroundColor: kStandartYellowColor,
                                ),
                              },
                            ),
                          ),
                          SizedBox(width: 4.0),
                          IconButton(
                            color: Colors.grey,
                            icon: ImageIcon(
                              AssetImage('assets/images/icons/sound.png'),
                              size: 30.0,
                              color: Color(0xAA007AFF),
                            ),
                            onPressed: playAudio,
                          ),
                        ],
                      ),
                      SizedBox(height: 44.0,),
                      !isAnswered || isUserAnswerCorrect
                          ? Container()
                          : Container(
                        width: double.infinity,
                        child: Text(
                          '$currentAnswerForViewResult',
                          style: kSFProR_Green_18,
                        ),
                      ),
                      SizedBox(height: 24.0,),
                      isAnswered
                        ? Container()
                        : Row(
                          children: [
                            FlatButton(
                              onPressed: () {
                                skippMove();
                              },
                              child: Text(
                                'Пропустить',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            FlatButton(
                              onPressed: () {
                                userAnswer('0');
                              },
                              child: Text(
                                'Не знаю',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xFF007AFF),
                                ),
                              ),
                            ),
                          ],
                        ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Color(0xFFBCE0FD),
                                width: 1.0,
                              ),
                            ),
                            child: Wrap(
                              runSpacing: 10,
                              alignment: WrapAlignment.start,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              direction: Axis.horizontal,
                              children: inputs,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
          isAnswered
              ? Container()
              : AseStandartButton(
            title: 'Проверить',
            onClick: () {
              userAnswer(getAnswer());
            },
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
