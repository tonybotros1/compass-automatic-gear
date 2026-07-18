import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import '../../helpers.dart';
import '../Main screen controllers/websocket_controller.dart';

class AdminActiveSession {
  const AdminActiveSession({
    required this.id,
    required this.isCurrentSession,
    required this.isOnline,
    required this.ipAddress,
    required this.userAgent,
    this.loginAt,
    this.lastSeenAt,
    this.expiresAt,
  });

  final String id;
  final bool isCurrentSession;
  final bool isOnline;
  final String ipAddress;
  final String userAgent;
  final DateTime? loginAt;
  final DateTime? lastSeenAt;
  final DateTime? expiresAt;

  static DateTime? _date(dynamic value) {
    final parsed = DateTime.tryParse(value?.toString() ?? '');
    return parsed?.toLocal();
  }

  factory AdminActiveSession.fromJson(Map<String, dynamic> json) {
    return AdminActiveSession(
      id: json['id']?.toString() ?? '',
      isCurrentSession: json['is_current_session'] == true,
      isOnline: json['is_online'] == true,
      ipAddress: json['ip_address']?.toString() ?? '',
      userAgent: json['user_agent']?.toString() ?? '',
      loginAt: _date(json['login_at']),
      lastSeenAt: _date(json['last_seen_at']),
      expiresAt: _date(json['expires_at']),
    );
  }

  String get deviceLabel {
    final agent = userAgent.toLowerCase();
    final browser = agent.contains('edg/')
        ? 'Edge'
        : agent.contains('chrome/')
        ? 'Chrome'
        : agent.contains('firefox/')
        ? 'Firefox'
        : agent.contains('safari/')
        ? 'Safari'
        : userAgent.isEmpty
        ? 'Unknown browser'
        : 'Other browser';
    final platform = agent.contains('iphone') || agent.contains('ipad')
        ? 'iOS'
        : agent.contains('android')
        ? 'Android'
        : agent.contains('windows')
        ? 'Windows'
        : agent.contains('macintosh') || agent.contains('mac os')
        ? 'macOS'
        : agent.contains('linux')
        ? 'Linux'
        : 'Unknown device';
    return '$browser · $platform';
  }
}

class AdminUserSession {
  const AdminUserSession({
    required this.id,
    required this.userName,
    required this.email,
    required this.isCurrentUser,
    required this.isAdmin,
    required this.enabled,
    required this.expired,
    required this.isOnline,
    required this.connectionCount,
    required this.activeSessions,
    required this.sessions,
    required this.roles,
    required this.branches,
    required this.primaryBranch,
    required this.ipAddress,
    required this.userAgent,
    this.loginAt,
    this.onlineSince,
    this.lastSeenAt,
    this.lastLogoutAt,
    this.forcedLogoutAt,
    this.expiryDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userName;
  final String email;
  final bool isCurrentUser;
  final bool isAdmin;
  final bool enabled;
  final bool expired;
  final bool isOnline;
  final int connectionCount;
  final int activeSessions;
  final List<AdminActiveSession> sessions;
  final List<String> roles;
  final List<String> branches;
  final String primaryBranch;
  final String ipAddress;
  final String userAgent;
  final DateTime? loginAt;
  final DateTime? onlineSince;
  final DateTime? lastSeenAt;
  final DateTime? lastLogoutAt;
  final DateTime? forcedLogoutAt;
  final DateTime? expiryDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  static DateTime? _date(dynamic value) {
    final parsed = DateTime.tryParse(value?.toString() ?? '');
    return parsed?.toLocal();
  }

  static int _int(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static List<String> _strings(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }

  factory AdminUserSession.fromJson(Map<String, dynamic> json) {
    return AdminUserSession(
      id: json['id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isCurrentUser: json['is_current_user'] == true,
      isAdmin: json['is_admin'] == true,
      enabled: json['enabled'] == true,
      expired: json['expired'] == true,
      isOnline: json['is_online'] == true,
      connectionCount: _int(json['connection_count']),
      activeSessions: _int(json['active_sessions']),
      sessions: json['sessions'] is List
          ? (json['sessions'] as List)
                .whereType<Map>()
                .map(
                  (session) => AdminActiveSession.fromJson(
                    Map<String, dynamic>.from(session),
                  ),
                )
                .where((session) => session.id.isNotEmpty)
                .toList()
          : const <AdminActiveSession>[],
      roles: _strings(json['roles']),
      branches: _strings(json['branches']),
      primaryBranch: json['primary_branch']?.toString() ?? '',
      ipAddress: json['ip_address']?.toString() ?? '',
      userAgent: json['user_agent']?.toString() ?? '',
      loginAt: _date(json['login_at']),
      onlineSince: _date(json['online_since']),
      lastSeenAt: _date(json['last_seen_at']),
      lastLogoutAt: _date(json['last_logout_at']),
      forcedLogoutAt: _date(json['forced_logout_at']),
      expiryDate: _date(json['expiry_date']),
      createdAt: _date(json['created_at']),
      updatedAt: _date(json['updated_at']),
    );
  }

  String get accessLabel {
    if (!enabled) return 'Disabled';
    if (expired) return 'Expired';
    return 'Active';
  }

  String get deviceLabel {
    final agent = userAgent.toLowerCase();
    final browser = agent.contains('edg/')
        ? 'Edge'
        : agent.contains('chrome/')
        ? 'Chrome'
        : agent.contains('firefox/')
        ? 'Firefox'
        : agent.contains('safari/')
        ? 'Safari'
        : userAgent.isEmpty
        ? 'Unknown device'
        : 'Other browser';
    final platform = agent.contains('iphone') || agent.contains('ipad')
        ? 'iOS'
        : agent.contains('android')
        ? 'Android'
        : agent.contains('windows')
        ? 'Windows'
        : agent.contains('macintosh') || agent.contains('mac os')
        ? 'macOS'
        : agent.contains('linux')
        ? 'Linux'
        : '';
    return platform.isEmpty ? browser : '$browser · $platform';
  }
}

class AdminScreenController extends GetxController {
  static const String adminPassword = 'd@t@hub@i';

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final RxBool isUnlocked = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString filter = 'all'.obs;
  final RxString query = ''.obs;
  final Rx<DateTime> clock = DateTime.now().obs;
  final RxList<AdminUserSession> users = <AdminUserSession>[].obs;
  final RxMap<String, dynamic> summary = <String, dynamic>{}.obs;
  final RxMap<String, bool> actionLoading = <String, bool>{}.obs;
  final WebSocketService _webSocket = Get.find<WebSocketService>();

  Timer? _clockTimer;
  Timer? _refreshTimer;
  StreamSubscription<Map<String, dynamic>>? _eventsSubscription;
  String backendUrl = backendTestURI;

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      query.value = searchController.text.trim().toLowerCase();
    });
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      clock.value = DateTime.now();
    });
    _eventsSubscription = _webSocket.events.listen((message) {
      if (message['type'] == 'admin_users_changed' && isUnlocked.isTrue) {
        unawaited(fetchOverview(silent: true));
      }
    });
  }

  @override
  void onClose() {
    _clockTimer?.cancel();
    _refreshTimer?.cancel();
    _eventsSubscription?.cancel();
    passwordController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> unlock() async {
    if (passwordController.text != adminPassword) {
      errorMessage.value = 'Incorrect administrator password';
      return;
    }
    errorMessage.value = '';
    isUnlocked.value = true;
    passwordController.clear();
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      unawaited(fetchOverview(silent: true));
    });
    await fetchOverview();
  }

  void lock() {
    _refreshTimer?.cancel();
    isUnlocked.value = false;
    obscurePassword.value = true;
    users.clear();
    summary.clear();
    searchController.clear();
    filter.value = 'all';
    errorMessage.value = '';
  }

  void togglePasswordVisibility() => obscurePassword.toggle();

  List<AdminUserSession> get visibleUsers {
    final selectedFilter = filter.value;
    final search = query.value;
    return users.where((user) {
      final matchesFilter = switch (selectedFilter) {
        'online' => user.isOnline,
        'offline' => !user.isOnline,
        'disabled' => !user.enabled,
        'expired' => user.expired,
        _ => true,
      };
      if (!matchesFilter) return false;
      if (search.isEmpty) return true;
      final haystack = [
        user.userName,
        user.email,
        user.ipAddress,
        user.deviceLabel,
        user.roles.join(' '),
        user.branches.join(' '),
      ].join(' ').toLowerCase();
      return haystack.contains(search);
    }).toList();
  }

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'Authorization': 'Bearer ${prefs.getString('accessToken') ?? ''}',
      'Content-Type': 'application/json',
      'X-Admin-Password': adminPassword,
    };
  }

  Map<String, dynamic> _jsonObject(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      // The caller uses a friendly fallback message.
    }
    return {};
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await secureStorage.read(key: 'refreshToken') ?? '';
    if (refreshToken.isEmpty || refreshToken == 'null') return false;
    final refreshed = await helper.refreshAccessToken(refreshToken);
    if (refreshed == RefreshResult.success) return true;
    if (refreshed == RefreshResult.invalidToken) await logout();
    return false;
  }

  Future<void> fetchOverview({
    bool silent = false,
    bool canRefresh = true,
  }) async {
    if (!isUnlocked.value || isLoading.value || isRefreshing.value) return;
    if (silent) {
      isRefreshing.value = true;
    } else {
      isLoading.value = true;
    }
    try {
      final response = await http.get(
        Uri.parse('$backendUrl/admin/users_overview'),
        headers: await _headers(),
      );
      if (response.statusCode == 200) {
        final decoded = _jsonObject(response.body);
        final rawUsers = decoded['users'];
        users.assignAll(
          rawUsers is List
              ? rawUsers.whereType<Map>().map(
                  (row) =>
                      AdminUserSession.fromJson(Map<String, dynamic>.from(row)),
                )
              : const <AdminUserSession>[],
        );
        final rawSummary = decoded['summary'];
        summary.assignAll(
          rawSummary is Map ? Map<String, dynamic>.from(rawSummary) : {},
        );
        errorMessage.value = '';
      } else if (response.statusCode == 401 && canRefresh) {
        if (await _refreshAccessToken()) {
          isLoading.value = false;
          isRefreshing.value = false;
          return fetchOverview(silent: silent, canRefresh: false);
        }
      } else if (response.statusCode == 403) {
        lock();
        errorMessage.value =
            _jsonObject(response.body)['detail']?.toString() ??
            'Administrator access was denied';
      } else {
        errorMessage.value =
            _jsonObject(response.body)['detail']?.toString() ??
            'Could not load users';
      }
    } catch (_) {
      errorMessage.value = 'Could not connect to the admin service';
    } finally {
      isLoading.value = false;
      isRefreshing.value = false;
    }
  }

  Future<bool> forceLogout(AdminUserSession user) async {
    return _performAction(
      key: 'logout:${user.id}',
      request: () async => http.post(
        Uri.parse('$backendUrl/admin/users/${user.id}/force_logout'),
        headers: await _headers(),
      ),
    );
  }

  Future<bool> forceLogoutSession(
    AdminUserSession user,
    AdminActiveSession session,
  ) async {
    return _performAction(
      key: 'session:${user.id}:${session.id}',
      request: () async => http.delete(
        Uri.parse('$backendUrl/admin/users/${user.id}/sessions/${session.id}'),
        headers: await _headers(),
      ),
    );
  }

  AdminUserSession? userById(String id) {
    for (final user in users) {
      if (user.id == id) return user;
    }
    return null;
  }

  Future<bool> forceLogoutAll() async {
    return _performAction(
      key: 'logout:all',
      request: () async => http.post(
        Uri.parse('$backendUrl/admin/force_logout_all'),
        headers: await _headers(),
      ),
    );
  }

  Future<bool> setUserEnabled(AdminUserSession user, bool enabled) async {
    return _performAction(
      key: 'status:${user.id}',
      request: () async => http.patch(
        Uri.parse('$backendUrl/admin/users/${user.id}/status'),
        headers: await _headers(),
        body: jsonEncode({'status': enabled}),
      ),
    );
  }

  Future<bool> _performAction({
    required String key,
    required Future<http.Response> Function() request,
    bool canRefresh = true,
  }) async {
    if (actionLoading[key] == true) return false;
    actionLoading[key] = true;
    try {
      final response = await request();
      final decoded = _jsonObject(response.body);
      if (response.statusCode == 200) {
        showSnackBar('Done', decoded['message']?.toString() ?? 'Updated');
        await fetchOverview(silent: true);
        return true;
      }
      if (response.statusCode == 401 && canRefresh) {
        if (await _refreshAccessToken()) {
          actionLoading[key] = false;
          return _performAction(key: key, request: request, canRefresh: false);
        }
      }
      showSnackBar(
        'Alert',
        decoded['detail']?.toString() ?? 'The action could not be completed',
      );
      return false;
    } catch (_) {
      showSnackBar('Alert', 'Could not connect to the admin service');
      return false;
    } finally {
      actionLoading[key] = false;
    }
  }

  bool isActionBusy(String key) => actionLoading[key] == true;

  String onlineDuration(AdminUserSession user) {
    if (!user.isOnline || user.onlineSince == null) return '—';
    final duration = clock.value.difference(user.onlineSince!);
    final safe = duration.isNegative ? Duration.zero : duration;
    final days = safe.inDays;
    final hours = safe.inHours.remainder(24);
    final minutes = safe.inMinutes.remainder(60);
    final seconds = safe.inSeconds.remainder(60);
    if (days > 0) return '${days}d ${hours}h ${minutes}m';
    if (safe.inHours > 0) return '${safe.inHours}h ${minutes}m';
    return '${safe.inMinutes}m ${seconds}s';
  }
}
