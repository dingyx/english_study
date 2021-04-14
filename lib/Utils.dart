import 'package:flutter_tts/flutter_tts.dart';

// 语音合成工具
class TTS {
  // 初始化语音合成 TTS
  FlutterTts flutterTts;

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

  initDefault(){
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
