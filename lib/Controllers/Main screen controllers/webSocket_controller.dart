import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../consts.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? channel;
  final _events = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _events.stream;
  String? _userId;
  bool manualClose = false;
  void connect(String? userId) {
    _userId = userId;
    if (channel != null) return; // don’t reconnect per screen
    try {
      manualClose = false;
      channel = WebSocketChannel.connect(Uri.parse('$webSocketURL/$userId'));

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
          if (manualClose || _userId == null) return;
          Future.delayed(const Duration(seconds: 2), () {
            if (channel == null && _userId != null) {
              connect(_userId!);
            }
          }); // 🔁 auto reconnect
        },
        onDone: () {
          // print("🔌 WebSocket disconnected, reconnecting...");
          channel = null;
          Future.delayed(const Duration(seconds: 2), () {
            if (channel == null && _userId != null) {
              connect(_userId!);
            }
          }); // 🔁 auto reconnect
        },
      );
    } catch (e) {
      channel = null;
      Future.delayed(const Duration(seconds: 3), () {
        if (channel == null && _userId != null) {
          connect(_userId!);
        }
      }); // Retry after short delay
    }
  }

  void disconnect() {
    manualClose = true;
    channel?.sink.close();
    channel = null;
  }
}
