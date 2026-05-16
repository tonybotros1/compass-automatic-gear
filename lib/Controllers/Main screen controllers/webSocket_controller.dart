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
  String? _companyId;
  Timer? _reconnectTimer;
  bool manualClose = false;

  void _scheduleReconnect([Duration delay = const Duration(seconds: 2)]) {
    if (manualClose ||
        _userId == null ||
        _userId!.isEmpty ||
        _companyId == null ||
        _companyId!.isEmpty) {
      return;
    }
    if (_reconnectTimer?.isActive ?? false) return;

    _reconnectTimer = Timer(delay, () {
      _reconnectTimer = null;
      if (channel == null &&
          !manualClose &&
          _userId != null &&
          _userId!.isNotEmpty &&
          _companyId != null &&
          _companyId!.isNotEmpty) {
        connect(_userId, _companyId);
      }
    });
  }

  void connect(String? userId, String? companyId) {
    final normalizedUserId = (userId ?? '').trim();
    final normalizedCompanyId = (companyId ?? '').trim();

    if (normalizedUserId.isEmpty || normalizedCompanyId.isEmpty) return;

    if (channel != null &&
        _userId == normalizedUserId &&
        _companyId == normalizedCompanyId) {
      return;
    }

    if (channel != null) {
      channel?.sink.close();
      channel = null;
    }
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    _userId = normalizedUserId;
    _companyId = normalizedCompanyId;
    try {
      manualClose = false;
      final nextChannel = WebSocketChannel.connect(
        Uri.parse('$webSocketURL/$normalizedCompanyId/$normalizedUserId'),
      );
      channel = nextChannel;

      unawaited(
        nextChannel.ready.then<void>(
          (_) {},
          onError: (Object error, StackTrace stackTrace) {
            if (channel == nextChannel) {
              channel = null;
              _scheduleReconnect();
            }
          },
        ),
      );

      nextChannel.stream.listen(
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
          if (channel == nextChannel) channel = null;
          _scheduleReconnect();
        },
        onDone: () {
          // print("🔌 WebSocket disconnected, reconnecting...");
          if (channel == nextChannel) channel = null;
          _scheduleReconnect();
        },
      );
    } catch (e) {
      channel = null;
      _scheduleReconnect(const Duration(seconds: 3));
    }
  }

  void disconnect() {
    manualClose = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    channel?.sink.close();
    channel = null;
    _userId = null;
    _companyId = null;
  }
}
