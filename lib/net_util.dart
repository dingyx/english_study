import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class SycaHttp {
  Dio dio;

  void init() {
    //统一配置dio
    dio = Dio();
    dio.options.baseUrl = "http://open.iciba.com"; //baseUrl
    dio.options.connectTimeout = 5000; //超时时间
    dio.options.receiveTimeout = 3000; //接收数据最长时间
    dio.options.responseType = ResponseType.bytes; //数据格式
  }

  void dioGet() async {
    Response response =
        await dio.get("/dsapi", queryParameters: {"date": "2021-04-14"});
    if (response.statusCode == HttpStatus.ok) {
      print(utf8.decode(response.data));
    }
  }
}
