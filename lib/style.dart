import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

abstract class Styles {
  //定义文字样式
  static const TextStyle textLarge = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 80,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
    fontFamily: 'Arimo',
  );

  static const TextStyle textNormal = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontFamily: 'Arimo',
  );
  static const TextStyle textSmall = TextStyle(
    color: Color.fromRGBO(0, 0, 0, 0.8),
    fontSize: 18,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    fontFamily: 'Arimo',
  );
}
