import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';

/// Виджет отображения 1 и 2 механики.
///
/// [wordText] - "Текст вопрос"
///
/// [playAudio] - функция проигрыша аудио, если ответ не был проставлен, нужно передавать `null`
///
/// [questions] - Лист виджетов кнопок с вариантами ответов thrue false
///
class MFirstAndSecond extends StatelessWidget {
  final String wordText;
  final String audioPath;
  final Function playAudio;
  final List<Widget> questions;
  final ScrollController controller = ScrollController();
  final bool isAudioPlaying;

  MFirstAndSecond({
    @required this.wordText,
    @required this.audioPath,
    @required this.questions,
    @required this.playAudio,
    @required this.isAudioPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Scrollbar(
                      isAlwaysShown: false,
                      controller: controller,
                      //thickness: 1.0,
                      child: SingleChildScrollView(
                        child: Text(
                          wordText,
                          style: kSFProR_Black_18_Bold,
                          textWidthBasis: TextWidthBasis.parent,
                        ),
                      )),
                ),
                SizedBox(
                  height: 5,
                  width: 5,
                ),
                IconButton(
                  padding: EdgeInsets.all(0),
                  onPressed: playAudio,
                  icon: ImageIcon(
                    AssetImage(isAudioPlaying
                        ? 'assets/images/icons/pause.png'
                        : 'assets/images/icons/sound.png'),
                    color: kStandartBlueColor,
                    size: 30.0,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: questions,
          ),
        ],
      ),
    );
  }
}
