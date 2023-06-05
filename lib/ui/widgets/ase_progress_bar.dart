import 'package:aseforenglish/utils/constants.dart';
import 'package:flutter/material.dart';


Widget aseMinimalProgresBar({BuildContext context, double progres}) {
  double height = 4.0;
  double maxWidth = MediaQuery.of(context).size.width;
  return Stack(
    children: <Widget>[
      Container(
        height: height,
        width: maxWidth,
      ),
      Container(
        height: height,
        width: maxWidth * progres,
        color: kStandartBlueColor,
      ),
    ],
  );
}

/// Импровизированный прогремсс бар, состоящий с основной и второстепенной полоски
Widget aseProgresBar(
    {BuildContext context, double progres, double secondaryProgres}) {
  double height = 4.0;
  double maxWidth = MediaQuery.of(context).size.width - 125.0;

  return Stack(
    children: <Widget>[
      Container(
        height: height,
        width: maxWidth,
        color: Colors.grey.shade200,
      ),
      Container(
        height: height,
        width: maxWidth * secondaryProgres,
        color: Colors.yellow,
      ),
      Container(
        height: height,
        width: maxWidth * progres,
        color: Colors.green,
      ),
    ],
  );
}
