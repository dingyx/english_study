import 'dart:math';

import 'package:english_study/tts/tts.dart';
import 'package:flutter/cupertino.dart';


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



// 语音合成TTS
TTS tts;

class TTSUtil {
  void init() {
    try {
      tts = TTS("5c6773a0", "df3c408ba7edde33a2b94103f3c15f4d", "97151de07567790f5fe8566ed8aa071b");
    } catch (ignored) {
      print("tts 初始化异常" + ignored.toString());
    }
  }

// speak text
  speak(String text) async {
    tts?.generateAndPlay(text);
  }
}