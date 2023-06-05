import 'dart:io';
import 'dart:math';

import 'package:aseforenglish/data/model_for_view/card_for_process.dart';
import 'package:aseforenglish/data/model_for_view/topic_for_view.dart';
import 'package:aseforenglish/data/models/process_learning.dart';
import 'package:aseforenglish/data/models/user.dart';
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/screen/result_screen.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/ui/widgets/ase_progress_bar.dart';
import 'package:aseforenglish/ui/widgets/buttons.dart';
import 'package:aseforenglish/ui/widgets/m1_2.dart';
import 'package:aseforenglish/ui/widgets/m3.dart';
import 'package:aseforenglish/ui/widgets/m4.dart';
import 'package:aseforenglish/utils/ase_random.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import './../../data/models/card.dart' as c;

/// Основной виджет работы процесса обучения, контроля вывода всех механик
/// и действия пользователя по ним.
class ProcessLearningScreen extends StatefulWidget {
  static final String id = 'process_learning_screen';

  ProcessLearningScreen({Key key}) : super(key: key);

  @override
  _ProcessLearningScreenState createState() => _ProcessLearningScreenState();
}

class _ProcessLearningScreenState extends State<ProcessLearningScreen> {
  final AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  /// Основная переменная, для отображения контента по механикам.
  ///
  /// При добалении механик, требуется их передавать в данный виджет.
  /// На текущий момент в него пишется 1 виджет MFirstAndSecond(...)
  /// Этот виджет поджодит и для М1 и для М2... они похожи,
  /// для остальных нужно ваять свое и свои действия добавлять.
  Widget _page;

  /// Карточки в первозданном виде
  List<c.Card> cards = [];

  /// Карточки с которыми мы работаем в процессе обучения, добавляем в данный лист по две карточки
  /// при прохождении карточки всех выбранных механик, удаляем карточку из данного листа
  /// Когда лист становится пустым, завершаем процесс обучения.
  List<CardForProcess> cardsForProcess = [];

  /// Мапа, в которой хранится прогресс по обучению, результат записывается в конце
  /// TODO нужно будет исходя из этой мапы сделать восстановление состояния прогресса обучения, если юзер вышел с приложения.
  Map<String, int> progressMap = Map();

  var tmpCardText = "";

  List<c.Card> tmpCards = [];

  //Количество пройденых карточек
  int numberPassedCards = 0;

  /// Просто ссылка на текущий процесс
  ProcessLearning _process;

  /// Заглушка, что бы понимать при пересоздании виджетов, что мы уже тут были.
  bool isStarted = true;

  /// Данный контролл помогает определить, что пользователь уже ответил,
  /// Нужно сбрасывать на `false` при открытии след. карточки.
  bool isAnswer = false;

  /// Данный контрол говорит, правильно ли пользователь ответил.
  /// Нужно сбрасывать на `false` при открытии след. карточки.
  bool isAnswerResult = false;

  // нужен для 4 механики для определения соотвествует ли слово заданному Description
  bool isCoincidence = false;

  bool _isLearning = true;

  bool _isPlayAudio = false;

  /// Отображение прогрессбара.
  double progressLevel = 0.0;

  /// Помогает определить процент прогресс бара.
  int cardsLenghtProgress;

  ///Помогает определить процент пройденого пути по прогрессу обучения
  int startCardsLenght;

  //TODO [startMechanicsLenght] увеличивается в дальнейшей разработке, требуется скорректировать
  int startMechanicsLenght = 4;

  /// текущая позиция в прогрессе обучения по колоде.
  int position = 0;
  var answerList;

  /// Вспомогательная переменная для отрисовки выбранного ответа пользователя, в зависимости верно или нет.
  int userAnswerIndex = 0;

  // Переменные для отрисовки виджета.
  String currentCardinfo = '';
  String audioPath = ''; // Вообще надо проигрыш аудио из механик 1 - 4
  // настаивать убирать, не вижу в этом какого либо смысла.

  // Чисто для М3. для управления контролами.
  bool isCreateControl = true;
  String m3CurrentResult = '';
  List<Widget> insertList = [];
  List<FocusNode> focusList = [];
  List<TextEditingController> controllersList = [];

  var random =
      new Random(); // используется при механики 4 для показа правильного слова или нет

  /// -------------------------------

  /// Основной метод перерисовки интерфейса при каких либо действиях пользователя.
  void notifyDataChanged() async {
    _playAdudioStop();
    var currentCard = CardForProcess.currendCard;
    currentCardinfo = '${currentCard.card.word}-${currentCard.mechanic}';
    progressMap.addAll({currentCardinfo: isAnswerResult ? 1 : 0});
    Widget tmpPage;
    // Определение Аудио, если это Механика 1, и если оно вообще есть.
    Function tmpAudioM1M2;
    var audio = await RepositoryLocal().getSourseWithType(
      currentCard.card.uid,
      currentCard.mechanic == Mechanics.M1
          ? SuourceType.AUDIO
          : SuourceType.AUDIO_DESCRIPTION,
    );
    var tmpAudioPath = '';
    if (audio != null) {
      tmpAudioPath = audio.path;
      tmpAudioM1M2 = _playSoundWord;
    }
    if (currentCard.mechanic == Mechanics.M1 ||
        currentCard.mechanic == Mechanics.M2) {
      if (currentCard.mechanic == Mechanics.M1) {
        tmpCardText = currentCard.card.word;
      } else {
        tmpCardText = textDescription(currentCard);
      }
      //-------------------------------------------------------------------------
      // Определение Текста, что показываем на карточке.
      // При добавлении новых механик, тут действия нужно будет переопределять.
      //-------------------------------------------------------------------------
      // Определение вариантов ответа для данной карточки.
      var buttons = _getButtons();
      //-------------------------------------------------------------------------
      tmpPage = MFirstAndSecond(
        wordText: tmpCardText,
        audioPath: tmpAudioPath,
        questions: buttons,
        playAudio: tmpAudioM1M2,
        isAudioPlaying: _isPlayAudio,
      );
    } else if (currentCard.mechanic == Mechanics.M3) {

      final htmlContent = htmlDescription(currentCard);
      final control = getControl(currentCard);
      if (insertList.isEmpty) {
        getInsertWidget(control);
      } else 
      if (isAnswer) {
        insertList.clear();
        m3CurrentResult = '';
        getInsertWidget(control);
      }

      tmpPage = MThird(
        content: htmlContent,
        currentAnswer: m3CurrentResult,
        currentAnswerForViewResult: control,
        userAnswer: _userAnswer,
        isAnswered: isAnswer,
        isUserAnswerCorrect: isAnswerResult,
        inputs: insertList,
        focusList: focusList,
        controllersList: controllersList,
        skippMove: skippMove,
        playAudio: tmpAudioM1M2,
      );
    } else if (currentCard.mechanic == Mechanics.M4) {
      tmpCardText = currentCard.randowWordsM4;
      answerList = textDescription(currentCard);
      var buttons = _getButtonsTrueFalse();
      var wCardText = _getTmpText(tmpCardText);

      tmpPage = MFourth(
        tmptext: wCardText,
        wordText: answerList,
        buttonTrueFalse: buttons,
        audioPath: tmpAudioPath,
        playAudio: tmpAudioM1M2,
        displayingButtons: isAnswer,
      );
    }
    //-------------------------------------------------------------------------
    setState(() {
      progressLevel = position / cardsLenghtProgress;
      _page = tmpPage;
      audioPath = tmpAudioPath;
    });
  }

  //Метод позволят обрезать не нужное в комментарии в поле description
  String textDescription(CardForProcess currentCard) {
    var tmpIndex = currentCard.card.description.indexOf('<b>');
    var dscrIndStart = tmpIndex == -1 ? 0 : tmpIndex;
    tmpIndex = currentCard.card.description.indexOf('</b>');
    var dscrIndEnd = tmpIndex == -1 ? 0 : tmpIndex + 4;

    var tmpCardText =
        '${currentCard.card.description.substring(0, dscrIndStart)} ____ ${currentCard.card.description.substring(dscrIndEnd)}';
    return tmpCardText;
  }

  skippMove() {
    isAnswer = true;
    isAnswerResult = true;
    onClickNextCard();
  }

  /// Позволяет получить первый контрол из дескрипшена, в основном нужно для М3
  String getControl(CardForProcess currentCard) {
    var tmpIndex = currentCard.card.description.indexOf('<b>');
    var dscrIndStart = tmpIndex == -1 ? 0 : tmpIndex + 3;
    tmpIndex = currentCard.card.description.indexOf('</b>');
    var dscrIndEnd = tmpIndex == -1 ? 0 : tmpIndex;
    return  currentCard.card.description.substring(dscrIndStart, dscrIndEnd);
  }

  /// Метод для формирования универсальной HTML строки для всех дескрипшенов
  /// Вырезает весь контент в тегах <b></b> подставляет вместо себя '_____'
  String htmlDescription(CardForProcess currentCard) {
    var tmpText = currentCard.card.description;
    var result = '';

    while (tmpText.length > 0) {
      var tmpIndex = tmpText.indexOf('<b>');
      var indexStart = tmpIndex == -1 ? 0 : tmpIndex + 3;
      tmpIndex = tmpText.indexOf('</b>');
      var indexEnd = tmpIndex == -1 ? 0 : tmpIndex;

      if (indexStart > 0 || indexEnd > 0) {
        // if (control.length == 0) {
        //   control = tmpText.substring(indexStart, indexEnd);
        //   getInsertWidget();
        // }
        result += '${tmpText.substring(0, indexStart)}___</b>';
        tmpText = tmpText.replaceFirst(tmpText.substring(0, indexEnd + 4), '');
      } else {
        result += tmpText;
        tmpText = '';
      }
    }
    return result;
  }

  /// Вспомогательный метод создания фокусов для инпутов в М3
  getFocusNode() {
    final focus = FocusNode();
    focusList.add(focus);
    return focus;
  }

  /// Вспомогательный метод создания контролов для инпутов в М3
  getController() {
    final controller = TextEditingController();
    controllersList.add(controller);
    return controller;
  }

  /// Вспомогательный метод получения еденичного инпута виджета для М3
  getInputField(int maxLength, int index) {
    return IntrinsicWidth(
      stepWidth: 50.0,
      child: Container(
        // height: 20.0,
        child: TextField(
          controller: isCreateControl
                      ? getController()
                      : controllersList[index],
          focusNode: getFocusNode(),
          keyboardType: TextInputType.text,
          textAlign: TextAlign.center,
          maxLength: maxLength,
          cursorColor: Colors.red,
          style: TextStyle(
            color: !isAnswer
                ? kBlack100
                : isAnswerResult
                    ? kStandartGreenColor
                    : kStandartLightRedColor,
            height: 1,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            counterText: '',
          ),
          //TODO перенести в контроллер листенер.
          onTap: () => {},
          onChanged: (text) {
            if (text.length == maxLength && index <= focusList.length - 1) {
              FocusScope.of(context).requestFocus(index == focusList.length - 1
                  ? FocusNode()
                  : focusList[index + 1]);
            } else if (text.length == 0 && index > 0) {
              FocusScope.of(context).requestFocus(focusList[index - 1]);
            }
          },
        ),
      ),
    );
  }

  /// Метод для формирования листа виджетов для М3
  getInsertWidget(String control) {
    String hasString = control;
    int inputNumber = 0;
    var cutString = '';
    hasString.codeUnits.forEach((el) {
      final char = String.fromCharCode(el);
      if ((el >= 65 && el <= 90) || (el >= 97 && el <= 122)) {
        cutString += char;
      } else {
        if (wordExceptions.contains(cutString)) {
          insertList.add(Container(height: 20, child: Text(cutString)));
          cutString = '';
        } else {
          if (cutString.length > 0) {
            insertList.add(getInputField(cutString.trim().length, inputNumber++));
            m3CurrentResult +=
            '${m3CurrentResult.length == 0 ? '' : ' '}$cutString';
            cutString = '';
          }
        }
        insertList.add(SizedBox(width: 4.0));
        insertList.add(Container(height: 20.0, child: Text(char)));
        insertList.add(SizedBox(width: 4.0));
      }
    });
    if (cutString.length > 0) {
      insertList.add(getInputField(cutString.trim().length, inputNumber++));
      m3CurrentResult += '${m3CurrentResult.length == 0 ? '' : ' '}$cutString';
    }
    isCreateControl = false;
  }

  Future<ByteData> loadAsset(path) async => await rootBundle.load(path);

  _playAllSound(String path) async {
    setState(() => _isPlayAudio = true);
    final newPath = path.replaceFirst('', '');

    Directory directory = await getTemporaryDirectory();
    var audioPath =
        '${directory.path}/${path.replaceFirst('assets/data/source/', '')}';

    final assetAudio = await loadAsset(newPath);
    final file = await File(audioPath);
    await file.writeAsBytes(assetAudio.buffer.asUint8List());

    final result = await audioPlayer.play(
      file.path,
      isLocal: true,
    );

    audioPlayer.onPlayerCompletion.listen((event) => _playAdudioStop());
  }

  _playAdudioStop() {
    audioPlayer.stop();
    setState(() => _isPlayAudio = false);
  }

  /// Метод проигрыша мелодий, если они есть
  _playSoundWord() async {
    if (audioPath.length > 0) {
      if (!_isPlayAudio) {
        setState(() => _isPlayAudio = true);
        await _playAllSound(audioPath);
      } else {
        _playAdudioStop();
      }
    }
    // await audio.play(audioPath.replaceFirst('assets/', ''));
  }

  Widget _getTmpText(String tmptext) {
    var currentCard = CardForProcess.currendCard;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ((tmptext == currentCard.card.word) || !isAnswer)
              ? Container(
                  child: Text(
                    tmptext, //слово которое передаем
                    style: _getStyleTextStyle(),
                    textAlign: TextAlign.start,
                  ),
                )
              : (!(tmptext == currentCard.card.word) && isAnswer)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            tmptext, //слово которое передаем
                            style: kSFProR_LightRed_18,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        SizedBox(
                          height: 35,
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            currentCard.card.word, //слово которое передаем
                            style: kSFProR_Green_18,
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    )
                  : Container(),
        ]);
  }

  Widget _getButtonsTrueFalse() {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 0, top: 5, right: 5, bottom: 5),
          child: RaisedButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: !isAnswer ? () => _userAnswer(tmpCardText, "Да") : null,
            child: Container(
              decoration: BoxDecoration(
                  color: kPeacockBlue85,
                  borderRadius: BorderRadius.circular(3.9)),
              padding: const EdgeInsets.only(
                  left: 60, top: 15, bottom: 15, right: 60),
              child: Text(
                'Да',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 5, top: 5, right: 0, bottom: 5),
          child: RaisedButton(
            padding: const EdgeInsets.all(0.0),
            onPressed: !isAnswer ? () => _userAnswer(tmpCardText, "Нет") : null,
            child: Container(
              decoration: BoxDecoration(
                  color: kPeacockBlue85,
                  borderRadius: BorderRadius.circular(3.9)),
              padding: const EdgeInsets.only(
                  left: 55, top: 15, bottom: 15, right: 60),
              child: Text(
                'Нет',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Выведеный в отдельный метод, метод получения вариантов ответов для карточки
  /// Подходит конкретно для 1 и 2 механик
  List<Widget> _getButtons() {
    final current = CardForProcess.currendCard;
    final List<Widget> result = [];
    if (current.mechanic == Mechanics.M1 || current.mechanic == Mechanics.M2) {
      var answerList = current.mechanic == Mechanics.M1
          ? current.incorrectTranslate
          : current.incorrectWords;
          
      result.addAll(answerList
          .map((str) => AseSingleAnswerButton(
                title: str,
                onClick: !isAnswer ? () => _userAnswer(str) : null,
                style: _getStyleButtonTextStyle(str),
                borderStyle: Border.all(
                  color: isAnswer ? Colors.grey : Colors.blue,
                  width: 1.0,
                ),
              ))
          .toList());
    } else if (current.mechanic == Mechanics.M3) {
      
    }

    return result;
  }

  /// Метод для получения отрисовки стиля кнопок, если пользователь ответил
  ///
  /// [btnLine] - позиция кнопки, если пользователь нажал кнопку 0, мы это определяем.
  /// и в зависимости от правильности ответа, определяем все кнопки.
  TextStyle _getStyleButtonTextStyle(String btnLine) {
    //TODO оптемизировать данный код. убрать повторения.
    var result = kSFProR_Black_18;
    CardForProcess current = CardForProcess.currendCard;

    if (isAnswer) {
      if (current.mechanic == Mechanics.M1) {
        if (current.card.translate == btnLine)
          result = kSFProR_Green_18;
        else if (current.incorrectTranslate[userAnswerIndex] == btnLine &&
            !isAnswerResult)
          result = kSFProR_LightRed_18;
        else
          result = kSFProR_Grey_18;
      } else {
        // Это получается на вторую механику.
        if (current.card.word == btnLine)
          result = kSFProR_Green_18;
        else if (current.incorrectWords[userAnswerIndex] == btnLine &&
            !isAnswerResult)
          result = kSFProR_LightRed_18;
        else
          result = kSFProR_Grey_18;
      }
    }

    return result;
  }

  TextStyle _getStyleTextStyle() {
    var result = kSFProR_Black_18_Bold;

    if (isAnswer) result = kSFProR_Green_18;

    return result;
  }

  /// Основной метод, получения ответа от пользователя, используется для М1 и М2
  ///
  /// Для остальных механик, так же нужно использовать его, просто добавлять проверки.
  ///
  /// [choice] - Текстовый ваниант того что выбрал пользователь, нажав на кнопку,
  /// Сравниваем с верным ответом...
  void _userAnswer(String choice, [String trueFalse]) {
    var currentCard = CardForProcess.currendCard;
    isAnswer = true;
    if (currentCard.mechanic == Mechanics.M1) {
      isAnswerResult = currentCard.card.translate == choice;
      _getLoopIndexWord(currentCard.incorrectTranslate, choice);
    } else if (currentCard.mechanic == Mechanics.M2) {
      isAnswerResult = currentCard.card.word == choice;
      _getLoopIndexWord(currentCard.incorrectWords, choice);
    } else if (currentCard.mechanic == Mechanics.M3) {
      isAnswerResult = choice == '1';
    } else if (currentCard.mechanic == Mechanics.M4) {
      if ((choice == currentCard.card.word) && trueFalse == "Да")
        isAnswerResult = true;
      else if ((choice != currentCard.card.word) && trueFalse == "Нет")
        isAnswerResult = true;
    } else {
      isAnswerResult = false;
    }
    notifyDataChanged();
  }

  /// Получаем индекс кнопки, на которую нажал пользователь.
  ///
  /// [list] - Текстовый лист, с ответами
  ///
  /// [line] - Ответ пользователя.
  void _getLoopIndexWord(List<String> list, String line) {
    userAnswerIndex = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i] == line) userAnswerIndex = i;
    }
  }

  /// Метод первоначального входа в процесс обучения.
  void getCardsList() async {
    RouteSettings settings = ModalRoute.of(context).settings;
    TopicForView topic = settings.arguments;
    var tmpIsLearning = true;

    // Смотим, есть ли начатый процесс Изучения, если нет, то стартуем процесс HEAD и его подпроцесс LEARNING
    var headProcess = await RepositoryLocal().getHeadProcessInTopic(topic.uid);
    if (headProcess == null) {
      User user = await RepositoryLocal().getLastAuthUser();
      headProcess = ProcessLearning(
        topicID: topic.uid,
        userID: user.login,
        processLevel: ProcessLevel.HEAD,
      );
      _process = ProcessLearning(
        topicID: topic.uid,
        userID: user.login,
        processLevel: ProcessLevel.LEARNING,
        upID: headProcess.uid,
      );
      tmpIsLearning = _process.processLevel == ProcessLevel.LEARNING;
      RepositoryLocal().insertProcess(headProcess);
      RepositoryLocal().insertProcess(_process);
    } else {
      _process = await RepositoryLocal().getLastProcess(topic.uid);
    }

    CardForProcess.clearData();
    isStarted = false;

    tmpCards = await RepositoryLocal().getAllCardsTopic(topic.uid);
    cards = tmpCards;
    startCardsLenght = tmpCards.length;
    setState(() {
      cardsLenghtProgress = cards.length * startMechanicsLenght;
      _isLearning = tmpIsLearning;
    });

    getTwoCardsEach();
  }

  //Метод для добавления в рабочую колоду по две карточки.
  void getTwoCardsEach() async {
    // Создаем рузщультирующий список, помогающий отрезать 2е карточки
    List<c.Card> result = [];
    // Получаем последнюю карточку нашей колоды, если она есть...
    var prevLastCard = CardForProcess.lastCard;
    // Перебираем карточки
    for (var card in cards) {
      result.add(card);
      var tmpIncorrects = await RepositoryLocal().getIncorrectCards(card.uid);
      // Получаем модель дль для работы с процессом, по одной из новых карточек для нашей колоды.
      CardForProcess cardForProcess = CardForProcess(
        card: card,
        mechanic: Mechanics.M1,
      );
      cardForProcess.incorrectCards = tmpIncorrects;
      cardForProcess.incorrectTranslate =
          getThreeAnswers(cardForProcess, Mechanics.M1);
      cardForProcess.incorrectWords =
          getThreeAnswers(cardForProcess, Mechanics.M2);
      cardForProcess.randowWordsM4 = cardForProcess.incorrectWords[0];

      //предполагаетсмя выбор с неправильными словами
      //Если наша колода для обучения пустая, то зададим соответствующие перве карты в колоде
      if (CardForProcess.firstCard == null && CardForProcess.lastCard == null) {
        CardForProcess.firstCard = cardForProcess;
        CardForProcess.lastCard = cardForProcess;
        CardForProcess.currendCard = cardForProcess;
        // Если колода не пустая, добавляем в нее новую карточку и переопределяем "последнюю карточку в колоде"
      } else if (prevLastCard != null) {
        CardForProcess.lastCard = cardForProcess;
        prevLastCard.nextCard = cardForProcess;
        cardForProcess.prevCard = prevLastCard;
      }
      // Переопределяем Нашу темповую переменную на значение последней карточки колоды
      prevLastCard = cardForProcess;
      setState(() {
        cardsForProcess.add(cardForProcess);
      });
      // Если мы уже положили 2е карточки, то выходим из цикла.
      if (result.length == 2) break;
    }
    notifyDataChanged();
    // Теперь из нашей простой колоды карты, нужно удалить, ранее добавленные карточки.
    for (var card in result) cards.removeWhere((el) => el.uid == card.uid);
  }

  /// Метод открытия следующей карточки.
  void onClickNextCard() async {
    _playAdudioStop();
    // Обзязательно требуется тереть слудующие три инпута от данных.
    // -----
    insertList = [];
    focusList = [];
    controllersList = [];
    m3CurrentResult = '';
    isCreateControl = true;
    // -----
    var currentCard = CardForProcess.currendCard;
    if (currentCard != null) {
      // 1. Смена механики текущей карточки или быброс карточки из колоды.
      if (isAnswerResult) {
        position++;
        switch (currentCard.mechanic) {
          case Mechanics.M1:
            currentCard.mechanic = Mechanics.M2;
            break;
          // При добавлении рабочей новой механики, требуется добавлять тут действия.
          case Mechanics.M2:
            currentCard.mechanic = Mechanics.M3;
            break;
          case Mechanics.M3:
            currentCard.mechanic = Mechanics.M4;
            break;
          // case Mechanics.M4:
          //   currentCard.mechanic = Mechanics.M5;
          //   break;
          default:
            numberPassedCards++;
            //Описать действия последней действующей механиики...
            // По сути затираем текущую карточку
            CardForProcess prev = currentCard.prevCard;
            CardForProcess next = currentCard.nextCard;
            cardsForProcess.remove(currentCard);
            if (prev != null) prev.nextCard = next;
            if (next != null) next.prevCard = prev;
            if (prev == null) CardForProcess.firstCard = next;
            if (cardsForProcess.isEmpty) {
              _process.progress = progressMap.toString();
              _process.endDT = DateTime.now();
              RepositoryLocal().updateProcess(_process);

              // Если это последний процесс, просто его закрываем и более продолжения нет.
              if (_process.processLevel == ProcessLevel.REPEAT_07) {
                var headProcess = await RepositoryLocal()
                    .getHeadProcessInTopic(_process.topicID);
                headProcess.endDT = DateTime.now();
                RepositoryLocal().updateProcess(headProcess);
              } else {
                // Получаем текущую дату, по "местному времени"
                var now = DateTime.now();
                // Получаем дату по местному времени, но с обнуленными часами - секундами
                // Добавляем нужное количество дней, для интервального повторения
                var nextRepeat = DateTime(now.year, now.month, now.day).add(
                    Duration(days: getIntervalRepeat(_process.processLevel)));
                // Создаем новый процесс
                var nextProcess = ProcessLearning(
                  topicID: _process.topicID,
                  userID: _process.userID,
                  processLevel: getNextLevel(_process.processLevel),
                  startDT: nextRepeat,
                  upID: _process.upID,
                );
                RepositoryLocal().insertProcess(nextProcess);
              }

              Navigator.pushNamed(
                context,
                ResultScreen.id,
                arguments: _process,
              );
            }
        }
      }
      // Сбрасываем заглушку, что пользователь ответил на вопрос
      isAnswer = false;
      isAnswerResult = false;
      isCoincidence = false;
      // 2. Если слудующей карточки нет, то добавляем до 2х карточек в колоду, и переходим на начало колоды.
      if (currentCard.nextCard == null && cards.isNotEmpty) {
        // В данном случае добавляем до 2х карточек из колоды
        getTwoCardsEach();
        // Переходим на отображение Первой карточки в колоде
        CardForProcess.currendCard = CardForProcess.firstCard;
      }
      // Если следующей карточки нет, и все карточки кончились, просто возвращаемся в начало колоды
      else if (currentCard.nextCard == null) {
        CardForProcess.currendCard = CardForProcess.firstCard;
      }
      // Или просто листаем дальше. По сути это - рекурсия, до момента, как currentCard.nextCard станет null
      else {
        CardForProcess.currendCard = currentCard.nextCard;
      }

      // Обновляем стейт по результатам.
      if (CardForProcess.currendCard != null) {
        notifyDataChanged();
      } else {
        CardForProcess.clearData();
      }
    } else {
      throw FlutterError('Не определена CardForProcess.currendCard.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isStarted) getCardsList();
    return WillPopScope(
      onWillPop: () => _playAdudioStop(),
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: AseCardsAppBar(
              title: '${_isLearning ? 'Изучение' : 'Повторение'}',
              audioStop: _playAdudioStop,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                aseMinimalProgresBar(
                  context: context,
                  progres: progressLevel,
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 18.0,
                    ),
                    !isAnswer
                        ? Container(height: 61, width: 45)
                        : Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ImageIcon(
                              AssetImage(isAnswerResult
                                  ? kIconCurrectAnswer
                                  : kIconIncurrectAnswer),
                              color: isAnswerResult
                                  ? Colors.green
                                  : kStandartLightRedColor,
                              size: 45.0,
                            ),
                          ),
                    Expanded(
                      child: Container(),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        '$numberPassedCards / $startCardsLenght',
                        style: kSFProR_Grey_14,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),

                /// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _page,
                  ),
                ),

                /// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                isAnswer
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 32, top: 8.0, right: 32.0, bottom: 16.0),
                        child: AseStandartButton(
                          title: 'Дальше',
                          onClick: () => onClickNextCard(),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Метод формирования Трех вариантов ответа для отображения трех кнопок. в виде строк.
List<String> getThreeAnswers(CardForProcess card, Mechanics m) {
  List<String> result = [];
  var incorrextIndex = <int>[];

  putUnuqueRandomNumber(incorrextIndex, card.incorrectCards.length);
  putUnuqueRandomNumber(incorrextIndex, card.incorrectCards.length);

  var ansvers = [
    card.card,
    card.incorrectCards[incorrextIndex[0]],
    card.incorrectCards[incorrextIndex[1]],
  ];

  String first = getRandomIncorrextString(ansvers, m);
  String second = getRandomIncorrextString(ansvers, m);
  String therd = getRandomIncorrextString(ansvers, m);

  result = [first, second, therd];

  return result;
}
