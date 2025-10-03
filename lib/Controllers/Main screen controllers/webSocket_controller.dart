import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../consts.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? channel;
  final _events = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _events.stream;

  void connect() {
    if (channel != null) return; // don’t reconnect per screen
    channel = WebSocketChannel.connect(Uri.parse(webSocketURL));

    channel!.stream.listen((event) {
      try {
        final message = jsonDecode(event);
        _events.add(message);
      } catch (e) {
        // print("WS decode error: $e");
      }
    });
  }
}
