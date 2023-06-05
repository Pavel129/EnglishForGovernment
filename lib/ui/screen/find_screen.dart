import 'package:aseforenglish/data/model_for_view/topic_for_view.dart';
import 'package:aseforenglish/data/models/card.dart' as c;
import 'package:aseforenglish/data/repo/repository.dart';
import 'package:aseforenglish/ui/widgets/app_bar.dart';
import 'package:aseforenglish/utils/constants.dart';
import 'package:aseforenglish/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

import 'card_screen.dart';

class FindScreen extends StatefulWidget {
  FindScreen({Key key}) : super(key: key);
  static final String id = 'find_screen';

  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {

  TextEditingController controller = TextEditingController();
  List<Widget> widgetList = [];

  changeText() {
    changeList(controller.text);
  }

  changeList(String likeWord) async {
    List<Widget> tmpWidgetList = [];
    if (likeWord.length >= 3) {
      List<c.Card> tmpList = await RepositoryLocal().findCards(likeWord);

      var topicID = '';
      var topic = '';
      var tmpTopic;

      for (var card in tmpList) {
        if (topicID != card.topicID) {
          tmpTopic = await RepositoryLocal().getTopic(card.topicID);
          topic = tmpTopic.name;
        }
        tmpWidgetList.add(_cardView(_getHtmlWord(card), card.uid, topic, tmpTopic.uid));
      }
    }

    setState(() {
      widgetList = tmpWidgetList;
    });
  }

  String _getHtmlWord(c.Card card) {
    var findWord = controller.text;
    var word = card.word;
    var result = '';

    var sIndex = word.toLowerCase().indexOf(findWord);
    var eIndex = sIndex + findWord.length;
    findWord = word.substring(sIndex, eIndex);

    result = word.replaceAll(findWord, '<b>$findWord</b>');

    return result.length <= 80 ? result : '${result.substring(0, 80)}...';
  }



  moveToo(String cardID, String topicID) async {
    final topic = await RepositoryLocal().getTopic(topicID);
    final cards = await RepositoryLocal().getAllCardsTopic(topicID);
    var cardPosition = 0;

    for (var i = 0; i < cards.length; i++) {
      if (cardID == cards[i].uid) {
        cardPosition = i;
      }
    }

    final topicForView = new TopicForView(
      uid: topic.uid,
      title: topic.name,
      type: TopicType.TOPIC,
      parentID: topic.upID,
      cardViewPosition: cardPosition,
    );

    Navigator.pushNamed(context, CardScreen.id, arguments: topicForView);
  }

  Widget _cardView(String word, String cardID, String topic, String topicID) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () => moveToo(cardID, topicID),
      child: Container(
        height: 100.0,
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: kGrey100, width: 0.35))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    // child: Text(word, style: kSFProR_Black_18),
                    child: Html(
                      data: word,
                      style: {
                        '*': Style(
                          fontSize: FontSize(18.0),
                          padding: EdgeInsets.all(0.0),
                          margin: EdgeInsets.all(0.0),
                        ),
                        'b': Style(
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    ),
                  ),
                  Text(topic, style: kSFProR_Grey_14),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 24.0, color: kGrey100)
          ],
        )
      ),
    );
  }

  @override
  void initState() {
    controller.addListener(changeText);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    return Container(
      child: Material(
        child: SafeArea(
          child: Scaffold(
            appBar: AseAppBarFinder(controller: controller),
            body: Container(
              child: ListView(
                children: widgetList.length > 0
                    ? widgetList
                    : [
                      SizedBox(height: 18.0),
                      Text(
                        controller.text.length < 3
                            ? 'Для поиска введите 3 и более символов'
                            : 'Нет результатов для поиска',
                        style: kSFProR_Grey_18,
                        textAlign: TextAlign.center,
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
