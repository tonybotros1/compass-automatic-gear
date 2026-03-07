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
    final normalizedUserId = (userId ?? '').trim();
    if (normalizedUserId.isEmpty) return;

    if (channel != null && _userId == normalizedUserId) return;

    if (channel != null && _userId != normalizedUserId) {
      channel?.sink.close();
      channel = null;
    }

    _userId = normalizedUserId;
    try {
      manualClose = false;
      channel = WebSocketChannel.connect(
        Uri.parse('$webSocketURL/$normalizedUserId'),
      );

      channel!.stream.listen(
        (event) {
          try {
            final raw = event?.toString() ?? '';
            if (raw.trim().isEmpty) return;

            final decoded = jsonDecode(raw);
            if (decoded is Map<String, dynamic>) {
              final message = Map<String, dynamic>.from(decoded);
              final payload = message['data'];
              if (payload == null) {
                message['data'] = <String, dynamic>{};
              } else if (payload is Map) {
                message['data'] = Map<String, dynamic>.from(payload);
              } else {
                message['data'] = <String, dynamic>{};
              }
              _events.add(message);
              return;
            }
            if (decoded is Map) {
              final message = Map<String, dynamic>.from(decoded);
              final payload = message['data'];
              if (payload == null) {
                message['data'] = <String, dynamic>{};
              } else if (payload is Map) {
                message['data'] = Map<String, dynamic>.from(payload);
              } else {
                message['data'] = <String, dynamic>{};
              }
              _events.add(message);
            }
          } catch (e) {
            // print("WS decode error: $e");
          }
        },
        onError: (error) {
          // print("⚠️ WebSocket error: $error");
          channel = null;
          if (manualClose || _userId == null || _userId!.isEmpty) return;
          Future.delayed(const Duration(seconds: 2), () {
            if (channel == null && _userId != null && _userId!.isNotEmpty) {
              connect(_userId);
            }
          }); // 🔁 auto reconnect
        },
        onDone: () {
          // print("🔌 WebSocket disconnected, reconnecting...");
          channel = null;
          if (manualClose || _userId == null || _userId!.isEmpty) return;
          Future.delayed(const Duration(seconds: 2), () {
            if (channel == null && _userId != null && _userId!.isNotEmpty) {
              connect(_userId);
            }
          }); // 🔁 auto reconnect
        },
      );
    } catch (e) {
      channel = null;
      Future.delayed(const Duration(seconds: 3), () {
        if (channel == null && _userId != null && _userId!.isNotEmpty) {
          connect(_userId);
        }
      }); // Retry after short delay
    }
  }

  void disconnect() {
    manualClose = true;
    channel?.sink.close();
    channel = null;
    _userId = null;
  }
}
