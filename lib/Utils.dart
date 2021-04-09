import 'package:flutter_tts/flutter_tts.dart';

// 语音合成工具
class TTS {

  // 初始化语音合成 TTS
  FlutterTts flutterTts = FlutterTts();

  // speechRate-语速、pitch-音调
  init(String language, double volume, double speechRate, double pitch) {
    flutterTts.setLanguage(language);
    flutterTts.setVolume(volume);
    flutterTts.setSpeechRate(speechRate);
    flutterTts.setPitch(pitch);
  }

  // speak text
  speak(String text) {
    flutterTts.speak(text);
  }

}
