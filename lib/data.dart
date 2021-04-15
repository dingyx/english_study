import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

// word data
class WordBean {
  int id;
  String translate;
  String word;
  String read;

  WordBean({this.id, this.translate, this.word, this.read});

  WordBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translate = json['translate'];
    word = json['word'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['translate'] = this.translate;
    data['word'] = this.word;
    data['read'] = this.read;
    return data;
  }
}

// - - - - - - - - -
// 数据处理基础封装
var _wordList;
int _ranInt = 0;

class WordData {
  WordData() {
    init();
  }

  // 初始化数据 读取 assets 文件夹下 json
  void init() {
    rootBundle.loadString("assets/data/word.json").then((value) {
      List responseJson = json.decode(value.toString());
      _wordList = responseJson.map((m) => new WordBean.fromJson(m)).toList();
    });
  }

  // 获取单词
  String getWord() {
    _ranInt = new Random().nextInt(3876);
    return _wordList[_ranInt].word;
  }

  // 获取翻译
  String getTran() {
    return _wordList[_ranInt].translate;
  }

  // 获取音标
  String getPhoneticSymbols() {
    return _wordList[_ranInt].read;
  }
}
