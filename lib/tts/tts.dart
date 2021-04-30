import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';

/// Xunfei TTS main class.
/// Usage:
///
///   var tts = TTS(appId, apiKey, apiSecret);
///   await tts.generateMp3ForText(text, filename);
class TTS {
  AudioPlayer audioPlayer;
  final String appId;
  final String apiKey;
  final String apiSecret;
  final String vcn;
  final int speed;
  final int volume;

  TTS(
    this.appId,
    this.apiKey,
    this.apiSecret, {
    this.vcn = 'xiaoyan',
    this.speed = 50,
    this.volume = 100,
  })  : assert(appId != null),
        assert(apiKey != null),
        assert(apiSecret != null) {
    print('apiKey=$apiKey, apiSecret=$apiSecret');
    audioPlayer = AudioPlayer();
  }

  /// generate connect url, based on doc in: https://www.xfyun.cn/doc/tts/online_tts/API.html
  String _getConnUrl() {
    final requestHost = 'tts-api.xfyun.cn';
    final host = 'ws-api.xfyun.cn';
    final url = '/v2/tts';
    final date = HttpDate.format(DateTime.now());
    final signatureOrigin = 'host: $host\ndate: $date\nGET $url HTTP/1.1';

    var hmacSha256 = Hmac(sha256, utf8.encode(apiSecret));
    final hash = hmacSha256.convert(utf8.encode(signatureOrigin));
    final signature = base64.encode(hash.bytes);

    final authOrigin = 'api_key="$apiKey", algorithm="hmac-sha256", '
        'headers="host date request-line", signature="$signature"';
    final authorization = base64.encode(utf8.encode(authOrigin));
    return 'wss://$requestHost$url?authorization=$authorization'
        '&date=${Uri.encodeFull(date)}&host=$host';
  }

  /// generate the request params, based on: generate connect url, based on doc in: https://www.xfyun.cn/doc/tts/online_tts/API.html
  String _genParam(String text) {
    final common = {'app_id': appId};
    final business = {
      'aue': 'lame',
      'sfl': 1,
      'auf': 'audio/L16;rate=16000',
      'vcn': vcn,
      'speed': speed,
      'volume': volume,
      'tte': 'utf8',
    };
    final data = {
      'status': 2,
      'text': base64.encode(utf8.encode(text)),
    };
    return json.encode({
      'common': common,
      'business': business,
      'data': data,
    });
  }

  /// generate mp3 based for the given text (must be smaller than max limit - 8000)
  Future<List<Uint8List>> _generateOne(String text) async {
    final url = _getConnUrl();
    print("url:" + url);
    try {
      var ws = await WebSocket.connect(url);
      print("ws:" + ws.readyState.toString());
      if (ws?.readyState != WebSocket.open) {
        throw ('connection denied');
      }
      ws.add(_genParam(text));
      return ws.map((data) {
        final res = json.decode(data);

        print("code:" + res['code']);
        print("data:" + res['data']);

        if (res['code'] != 0) {
          throw ('code not zero: $res');
        }
        stdout.write('${res['data']['ced']} ');
        if (res['data']['status'] == 2) {
          stdout.write('\n');
          ws.close();
        }
        if (res['data']['audio'] != null) {
          return base64.decode(res['data']['audio']);
        }

        return base64.decode('');
      }).toList();
    } catch (ignored) {
      print("error " + ignored.toString());
    }
  }

  Future<List<Uint8List>> generateByte(String text, {splitAt = 8000}) async {
    var result = <Uint8List>[];
    final buffers = await _generateOne(text);
    for (final buffer in buffers) {
      result.add(buffer);
    }
    return result;
  }

  // 生成 MP3 然后播放
  void generateAndPlay(String text, {splitAt = 8000}) {
    print("generateAndPlay $text");
    generateByte(text, splitAt: splitAt).then((result) {
      print("接口返回的数据是:$result");
      audioPlayer.playBytes(result.first);
    }).whenComplete(() {
      print("异步任务处理完成");
    }).catchError(() {
      print("出现异常了");
    });
  }
}
