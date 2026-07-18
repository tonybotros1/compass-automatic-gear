import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../consts.dart';

class WebSocketService extends GetxService {
  WebSocketChannel? channel;
  final _events = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get events => _events.stream;
  String? _userId;
  String? _companyId;
  String? _sessionId;
  Timer? _reconnectTimer;
  int _connectionGeneration = 0;
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
    final generation = ++_connectionGeneration;
    unawaited(_connect(userId, companyId, generation));
  }

  Future<void> _connect(
    String? userId,
    String? companyId,
    int generation,
  ) async {
    final normalizedUserId = (userId ?? '').trim();
    final normalizedCompanyId = (companyId ?? '').trim();

    if (normalizedUserId.isEmpty || normalizedCompanyId.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    if (generation != _connectionGeneration) return;
    final normalizedSessionId = prefs.getString('sessionId')?.trim() ?? '';

    if (channel != null &&
        _userId == normalizedUserId &&
        _companyId == normalizedCompanyId &&
        _sessionId == normalizedSessionId) {
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
    _sessionId = normalizedSessionId;
    try {
      manualClose = false;
      final nextChannel = WebSocketChannel.connect(
        Uri.parse(
          '$webSocketURL/$normalizedCompanyId/$normalizedUserId',
        ).replace(
          queryParameters: normalizedSessionId.isEmpty
              ? null
              : {'session_id': normalizedSessionId},
        ),
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
              if (message['type'] == 'force_logout') {
                unawaited(_handleForcedLogout(message));
                return;
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
              if (message['type'] == 'force_logout') {
                unawaited(_handleForcedLogout(message));
                return;
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
    _connectionGeneration++;
    manualClose = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    channel?.sink.close();
    channel = null;
    _userId = null;
    _companyId = null;
    _sessionId = null;
  }

  Future<void> _handleForcedLogout(Map<String, dynamic> message) async {
    _connectionGeneration++;
    manualClose = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    channel?.sink.close();
    channel = null;
    _userId = null;
    _companyId = null;
    _sessionId = null;

    final prefs = await SharedPreferences.getInstance();
    await secureStorage.delete(key: 'refreshToken');
    await Future.wait([
      prefs.remove('accessToken'),
      prefs.remove('userEmail'),
      prefs.remove('companyId'),
      prefs.remove('userId'),
      prefs.remove('sessionId'),
    ]);

    final data = message['data'];
    final reason = data is Map ? data['reason']?.toString().trim() ?? '' : '';
    Get.offAllNamed('/loginScreen');
    showSnackBar(
      'Session Ended',
      reason.isEmpty ? 'Your session was ended by the administrator' : reason,
    );
  }
}
