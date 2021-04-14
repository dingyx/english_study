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

  // 单词timer 翻译延迟时间 单位/秒
  int _wordTimer = 8;
  int _tranDelay = 5;

  // 启动定时器
  void _startTimer() {
    // 异常输入时 采用默认值
    _timer = Timer.periodic(Duration(seconds: _wordTimer), (timer) {
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
      Future.delayed(Duration(seconds: _tranDelay), () {
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
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(left: 40, top: 40),
                                child: Image.asset(_ttsImgPath,
                                    width: 40, height: 40),
                              ),
                              onTap: () {
                                _isTTS = !_isTTS;
                                setState(() {
                                  if (_isTTS) {
                                    _ttsImgPath =
                                        "assets/images/sound_normal.png";
                                  } else {
                                    _ttsImgPath =
                                        "assets/images/sound_mute.png";
                                  }
                                });
                              }),
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(_wordCount.toString(),
                                style: Styles.textNormal),
                          ),
                          InkWell(
                              child: Padding(
                                padding: EdgeInsets.only(right: 40, top: 40),
                                child: Image.asset("assets/images/setting.png",
                                    width: 34, height: 34),
                              ),
                              onTap: () {
                                _showDialog(context);
                              }),
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

  // 点击弹出设置框
  void _showDialog(widgetContext) {
    showCupertinoDialog(
      context: widgetContext,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Settings'),
          content:
              Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                  Widget>[
            SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text("Word Timer:", style: Styles.textSmall),
              SizedBox(width: 40),
              Container(
                  width: 60,
                  child: CupertinoTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                      textAlign: TextAlign.center,
                      controller: _wordEditController)),
            ]),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text("Translate Delay:", style: Styles.textSmall),
              SizedBox(width: 10),
              Container(
                  width: 60,
                  child: CupertinoTextField(
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                      ],
                      textAlign: TextAlign.center,
                      controller: _tranEditController)),
            ]),
          ]),
          actions: [
            CupertinoDialogAction(
              child: Text('Confirm'),
              onPressed: () {
                try {
                  _wordTimer = int.parse(_wordEditController.text);
                  _tranDelay = int.parse(_tranEditController.text);
                  if (_tranDelay > _wordTimer) {
                    _wordTimer = 8;
                    _tranDelay = 5;
                  }
                } catch (ignore) {}
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text('Cancel'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
