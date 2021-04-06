import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data.dart';

void main() => runApp(new MyApp());

List<WordBean> _wordList;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 读取 assets 目录 word.json 文件
    rootBundle.loadString("assets/data/word.json").then((value) {
      List responseJson = json.decode(value.toString());
      _wordList = responseJson.map((m) => new WordBean.fromJson(m)).toList();
    });

    return MaterialApp(
      title: 'English Word',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'English Word Study'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _ranInt = 0;
  String _wordStr = "word";
  String _wordTran = "单词翻译";

  void _genWord() {
    setState(() {
      _ranInt = new Random().nextInt(3878);
      _wordStr = _wordList[_ranInt].word;
      _wordTran = "";
    });
  }

  void _genTranslate() {
    setState(() {
      _wordTran = _wordList[_ranInt].translate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _wordStr,
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              _wordTran,
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  var _selectedIndex = 0;

  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      showSelectedLabels: true,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.help_outline),
          title: Text('Random Word'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.how_to_reg_outlined),
          title: Text('Translate'),
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 0) {
          _genWord();
        } else {
          _genTranslate();
        }
        //setState(() {});
      },
    );
  }
}
