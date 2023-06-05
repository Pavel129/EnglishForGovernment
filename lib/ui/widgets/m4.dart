import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';

/// Виджет отображения 4 механики.

class MFourth extends StatelessWidget {

  final ScrollController controller = ScrollController();
  final Widget tmptext;
  final String wordText;
  final Widget buttonTrueFalse;
  final String audioPath;
  final Function playAudio;
  final bool displayingButtons;

  static String textDescription =
      "Подходит ли фраза (слово) чтобы дополнить предложение?";

  MFourth({
    @required this.tmptext,
    @required this.wordText,
    @required this.buttonTrueFalse,
    @required this.audioPath,
    @required this.playAudio,
    @required this.displayingButtons,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tmptext,
                SizedBox(
                  height: 45,
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      textDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                  width: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: false,
                        controller: controller,
                        child: Container(
                          height: 180,
                          alignment: Alignment.center,
                          child: SingleChildScrollView(
                            child: Text(
                              wordText,
                              style: kSFProR_Black_18,
                              textWidthBasis: TextWidthBasis.parent,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                      width: 5,
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      onPressed: playAudio,
                      icon: ImageIcon(
                        AssetImage(audioPath.length > 0
                            ? 'assets/images/icons/sound.png'
                            : 'assets/images/icons/sound.png'),
                        color: kStandartBlueColor,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                displayingButtons ? Container() : buttonTrueFalse,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
