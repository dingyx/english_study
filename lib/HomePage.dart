import 'dart:async';

import 'package:english_study/data.dart';
import 'package:english_study/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  TextEditingController _wordEditController = TextEditingController();
  TextEditingController _tranEditController = TextEditingController();

  String _wordStr = "word";
  String _phoneticStr = "phonetic symbols";
  String _wordTran = "translate";

  bool _switchValue = false;

  // 定时器
  Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(
        Duration(seconds: int.parse(_wordEditController.text)), (timer) {
      setState(() {
        _wordStr = WordData.getWord();
        _phoneticStr = " ";
        _wordTran = " ";
      });
      Future.delayed(Duration(seconds: int.parse(_tranEditController.text)),
          () {
        setState(() {
          _phoneticStr = WordData.getPhoneticSymbols();
          _wordTran = WordData.getTran();
        });
      });
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    WordData.init();
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.jpg"), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_wordStr, style: Styles.textLarge),
                        Text(_phoneticStr, style: Styles.textNormal),
                        Text(_wordTran, style: Styles.textNormal),
                      ]),
                ),
                Row(
                //  mainAxisSize: MainAxisSize.max, //根据 parent
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Word Timer:", style: Styles.textSmall),
                    Container(
                      width: 60,
                      child: CupertinoTextField(
                        controller: _wordEditController,
                      ),
                    ),
                    SizedBox(width: 30,),
                    Text("Translate Delay:", style: Styles.textSmall),
                    Container(
                      width: 60,
                      child: CupertinoTextField(
                        controller: _tranEditController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CupertinoSwitch(
                  value: _switchValue,
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                    // 点击按钮 启动关闭Timer
                    if (value) {
                      _startTimer();
                    } else {
                      _cancelTimer();
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
