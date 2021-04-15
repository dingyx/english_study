import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

// 语音合成工具
class TTS {
  // 初始化语音合成 TTS
  FlutterTts flutterTts;

  TTS() {
    initDefault();
  }

  // speechRate-语速、pitch-音调
  init(String language, double volume, double speechRate, double pitch) {
    try {
      flutterTts = FlutterTts();
      flutterTts.setLanguage(language);
      flutterTts.setVolume(volume);
      flutterTts.setSpeechRate(speechRate);
      flutterTts.setPitch(pitch);
    } catch (ignored) {}
  }

  initDefault() {
    try {
      flutterTts = FlutterTts();
      flutterTts.setLanguage("en-US");
      flutterTts.setVolume(1.0);
      flutterTts.setSpeechRate(0.8);
      flutterTts.setPitch(1.0);
    } catch (ignored) {}
  }

  // speak text
  speak(String text) {
    flutterTts?.speak(text);
  }
}

class ImageUtil {
  // 获取背景图 图片放在阿里云服务器
  static String getBgUrl() {
    int random = new Random().nextInt(5);
    return "https://dingyx.oss-cn-shenzhen.aliyuncs.com/english_study/bg_${random.toString()}.jpg";
  }
}


class ScreenUtil {

  // 判断竖屏还是横屏
  static bool isVerticalScreen(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return height > width;
  }

}
