import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../consts.dart';
import 'add_new_legilation_or_edit.dart';

Future<dynamic> legislationDialog({
  required BoxConstraints constraints,
  required LegislationController controller,
  required Future<void> Function()? onPressed,
  required bool isEditing,
}) {
  final availableWidth = constraints.maxWidth.isFinite
      ? constraints.maxWidth
      : 1480.0;
  final availableHeight = constraints.maxHeight.isFinite
      ? constraints.maxHeight
      : 900.0;
  final dialogWidth = (availableWidth - 24).clamp(320.0, 1480.0).toDouble();
  final dialogHeight = (availableHeight - 24).clamp(360.0, 1000.0).toDouble();

  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      backgroundColor: const Color(0xfff3f6f8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    mainColor.withValues(alpha: 0.78),
                    mainColor,
                    const Color(0xffd49a3a),
                  ],
                  stops: const [0, 0.82, 1],
                ),
              ),
              height: 4,
            ),
            _DialogHeader(
              controller: controller,
              isEditing: isEditing,
              onPressed: onPressed,
            ),
            Expanded(
              child: ColoredBox(
                color: const Color(0xfff3f6f8),
                child: addNewLegistlationOrEdit(
                  controller: controller,
                  constraints: constraints,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.controller,
    required this.isEditing,
    required this.onPressed,
  });

  final LegislationController controller;
  final bool isEditing;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xffdce5e8))),
      ),
      child: LayoutBuilder(
        builder: (context, headerConstraints) {
          final compact = headerConstraints.maxWidth < 720;
          final title = isEditing ? 'Edit legislation' : 'New legislation';
          final subtitle = isEditing
              ? 'Review and update this statutory policy.'
              : 'Create a statutory policy for your workforce.';

          final identity = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.balance_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xff183138),
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xff6b7c81),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          );

          final actions = GetX<LegislationController>(
            builder: (activeController) {
              final isSaving = activeController.addingNewValue.value;
              return Row(
                mainAxisSize: compact ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (compact)
                    Expanded(child: _DiscardButton(isSaving: isSaving))
                  else
                    _DiscardButton(isSaving: isSaving),
                  const SizedBox(width: 10),
                  if (compact)
                    Expanded(
                      child: _SaveButton(
                        isEditing: isEditing,
                        isSaving: isSaving,
                        onPressed: onPressed,
                      ),
                    )
                  else
                    _SaveButton(
                      isEditing: isEditing,
                      isSaving: isSaving,
                      onPressed: onPressed,
                    ),
                ],
              );
            },
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [identity, const SizedBox(height: 14), actions],
            );
          }

          return Row(children: [identity, const Spacer(), actions]);
        },
      ),
    );
  }
}

class _DiscardButton extends StatelessWidget {
  const _DiscardButton({required this.isSaving});

  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isSaving ? null : Get.back,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xff314b52),
        minimumSize: const Size(100, 42),
        side: const BorderSide(color: Color(0xffcbd8dc)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Discard'),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isEditing,
    required this.isSaving,
    required this.onPressed,
  });

  final bool isEditing;
  final bool isSaving;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isSaving || onPressed == null
          ? null
          : () async => onPressed!(),
      style: ElevatedButton.styleFrom(
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: mainColor.withValues(alpha: 0.55),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(150, 42),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: isSaving
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.check_rounded, size: 19),
      label: Text(
        isSaving
            ? 'Saving...'
            : isEditing
            ? 'Save changes'
            : 'Create policy',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
