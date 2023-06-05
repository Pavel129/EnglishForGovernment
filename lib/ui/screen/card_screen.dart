import 'dart:io';

import 'package:aseforenglish/data/model_for_view/topic_for_view.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/process_learning_screen.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:path_provider/path_provider.dart';

import './../../data/models/card.dart' as myCard;

/// Экран отображения карточек (Листалка)
class CardScreen extends StatefulWidget {
  static final String id = 'card_screen';

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  final String _title = 'Просмотр слов';

  final List<myCard.Card> cards = [];

  final AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  // Определяем контроллер для нашей листалки
  final controller = PageController(
    keepPage: true,
    initialPage: 0,
  );

  TopicForView topic;
  bool _visibleText = false;
  bool _visibleButton = false;
  bool _dontVisibleButton = false;
  bool _hasAudioWord = false;
  bool _hasAudioDescription = false;
  bool _isPlayAudioWord = false;
  bool _isPlayAudioDescription = false;
  bool _hasImage = false;

  bool _isRepeat = false;

  bool _isFirst = false;
  bool _isLast = false;

  int _cardsCountViews = 0;

  String audioWordPath = '';
  String audioDescrPath = '';
  String imagePath = '';

  // Асинхронный метод первого определения листа
  void setList() async {
    RouteSettings settings = ModalRoute.of(context).settings;
    topic = settings.arguments;

    var newList = await RepositoryLocal().getAllCardsTopic(topic.uid);

    if (topic.cardViewPosition != 0 ) {
      controller.jumpToPage(topic.cardViewPosition);
    }

    _isFirst = topic.cardViewPosition == 0;
    _isLast = topic.cardViewPosition == cards.length - 1;

    setState(() {
      cards.addAll(newList);
      if (cards.length > 0) getSourcies(cards[0].uid);
    });
  }

  // Метод получения аудио дорожки, если ее нет, то в путь записываем пустую строку
  void getSourcies(String cardID) async {
    var audioSource =
    await RepositoryLocal().getSourseWithType(cardID, SuourceType.AUDIO);
    var audioDescrSource = await RepositoryLocal()
        .getSourseWithType(cardID, SuourceType.AUDIO_DESCRIPTION);
    var imageSource =
    await RepositoryLocal().getSourseWithType(cardID, SuourceType.IMAGE);

    bool flagImage = imageSource != null;
    bool flagAudio = audioSource != null;
    bool flagDescr = audioDescrSource != null;
    setState(() {
      _hasImage = flagImage;
      _hasAudioWord = flagAudio;
      _hasAudioDescription = flagDescr;
      imagePath = flagImage ? imageSource.path : '';
      audioWordPath = flagAudio ? audioSource.path : '';
      audioDescrPath = flagDescr ? audioDescrSource.path : '';
    });
  }

  /// Метод для прослушивания события листания page view
  ///
  /// [index] - передается индекс новой показываемой страницы
  _setVisibleElement(int index) async {
    _playAdudioStop();
    _isFirst = index == 0;
    _isLast = index == cards.length - 1;
    myCard.Card card = cards[index];
    getSourcies(card.uid);
    if (!_dontVisibleButton) {
      _cardsCountViews++;
      var process = await RepositoryLocal().getLastProcess(topic.uid);
      // Типа идея такая, если это пользователь в процессе обучения вышел, процесс обучения уже есть, нам нужно его продолжить.
      // Если процесс обучения не начат, нужно его начать
      // Если процесс обучения начат, и у нас есть повторения, нам кнопку отображать не надо.
      if (process != null && process.processLevel != ProcessLevel.LEARNING) {
        _dontVisibleButton = true;
      }
      if (_cardsCountViews == cards.length - 1 && !_visibleButton) {
        setState(() {
          _visibleButton = true;
        });
      }
    } else {
      if (!_visibleText) {
        var tmpIsRepeateNow =
        await RepositoryLocal().isTopicInRepeateNow(card.topicID);
        setState(() {
          _isRepeat = tmpIsRepeateNow;
          _visibleText = true;
        });
      }
    }
  }

  Future<ByteData> loadAsset(path) async => await rootBundle.load(path);

  _playAdudioStop() {
    audioPlayer.stop();
    setState(() {
      _isPlayAudioWord = false;
      _isPlayAudioDescription = false;
    });
  }

  _playAllSound(String path) async {
    final newPath = path.replaceFirst('', '');

    Directory directory = await getTemporaryDirectory();
    var audioPath = '${directory.path}/${path.replaceFirst('assets/data/source/', '')}';

    final assetAudio = await loadAsset(newPath);
    final file = await File(audioPath);
    await file.writeAsBytes(assetAudio.buffer.asUint8List());

    final result = await audioPlayer.play(
      file.path,
      isLocal: true,
    );

    audioPlayer.onPlayerCompletion.listen((event) => _playAdudioStop());
  }

  _playSoundWord(String path, AudioBtnType type) async {
    if (!_isPlayAudioWord && type == AudioBtnType.WORD) {
      _playAdudioStop();
      setState(() => _isPlayAudioWord = true);
      await _playAllSound(path);
    } else if (!_isPlayAudioDescription && type == AudioBtnType.DESCRIPTION) {
      _playAdudioStop();
      setState(() => _isPlayAudioDescription = true);
      await _playAllSound(path);
    } else {
      _playAdudioStop();
    }
  }

  Widget imageWidget(String uid) {
    return _hasImage
        ? Column(
      children: [
        Image.asset(
          'assets/data/source/' + uid + '.jpg',
          height: 90,
          width: 150,
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    )
        : Column();
  }

  @override
  Widget build(BuildContext context) {

    // Собственно наша листалка
    final pageView = _getPageView(controller);

    if (cards.isEmpty) setList();

    return WillPopScope(
      onWillPop: () => _playAdudioStop(),
      child: Container(
        child: SafeArea(
          child: Scaffold(
            appBar: AseCardsAppBar(
              title: _title,
              audioStop: _playAdudioStop,
            ),
            body: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _getBkgImage(kBkgImgCardScreen),
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Expanded(
                      child: pageView,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      // Ифовый ад.
                      child: _visibleButton
                          ? _getButton(context, topic,
                          'Приступить к тренировке') // Просто кнопка к началу "Изучения"
                          : !_visibleText
                          ? Container() // Тут еще ни чего не показываем
                          : Container(
                        child: _isRepeat
                            ? _getButton(
                            context,
                            topic, // Кнопка к началу "повторения"
                            'Приступить к повторению')
                            : Text(
                          // тема на повторении и дата повторения не настала
                          'Данная тема Вами уже пройдена,'
                              '\nили находится на повторении',
                          textAlign: TextAlign.center,
                          style: kSFProR_LightRed_18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  moveToLeft() {
    controller.previousPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }
  moveToRight() {
    controller.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  // Виджет отображения Карточки, выносить в отдельный виджет не вижу смысла.
  // Использыется только тут.
  PageView _getPageView(PageController controller) {
    return PageView(
      onPageChanged: _setVisibleElement,
      controller: controller,
      children: cards.map((element) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(alignment: Alignment.center, children: [
            Positioned(left: 0, child: !_isFirst ? toLeft(moveToLeft) : Container()),
            Positioned(right: 0, child: !_isLast ? toRight(moveToRight) : Container()),
            Card(
              margin: EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 18.0, right: 12.0, top: 18.0, bottom: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      imageWidget(element.uid),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    element.word,
                                    style: kSFProR_BLack_21,
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                ),
                                IconButton(
                                    onPressed: !_hasAudioWord
                                        ? null
                                        : () => _playSoundWord(
                                        audioWordPath, AudioBtnType.WORD),
                                    icon: ImageIcon(
                                      AssetImage(_isPlayAudioWord
                                          ? kIconAudioPause
                                          : kIconAudioPlay),
                                      color: _hasAudioWord
                                          ? kStandartBlueColor
                                          : kIconGreyColor,
                                      size: 30.0,
                                    )
                                  // Icon(Icons.volume_up, color: Colors.blue),
                                )
                              ],
                            ),
                            Text(
                              element.translate,
                              style: kCardTranslateTextStyle,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 0.0,
                                    ),
                                    child: getDescription(element.description),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                  width: 15,
                                ),
                                IconButton(
                                    onPressed: !_hasAudioDescription
                                        ? null
                                        : () => _playSoundWord(audioDescrPath,
                                        AudioBtnType.DESCRIPTION),
                                    icon: ImageIcon(
                                      AssetImage(_isPlayAudioDescription
                                          ? kIconAudioPause
                                          : kIconAudioPlay),
                                      color: _hasAudioDescription
                                          ? kStandartBlueColor
                                          : kIconGreyColor,
                                      size: 30.0,
                                    )
                                  // Icon(Icons.volume_up, color: Colors.blue),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        );
      }).toList(),
    );
  }
}

// Обрезает лишние теги, если они есть из описания
Widget getDescription(String description) {
  var result = Html(data: description, style: {
    '*': Style(
      color: Colors.black,
      fontSize: FontSize(18.0),
      padding: EdgeInsets.all(0.0),
      margin: EdgeInsets.all(0.0),
    )
  });
  return result;
}

// типа отображение бэкграунда
Widget _getBkgImage(String path) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(
          path,
        ),
        fit: BoxFit.fill,
      ),
    ),
  );
}

void _startLearning(BuildContext context, TopicForView topic) {
  Navigator.pushNamed(context, ProcessLearningScreen.id, arguments: topic);
}

Widget _getButton(BuildContext context, TopicForView topic, String title) {
  return FlatButton(
    padding: EdgeInsets.symmetric(horizontal: 22.0),
    onPressed: () => _startLearning(context, topic),
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

Widget toLeft(Function toLeft) {
  return FlatButton(
    onPressed: toLeft,
    padding: EdgeInsets.all(0),
    child: Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(90.0),
          ),
          alignment: Alignment.center,
        ),
        Positioned(
          right: 45,
          child: Icon(
            Icons.chevron_left,
            color: Color(0x662196F3),
            size: 60.0,
          ),
        ),
      ],
    ),
  );
}

Widget toRight(Function toRight) {
  return FlatButton(
    onPressed: toRight,
    padding: EdgeInsets.all(0),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            color: Colors.white30,
            borderRadius: BorderRadius.circular(90.0),
          ),
          alignment: Alignment.centerLeft,
        ),
        Positioned(
          left: 45,
          child: Icon(
            Icons.chevron_right,
            color: Color(0x662196F3),
            size: 60.0,
          ),
        ),
      ],
    ),
  );
}

enum AudioBtnType { WORD, DESCRIPTION }
