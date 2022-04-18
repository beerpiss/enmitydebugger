import 'dart:collection';
import 'dart:io';

import 'package:get/get.dart';
import '../models/message.dart';

class LoggerController extends GetxController {
  // Messages list
  final List<Message> _messages = <Message>[];
  UnmodifiableListView<Message> get message => UnmodifiableListView(_messages);

  void writeToLogFile(Message message) async {
    File file = File('sex.log');
    file.writeAsStringSync(message.message + "\n", mode: FileMode.append);
  }

  void addMessage(Message message) async {
    //writeToLogFile(message);
    _messages.add(message);
    update();
  }
}