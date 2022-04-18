import 'package:enmitydebugger/controllers/logger.dart';
import 'package:enmitydebugger/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'controllers/websocket.dart';

void main() async {
  Get.put(LoggerController());
  Get.put(WebsocketController());

  runApp(const EnmityDebug());
}

class EnmityDebug extends StatelessWidget {
  const EnmityDebug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enmity Debugger',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const DebugPage(),
    );
  }
}

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  State<DebugPage> createState() => _DebubPageState();
}

class _DebubPageState extends State<DebugPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Color inputBackgroundColor = const Color(0xFF292B2F);

  void sendMessage() {
    String message = _textEditingController.text;
    Get.find<WebsocketController>().sendMessage(message);
    Get.find<LoggerController>().addMessage(
      Message(
        1,
        message,
        "Debugger"
      )
    );
    //_scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36393F),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: GetBuilder<LoggerController>(
              builder: (controller) => ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: controller.message.length,
                itemBuilder: (context, index) {
                  final item = controller.message.reversed.toList()[index];
                  return Card(
                    color: Colors.transparent,
                    shadowColor: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: item.message));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.source,
                            style: const TextStyle(
                              color: Color(item.source == 'Debugger' ? 0xFF4440B0 : 0xFF5662F6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(item.message)
                        ],
                      ),
                    ),
                  );
                },
              )
            )
          ),
          Divider(
            color: inputBackgroundColor,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 5,
              bottom: 10,
            ),
            child: TextField(
              controller: _textEditingController,
              style: const TextStyle(
                fontSize: 12,
              ),
              cursorColor: const Color(0xFF6C6F76),
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: inputBackgroundColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(100)
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    sendMessage();
                    _textEditingController.clear();
                  },
                  icon: const Icon(Icons.send)
                )
              ),
              onSubmitted: (text) {
                sendMessage();
                _textEditingController.clear();
              },
            ),
          )
        ],
      )
    );
  }
}
