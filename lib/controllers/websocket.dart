import 'dart:convert';
import 'dart:io';

import 'package:enmitydebugger/controllers/logger.dart';
import 'package:enmitydebugger/models/message.dart';
import 'package:get/get.dart';

class WebsocketController extends GetxController {
  Future<void> startWebsocketServer() async {
    HttpServer server = await HttpServer.bind("0.0.0.0", 9090);
    server.transform(WebSocketTransformer()).listen(onWebSocketData);
  }

  WebSocket? _client;

  void sendMessage(String message) {
    _client?.add(message);
  }

  void onWebSocketData(WebSocket client) {
    _client = client;
    client.add('console.log("Debugger successfully attached.")');

    client.listen((data) {
      try {
        Map<dynamic, dynamic> dataJson = jsonDecode(data.toString());

        String message = dataJson["message"];
        if (message == "undefined") return;

        int level = dataJson["level"];

        Get.find<LoggerController>().addMessage(
          Message(
            level,
            message,
            "Discord"
          )
        );
      } catch(err) {
        print(err);
      }
    });
  }

  @override
  void onInit() {
    startWebsocketServer();
    super.onInit();
  }
}