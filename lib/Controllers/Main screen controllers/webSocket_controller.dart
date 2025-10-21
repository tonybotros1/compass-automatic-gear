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
    try {
      channel = WebSocketChannel.connect(Uri.parse(webSocketURL));

      channel!.stream.listen(
        (event) {
          try {
            final message = jsonDecode(event);
            _events.add(message);
          } catch (e) {
            // print("WS decode error: $e");
          }
        },
        onError: (error) {
          // print("⚠️ WebSocket error: $error");
          channel = null;
          Future.delayed(
            const Duration(seconds: 2),
            connect,
          ); // 🔁 auto reconnect
        },
        onDone: () {
          // print("🔌 WebSocket disconnected, reconnecting...");
          channel = null;
          Future.delayed(
            const Duration(seconds: 2),
            connect,
          ); // 🔁 auto reconnect
        },
      );
    } catch (e) {
      channel = null;
      Future.delayed(
        const Duration(seconds: 3),
        connect,
      ); // Retry after short delay
    }
  }
}
