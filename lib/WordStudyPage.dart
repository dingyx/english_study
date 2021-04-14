import 'dart:async';

import 'package:english_study/Utils.dart';
import 'package:english_study/data.dart';
import 'package:english_study/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordStudyPage extends StatefulWidget {
  WordStudyPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WordStudyPageState createState() => _WordStudyPageState();
}

class _WordStudyPageState extends State<WordStudyPage> {
  TextEditingController _wordEditController = TextEditingController();
  TextEditingController _tranEditController = TextEditingController();
  TTS tts = TTS();

  String _ttsImgPath = "assets/images/sound_normal.png";
  String _wordStr = "word";
  String _phoneticStr = "phonetic symbols";
  String _wordTran = "translate";

  // 单词 Timer 是否启动
  bool _isStudyStart = false;

  // 是否启动TTS
  bool _isTTS = true;

  // 出现单词个数
  int _wordCount = 0;

  // 定时器
  Timer _timer;

  // 启动定时器
  void _startTimer() {
    _timer = Timer.periodic(
        Duration(seconds: int.parse(_wordEditController.text)), (timer) {
      // 显示单词
      setState(() {
        ++_wordCount;
        _wordStr = WordData.getWord();
        _phoneticStr = " ";
        _wordTran = " ";
      });
      // 朗读读单词
      if (_isTTS) {
        tts.speak(_wordStr);
      }
      // 延迟显示音标、翻译
      Future.delayed(Duration(seconds: int.parse(_tranEditController.text)),
          () {
        setState(() {
          _phoneticStr = WordData.getPhoneticSymbols();
          _wordTran = WordData.getTran();
        });
      });
    });
  }

  // 取消定时器
  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // 初始化数据、TTS
    WordData.init();
    tts.initDefault();

    return Scaffold(
        body: GestureDetector(
            // 点击外部时 输入框失去焦点
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Center(
                    child: Column(mainAxisSize: MainAxisSize.max, children: <
                        Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 40, top: 40),
                        child: Text(_wordCount.toString(),
                            style: Styles.textNormal),
                      ),
                      InkWell(
                          child: Padding(
                            padding: EdgeInsets.only(right: 40, top: 40),
                            child:
                                Image.asset(_ttsImgPath, width: 40, height: 40),
                          ),
                          onTap: () {
                            _isTTS = !_isTTS;
                            setState(() {
                              if (_isTTS) {
                                _ttsImgPath = "assets/images/sound_normal.png";
                              } else {
                                _ttsImgPath = "assets/images/sound_mute.png";
                              }
                            });
                          })
                    ],
                  ),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                        Text(_wordStr, style: Styles.textLarge),
                        Text(_phoneticStr, style: Styles.textNormal),
                        Text(_wordTran, style: Styles.textNormal),
                      ])),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                      Widget>[
                    Text("Word Timer:", style: Styles.textSmall),
                    Container(
                        width: 60,
                        child: CupertinoTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                            ],
                            textAlign: TextAlign.center,
                            controller: _wordEditController)),
                    SizedBox(width: 30),
                    Text("Translate Delay:", style: Styles.textSmall),
                    Container(
                        width: 60,
                        child: CupertinoTextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                            ],
                            textAlign: TextAlign.center,
                            controller: _tranEditController)),
                  ]),
                  SizedBox(height: 30),
                  CupertinoSwitch(
                      value: _isStudyStart,
                      onChanged: (bool value) {
                        setState(() {
                          _isStudyStart = value;
                        });
                        // 点击按钮 启动关闭Timer
                        if (value) {
                          _startTimer();
                        } else {
                          _cancelTimer();
                        }
                        // 去掉输入框焦点
                        FocusScope.of(context).requestFocus(FocusNode());
                      }),
                  SizedBox(height: 20)
                ])))));
  }
}
