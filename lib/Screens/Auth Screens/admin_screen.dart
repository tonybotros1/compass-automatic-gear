import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Auth screen controllers/admin_screen_controller.dart';

const _pageBackground = Color(0xFFF5F8FB);
const _surface = Colors.white;
const _surfaceSoft = Color(0xFFF8FAFC);
const _line = Color(0xFFDCE6EE);
const _text = Color(0xFF203044);
const _muted = Color(0xFF718196);
const _primary = Color(0xFF0C7C86);
const _primarySoft = Color(0xFFE7F7F8);
const _green = Color(0xFF26945B);
const _greenSoft = Color(0xFFEAF8F0);
const _red = Color(0xFFD95555);
const _redSoft = Color(0xFFFFEEEE);
const _orange = Color(0xFFC67A16);
const _orangeSoft = Color(0xFFFFF5E5);
const _blue = Color(0xFF3479B9);
const _blueSoft = Color(0xFFEDF5FC);

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final AdminScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AdminScreenController());
  }

  @override
  void dispose() {
    controller.lock();
    if (Get.isRegistered<AdminScreenController>()) {
      Get.delete<AdminScreenController>(force: true);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _pageBackground,
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: controller.isUnlocked.value
              ? _AdminDashboard(controller: controller)
              : _AdminPasswordGate(controller: controller),
        ),
      ),
    );
  }
}

class _AdminPasswordGate extends StatelessWidget {
  const _AdminPasswordGate({required this.controller});

  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: const ValueKey('admin-password-gate'),
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
            child: Center(
              child: Container(
                width: 440,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _line),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x16192D43),
                      blurRadius: 34,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: _primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: _primary,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Administrator Access',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _text,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enter the administrator password to open the user control center.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _muted,
                        height: 1.55,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => TextField(
                        controller: controller.passwordController,
                        obscureText: controller.obscurePassword.value,
                        autofocus: true,
                        onSubmitted: (_) => controller.unlock(),
                        decoration: _inputDecoration(
                          hint: 'Administrator password',
                          icon: Icons.lock_outline_rounded,
                          errorText: controller.errorMessage.value.isEmpty
                              ? null
                              : controller.errorMessage.value,
                          suffix: IconButton(
                            tooltip: controller.obscurePassword.value
                                ? 'Show password'
                                : 'Hide password',
                            onPressed: controller.togglePasswordVisibility,
                            icon: Icon(
                              controller.obscurePassword.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 19,
                              color: _muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: FilledButton.icon(
                        onPressed: controller.unlock,
                        style: FilledButton.styleFrom(
                          backgroundColor: _primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        icon: const Icon(Icons.lock_open_rounded, size: 18),
                        label: const Text('UNLOCK USER CONTROL'),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined, color: _green, size: 15),
                        SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            'Protected company administration area',
                            style: TextStyle(color: _muted, fontSize: 10.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard({required this.controller});

  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('admin-dashboard'),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _DashboardHeader(controller: controller),
          const SizedBox(height: 10),
          Obx(
            () => _SummaryStrip(
              summary: controller.summary,
              isRefreshing: controller.isRefreshing.value,
            ),
          ),
          const SizedBox(height: 10),
          _FilterBar(controller: controller),
          const SizedBox(height: 10),
          Expanded(child: _UsersPanel(controller: controller)),
        ],
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.controller});

  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final title = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _primarySoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.manage_accounts_rounded,
                  color: _primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Control Center',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _text,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Live access, sessions and account controls',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _muted, fontSize: 10.5),
                    ),
                  ],
                ),
              ),
            ],
          );
          final actions = Wrap(
            spacing: 7,
            runSpacing: 7,
            alignment: WrapAlignment.end,
            children: [
              Obx(
                () => _HeaderButton(
                  label: 'Refresh',
                  icon: Icons.refresh_rounded,
                  busy: controller.isRefreshing.value,
                  onTap: () => controller.fetchOverview(silent: true),
                ),
              ),
              Obx(
                () => _HeaderButton(
                  label: 'Log Out All',
                  icon: Icons.power_settings_new_rounded,
                  foreground: _red,
                  background: _redSoft,
                  busy: controller.isActionBusy('logout:all'),
                  onTap: () => _confirmLogoutAll(context, controller),
                ),
              ),
              _HeaderButton(
                label: 'Lock',
                icon: Icons.lock_outline_rounded,
                onTap: controller.lock,
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title,
                const SizedBox(height: 12),
                Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: title),
              const SizedBox(width: 14),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.summary, required this.isRefreshing});

  final Map<String, dynamic> summary;
  final bool isRefreshing;

  int _value(String key) {
    final value = summary[key];
    return value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryData(
        'Total Users',
        _value('total_users'),
        Icons.groups_2_rounded,
        _blue,
        _blueSoft,
      ),
      _SummaryData(
        'Online Now',
        _value('online_users'),
        Icons.online_prediction_rounded,
        _green,
        _greenSoft,
      ),
      _SummaryData(
        'Active Accounts',
        _value('enabled_users'),
        Icons.verified_user_outlined,
        _primary,
        _primarySoft,
      ),
      _SummaryData(
        'Active Sessions',
        _value('active_sessions'),
        Icons.devices_rounded,
        _orange,
        _orangeSoft,
      ),
      _SummaryData(
        'Disabled',
        _value('disabled_users'),
        Icons.person_off_outlined,
        _red,
        _redSoft,
      ),
    ];

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final card = cards[index];
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isRefreshing ? .65 : 1,
            child: Container(
              width: 190,
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: _line),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: card.softColor,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(card.icon, color: card.color, size: 21),
                  ),
                  const SizedBox(width: 11),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${card.value}',
                        style: TextStyle(
                          color: card.color,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.label,
                        style: const TextStyle(color: _muted, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryData {
  const _SummaryData(
    this.label,
    this.value,
    this.icon,
    this.color,
    this.softColor,
  );

  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Color softColor;
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller});

  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final search = SizedBox(
            height: 34,
            child: TextField(
              controller: controller.searchController,
              decoration: _inputDecoration(
                hint: 'Search user, email, role, branch or IP',
                icon: Icons.search_rounded,
                suffix: Obx(
                  () => controller.query.value.isEmpty
                      ? const SizedBox.shrink()
                      : IconButton(
                          onPressed: controller.searchController.clear,
                          icon: const Icon(Icons.close_rounded, size: 17),
                        ),
                ),
              ),
            ),
          );
          final filters = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FilterChip('all', 'All', controller),
              const SizedBox(width: 5),
              _FilterChip('online', 'Online', controller),
              const SizedBox(width: 5),
              _FilterChip('offline', 'Offline', controller),
              const SizedBox(width: 5),
              _FilterChip('disabled', 'Disabled', controller),
              const SizedBox(width: 5),
              _FilterChip('expired', 'Expired', controller),
            ],
          );
          return Row(
            children: [
              Expanded(flex: constraints.maxWidth < 700 ? 4 : 5, child: search),
              const SizedBox(width: 9),
              Expanded(
                flex: constraints.maxWidth < 700 ? 6 : 7,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: constraints.maxWidth >= 700,
                  child: filters,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(this.value, this.label, this.controller);

  final String value;
  final String label;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.filter.value == value;
      return InkWell(
        borderRadius: BorderRadius.circular(7),
        onTap: () => controller.filter.value = value,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? _primary : _surfaceSoft,
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: selected ? _primary : _line),
          ),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              color: selected ? Colors.white : _muted,
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    });
  }
}

class _UsersPanel extends StatelessWidget {
  const _UsersPanel({required this.controller});

  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: _primary),
          );
        }
        if (controller.errorMessage.value.isNotEmpty &&
            controller.users.isEmpty) {
          return _ErrorState(controller: controller);
        }
        final users = controller.visibleUsers;
        if (users.isEmpty) return const _EmptyState();

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 980) {
              return ListView.separated(
                padding: const EdgeInsets.all(9),
                itemCount: users.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) =>
                    _UserCard(user: users[index], controller: controller),
              );
            }
            return _UsersTable(users: users, controller: controller);
          },
        );
      }),
    );
  }
}

class _UsersTable extends StatelessWidget {
  const _UsersTable({required this.users, required this.controller});

  final List<AdminUserSession> users;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TableHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            itemExtent: 92,
            itemBuilder: (context, index) => _UserTableRow(
              user: users[index],
              controller: controller,
              alternate: index.isOdd,
            ),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: const Color(0xFFF2F6F9),
      child: const Row(
        children: [
          Expanded(flex: 28, child: _HeaderLabel('USER')),
          Expanded(flex: 12, child: _HeaderLabel('PRESENCE')),
          Expanded(flex: 22, child: _HeaderLabel('LOGIN & DURATION')),
          Expanded(flex: 16, child: _HeaderLabel('ACCESS')),
          Expanded(flex: 18, child: _HeaderLabel('DEVICE / IP')),
          SizedBox(
            width: 164,
            child: _HeaderLabel('CONTROLS', align: TextAlign.right),
          ),
        ],
      ),
    );
  }
}

class _HeaderLabel extends StatelessWidget {
  const _HeaderLabel(this.label, {this.align = TextAlign.left});

  final String label;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: align,
      style: const TextStyle(
        color: _muted,
        fontSize: 9.5,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _UserTableRow extends StatelessWidget {
  const _UserTableRow({
    required this.user,
    required this.controller,
    required this.alternate,
  });

  final AdminUserSession user;
  final AdminScreenController controller;
  final bool alternate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: alternate ? const Color(0xFFFBFCFD) : _surface,
        border: const Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Expanded(flex: 28, child: _UserIdentity(user: user)),
          Expanded(
            flex: 12,
            child: _Presence(user: user, controller: controller),
          ),
          Expanded(
            flex: 22,
            child: _LoginInfo(user: user, controller: controller),
          ),
          Expanded(flex: 16, child: _AccessInfo(user: user)),
          Expanded(flex: 18, child: _DeviceInfo(user: user)),
          SizedBox(
            width: 164,
            child: _UserActions(user: user, controller: controller),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.controller});

  final AdminUserSession user;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _UserIdentity(user: user)),
              const SizedBox(width: 8),
              _StatusPill.forAccess(user),
            ],
          ),
          const Divider(color: _line, height: 22),
          Wrap(
            spacing: 18,
            runSpacing: 14,
            children: [
              SizedBox(
                width: 150,
                child: _Presence(user: user, controller: controller),
              ),
              SizedBox(
                width: 220,
                child: _LoginInfo(user: user, controller: controller),
              ),
              SizedBox(width: 175, child: _AccessInfo(user: user)),
              SizedBox(width: 190, child: _DeviceInfo(user: user)),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: _UserActions(user: user, controller: controller),
          ),
        ],
      ),
    );
  }
}

class _UserIdentity extends StatelessWidget {
  const _UserIdentity({required this.user});

  final AdminUserSession user;

  @override
  Widget build(BuildContext context) {
    final initial = user.userName.trim().isNotEmpty
        ? user.userName.trim().characters.first.toUpperCase()
        : user.email.trim().isNotEmpty
        ? user.email.trim().characters.first.toUpperCase()
        : '?';
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: user.isAdmin ? _blueSoft : _primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                initial,
                style: TextStyle(
                  color: user.isAdmin ? _blue : _primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (user.isOnline)
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      user.userName.isEmpty ? 'Unnamed User' : user.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (user.isCurrentUser) ...[
                    const SizedBox(width: 6),
                    const _TinyTag(
                      label: 'YOU',
                      color: _primary,
                      background: _primarySoft,
                    ),
                  ],
                  if (user.isAdmin) ...[
                    const SizedBox(width: 5),
                    const Icon(Icons.shield_rounded, size: 14, color: _blue),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                user.email.isEmpty ? 'No email available' : user.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 9.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Presence extends StatelessWidget {
  const _Presence({required this.user, required this.controller});

  final AdminUserSession user;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatusPill.forPresence(user),
        const SizedBox(height: 6),
        Text(
          user.isOnline
              ? controller.onlineDuration(user)
              : 'Last seen ${_relativeDate(user.lastSeenAt)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted, fontSize: 9.5),
        ),
      ],
    );
  }
}

class _LoginInfo extends StatelessWidget {
  const _LoginInfo({required this.user, required this.controller});

  final AdminUserSession user;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconLine(Icons.login_rounded, _formatDate(user.loginAt)),
        const SizedBox(height: 7),
        _IconLine(
          Icons.timer_outlined,
          user.isOnline
              ? controller.onlineDuration(user)
              : 'Not currently online',
          color: user.isOnline ? _green : _muted,
        ),
      ],
    );
  }
}

class _AccessInfo extends StatelessWidget {
  const _AccessInfo({required this.user});

  final AdminUserSession user;

  @override
  Widget build(BuildContext context) {
    final role = user.roles.isEmpty
        ? 'No role assigned'
        : user.roles.join(', ');
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _StatusPill.forAccess(user),
            const SizedBox(width: 6),
            _TinyTag(
              label:
                  '${user.activeSessions} SESSION${user.activeSessions == 1 ? '' : 'S'}',
              color: _blue,
              background: _blueSoft,
            ),
          ],
        ),
        const SizedBox(height: 7),
        Text(
          role,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _muted, fontSize: 9.5),
        ),
      ],
    );
  }
}

class _DeviceInfo extends StatelessWidget {
  const _DeviceInfo({required this.user});

  final AdminUserSession user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconLine(Icons.devices_rounded, user.deviceLabel),
        const SizedBox(height: 7),
        _IconLine(
          Icons.language_rounded,
          user.ipAddress.isEmpty ? 'IP unavailable' : user.ipAddress,
        ),
      ],
    );
  }
}

class _UserActions extends StatelessWidget {
  const _UserActions({required this.user, required this.controller});

  final AdminUserSession user;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    final logoutKey = 'logout:${user.id}';
    final statusKey = 'status:${user.id}';
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _SquareAction(
          tooltip: 'View all details',
          icon: Icons.visibility_outlined,
          color: _blue,
          background: _blueSoft,
          onTap: () => _showUserDetails(context, user, controller),
        ),
        const SizedBox(width: 6),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _SquareAction(
              tooltip:
                  '${user.activeSessions} active device session${user.activeSessions == 1 ? '' : 's'}',
              icon: Icons.devices_other_rounded,
              color: _primary,
              background: _primarySoft,
              onTap: () => _showSessionsDialog(context, user, controller),
            ),
            if (user.activeSessions > 0)
              Positioned(
                right: -4,
                top: -5,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _primary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    '${user.activeSessions}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 7.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 6),
        Obx(
          () => _SquareAction(
            tooltip: user.enabled ? 'Disable account' : 'Enable account',
            icon: user.enabled
                ? Icons.person_off_outlined
                : Icons.person_add_alt_1_rounded,
            color: user.enabled ? _orange : _green,
            background: user.enabled ? _orangeSoft : _greenSoft,
            busy: controller.isActionBusy(statusKey),
            onTap: user.isCurrentUser
                ? null
                : () => _confirmStatus(context, user, controller),
          ),
        ),
        const SizedBox(width: 6),
        Obx(
          () => _SquareAction(
            tooltip: 'Force logout',
            icon: Icons.power_settings_new_rounded,
            color: _red,
            background: _redSoft,
            busy: controller.isActionBusy(logoutKey),
            onTap: user.isCurrentUser
                ? null
                : () => _confirmLogout(context, user, controller),
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    required this.background,
    this.dot = false,
  });

  factory _StatusPill.forPresence(AdminUserSession user) => _StatusPill(
    label: user.isOnline ? 'ONLINE' : 'OFFLINE',
    color: user.isOnline ? _green : _muted,
    background: user.isOnline ? _greenSoft : const Color(0xFFF0F3F6),
    dot: true,
  );

  factory _StatusPill.forAccess(AdminUserSession user) {
    if (!user.enabled) {
      return const _StatusPill(
        label: 'DISABLED',
        color: _red,
        background: _redSoft,
      );
    }
    if (user.expired) {
      return const _StatusPill(
        label: 'EXPIRED',
        color: _orange,
        background: _orangeSoft,
      );
    }
    return const _StatusPill(
      label: 'ACTIVE',
      color: _primary,
      background: _primarySoft,
    );
  }

  final String label;
  final Color color;
  final Color background;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 8.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyTag extends StatelessWidget {
  const _TinyTag({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 7.8,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine(this.icon, this.text, {this.color = _muted});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: color, fontSize: 9.5),
          ),
        ),
      ],
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.foreground = _primary,
    this.background = _primarySoft,
    this.busy = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color foreground;
  final Color background;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: OutlinedButton.icon(
        onPressed: busy ? null : onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: foreground,
          backgroundColor: background,
          side: BorderSide(color: foreground.withValues(alpha: .24)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        icon: busy
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: foreground,
                ),
              )
            : Icon(icon, size: 16),
        label: Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _SquareAction extends StatelessWidget {
  const _SquareAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.busy = false,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: busy ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: onTap == null ? const Color(0xFFF3F5F7) : background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: onTap == null ? _line : color.withValues(alpha: .18),
            ),
          ),
          child: busy
              ? SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Icon(
                  icon,
                  size: 17,
                  color: onTap == null ? const Color(0xFFB4BEC8) : color,
                ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.controller});

  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, color: _red, size: 38),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
            const SizedBox(height: 14),
            _HeaderButton(
              label: 'Try Again',
              icon: Icons.refresh_rounded,
              onTap: controller.fetchOverview,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_rounded, color: Color(0xFFAAB6C1), size: 40),
          SizedBox(height: 10),
          Text(
            'No users match these filters',
            style: TextStyle(color: _muted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
  String? errorText,
}) {
  return InputDecoration(
    hintText: hint,
    errorText: errorText,
    hintStyle: const TextStyle(color: Color(0xFFA0ADBA), fontSize: 10.5),
    prefixIcon: Icon(icon, size: 18, color: _muted),
    suffixIcon: suffix,
    filled: true,
    fillColor: _surfaceSoft,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _primary, width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _red, width: 1.4),
    ),
  );
}

String _two(int value) => value.toString().padLeft(2, '0');

String _formatDate(DateTime? value) {
  if (value == null) return 'No login recorded';
  return '${_two(value.day)}-${_two(value.month)}-${value.year}  ${_two(value.hour)}:${_two(value.minute)}';
}

String _relativeDate(DateTime? value) {
  if (value == null) return 'never';
  final difference = DateTime.now().difference(value);
  if (difference.isNegative || difference.inMinutes < 1) return 'just now';
  if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
  if (difference.inHours < 24) return '${difference.inHours}h ago';
  if (difference.inDays < 30) return '${difference.inDays}d ago';
  return _formatDate(value);
}

Future<void> _confirmLogout(
  BuildContext context,
  AdminUserSession user,
  AdminScreenController controller,
) async {
  final accepted = await _confirmation(
    context,
    title: 'Force logout ${user.userName}?',
    message:
        'All active sessions for this user will end immediately. They can sign in again if the account remains enabled.',
    confirmLabel: 'LOG OUT USER',
    dangerous: true,
  );
  if (accepted) await controller.forceLogout(user);
}

Future<void> _confirmLogoutAll(
  BuildContext context,
  AdminScreenController controller,
) async {
  final accepted = await _confirmation(
    context,
    title: 'Log out every other user?',
    message:
        'All company sessions except your current session will be revoked and disconnected immediately.',
    confirmLabel: 'LOG OUT ALL',
    dangerous: true,
  );
  if (accepted) await controller.forceLogoutAll();
}

Future<void> _confirmStatus(
  BuildContext context,
  AdminUserSession user,
  AdminScreenController controller,
) async {
  final enabling = !user.enabled;
  final accepted = await _confirmation(
    context,
    title: '${enabling ? 'Enable' : 'Disable'} ${user.userName}?',
    message: enabling
        ? 'The user will be allowed to sign in again.'
        : 'The account will be blocked and all of its sessions will be ended.',
    confirmLabel: enabling ? 'ENABLE USER' : 'DISABLE USER',
    dangerous: !enabling,
  );
  if (accepted) await controller.setUserEnabled(user, enabling);
}

Future<bool> _confirmation(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  required bool dangerous,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(color: _muted, height: 1.5, fontSize: 11),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('CANCEL'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: dangerous ? _red : _green,
              ),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ) ??
      false;
}

Future<void> _showSessionsDialog(
  BuildContext context,
  AdminUserSession user,
  AdminScreenController controller,
) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 680),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
              decoration: const BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.devices_other_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.userName.isEmpty
                              ? 'Active Device Sessions'
                              : '${user.userName} — Active Sessions',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        const Text(
                          'Review each signed-in device and end only the session you choose',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFFD8F1F2),
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Obx(() {
                final currentUser = controller.userById(user.id) ?? user;
                final sessions = currentUser.sessions;
                if (sessions.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(34),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.devices_other_outlined,
                            color: Color(0xFFAAB6C1),
                            size: 42,
                          ),
                          SizedBox(height: 11),
                          Text(
                            'No active device sessions',
                            style: TextStyle(color: _muted, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: sessions.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return _SessionCard(
                      user: currentUser,
                      session: session,
                      controller: controller,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({
    required this.user,
    required this.session,
    required this.controller,
  });

  final AdminUserSession user;
  final AdminActiveSession session;
  final AdminScreenController controller;

  @override
  Widget build(BuildContext context) {
    final actionKey = 'session:${user.id}:${session.id}';
    final mobileDevice =
        session.deviceLabel.contains('iOS') ||
        session.deviceLabel.contains('Android');
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: session.isCurrentSession ? _primarySoft : _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: session.isCurrentSession ? const Color(0xFFB8DFE2) : _line,
          width: session.isCurrentSession ? 1.3 : 1,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 590;
          final identity = Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: session.isOnline ? _greenSoft : _blueSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  mobileDevice
                      ? Icons.smartphone_rounded
                      : Icons.computer_rounded,
                  color: session.isOnline ? _green : _blue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            session.deviceLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _text,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (session.isCurrentSession) ...[
                          const SizedBox(width: 7),
                          const _TinyTag(
                            label: 'THIS DEVICE',
                            color: _primary,
                            background: Colors.white,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        _StatusPill(
                          label: session.isOnline ? 'ONLINE' : 'IDLE',
                          color: session.isOnline ? _green : _muted,
                          background: session.isOnline
                              ? _greenSoft
                              : const Color(0xFFF0F3F6),
                          dot: true,
                        ),
                        const SizedBox(width: 7),
                        Flexible(
                          child: Text(
                            session.ipAddress.isEmpty
                                ? 'IP unavailable'
                                : session.ipAddress,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 9.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
          final times = Wrap(
            spacing: 16,
            runSpacing: 7,
            children: [
              _SessionTime(
                label: 'LOGGED IN',
                value: _formatDate(session.loginAt),
                icon: Icons.login_rounded,
              ),
              _SessionTime(
                label: 'LAST SEEN',
                value: _formatDate(session.lastSeenAt),
                icon: Icons.history_rounded,
              ),
              _SessionTime(
                label: 'EXPIRES',
                value: _formatDate(session.expiresAt),
                icon: Icons.event_outlined,
              ),
            ],
          );
          final logoutButton = Obx(
            () => SizedBox(
              height: 34,
              child: OutlinedButton.icon(
                onPressed:
                    session.isCurrentSession ||
                        controller.isActionBusy(actionKey)
                    ? null
                    : () => _confirmSessionLogout(
                        context,
                        user,
                        session,
                        controller,
                      ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _red,
                  backgroundColor: _redSoft,
                  side: const BorderSide(color: Color(0xFFF3C9C9)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: controller.isActionBusy(actionKey)
                    ? const SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _red,
                        ),
                      )
                    : Icon(
                        session.isCurrentSession
                            ? Icons.check_circle_outline_rounded
                            : Icons.logout_rounded,
                        size: 15,
                      ),
                label: Text(
                  session.isCurrentSession ? 'CURRENT' : 'LOG OUT DEVICE',
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                identity,
                const SizedBox(height: 12),
                times,
                const SizedBox(height: 11),
                Align(alignment: Alignment.centerRight, child: logoutButton),
              ],
            );
          }
          return Row(
            children: [
              SizedBox(width: 230, child: identity),
              const SizedBox(width: 16),
              Expanded(child: times),
              const SizedBox(width: 12),
              logoutButton,
            ],
          );
        },
      ),
    );
  }
}

class _SessionTime extends StatelessWidget {
  const _SessionTime({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135,
      child: Row(
        children: [
          Icon(icon, color: _muted, size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _text, fontSize: 9),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _confirmSessionLogout(
  BuildContext context,
  AdminUserSession user,
  AdminActiveSession session,
  AdminScreenController controller,
) async {
  final accepted = await _confirmation(
    context,
    title: 'Log out ${session.deviceLabel}?',
    message:
        'Only this device session will be revoked. Other sessions for ${user.userName} will stay active.',
    confirmLabel: 'LOG OUT DEVICE',
    dangerous: true,
  );
  if (accepted) await controller.forceLogoutSession(user, session);
}

Future<void> _showUserDetails(
  BuildContext context,
  AdminUserSession user,
  AdminScreenController controller,
) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760, maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: _primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.badge_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      user.userName.isEmpty ? 'User Details' : user.userName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _UserIdentity(user: user)),
                        const SizedBox(width: 12),
                        _StatusPill.forPresence(user),
                        const SizedBox(width: 6),
                        _StatusPill.forAccess(user),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _DetailTile(
                          'EMAIL',
                          user.email.isEmpty ? '—' : user.email,
                          Icons.email_outlined,
                        ),
                        _DetailTile(
                          'ONLINE FOR',
                          controller.onlineDuration(user),
                          Icons.timer_outlined,
                        ),
                        _DetailTile(
                          'LAST LOGIN',
                          _formatDate(user.loginAt),
                          Icons.login_rounded,
                        ),
                        _DetailTile(
                          'LAST SEEN',
                          _formatDate(user.lastSeenAt),
                          Icons.history_rounded,
                        ),
                        _DetailTile(
                          'LAST LOGOUT',
                          _formatDate(user.lastLogoutAt),
                          Icons.logout_rounded,
                        ),
                        _DetailTile(
                          'LAST FORCED LOGOUT',
                          _formatDate(user.forcedLogoutAt),
                          Icons.power_settings_new_rounded,
                        ),
                        _DetailTile(
                          'ACTIVE SESSIONS',
                          '${user.activeSessions}',
                          Icons.devices_rounded,
                        ),
                        _DetailTile(
                          'LIVE CONNECTIONS',
                          '${user.connectionCount}',
                          Icons.wifi_rounded,
                        ),
                        _DetailTile(
                          'DEVICE',
                          user.deviceLabel,
                          Icons.computer_rounded,
                        ),
                        _DetailTile(
                          'IP ADDRESS',
                          user.ipAddress.isEmpty ? '—' : user.ipAddress,
                          Icons.language_rounded,
                        ),
                        _DetailTile(
                          'ACCOUNT EXPIRY',
                          _formatDate(user.expiryDate),
                          Icons.event_busy_outlined,
                        ),
                        _DetailTile(
                          'CREATED',
                          _formatDate(user.createdAt),
                          Icons.calendar_month_outlined,
                        ),
                        _DetailTile(
                          'PRIMARY BRANCH',
                          user.primaryBranch.isEmpty ? '—' : user.primaryBranch,
                          Icons.account_tree_outlined,
                        ),
                        _DetailTile(
                          'ROLES',
                          user.roles.isEmpty ? '—' : user.roles.join(', '),
                          Icons.admin_panel_settings_outlined,
                        ),
                        _DetailTile(
                          'BRANCHES',
                          user.branches.isEmpty
                              ? '—'
                              : user.branches.join(', '),
                          Icons.business_outlined,
                        ),
                        _DetailTile(
                          'USER ID',
                          user.id,
                          Icons.fingerprint_rounded,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _surfaceSoft,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _line),
                      ),
                      child: Text(
                        user.userAgent.isEmpty
                            ? 'No browser details recorded'
                            : user.userAgent,
                        style: const TextStyle(
                          color: _muted,
                          height: 1.45,
                          fontSize: 9.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DetailTile extends StatelessWidget {
  const _DetailTile(this.label, this.value, this.icon);

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224,
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: _primary, size: 17),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
