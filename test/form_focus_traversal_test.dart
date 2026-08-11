import 'package:datahubai/Widgets/form_focus_traversal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('form focus order supports Tab and Shift+Tab', (tester) async {
    final first = FocusNode(debugLabel: 'first');
    final second = FocusNode(debugLabel: 'second');
    final third = FocusNode(debugLabel: 'third');
    addTearDown(() {
      first.dispose();
      second.dispose();
      third.dispose();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextField(focusNode: third).withFormFocusOrder(3),
              TextField(focusNode: first).withFormFocusOrder(1),
              TextField(focusNode: second).withFormFocusOrder(2),
            ],
          ).withFormFocusTraversal(),
        ),
      ),
    );

    first.requestFocus();
    await tester.pump();
    expect(first.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(second.hasFocus, isTrue);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(first.hasFocus, isTrue);
  });
}
