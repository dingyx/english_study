import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

// word data
class WordBean {
  int id;
  String translate;
  String word;

  WordBean({this.id, this.translate, this.word});

  WordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translate = json['translate'];
    word = json['word'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['translate'] = this.translate;
    data['word'] = this.word;
    return data;
  }
}

// - - - - - - - - -
// 数据处理基础封装
var _wordList;
int _ranInt = 0;

class WordData {
  // 初始化数据 读取 assets 文件夹下 json
  static void init() {
    rootBundle.loadString("assets/data/word.json").then((value) {
      List responseJson = json.decode(value.toString());
      _wordList = responseJson.map((m) => new WordBean.fromJson(m)).toList();
    });
  }

  // 获取单词
  static String getWord() {
    _ranInt = new Random().nextInt(3878);
    return _wordList[_ranInt].word;
  }

  // 获取翻译
  static String getTran() {
    String tranStr = _wordList[_ranInt].translate;
    return tranStr.substring(tranStr.indexOf("]", 0) + 1, tranStr.length);
  }

  // 获取音标
  static String getPhoneticSymbols() {
    String tranStr = _wordList[_ranInt].translate;
    return tranStr.substring(
        tranStr.indexOf("[", 0), tranStr.indexOf("]", 0) + 1);
  }
}
