import 'package:flutter/material.dart';

/// Keeps ordered form fields ahead of incidental controls such as dialog
/// actions, tab headers, and add buttons during keyboard traversal.
Widget formFocusTraversal({required Widget child}) {
  return FocusTraversalGroup(policy: OrderedTraversalPolicy(), child: child);
}

extension OrderedFormFocus on Widget {
  /// Starts a local ordered traversal scope for this form.
  Widget withFormFocusTraversal() {
    return formFocusTraversal(child: this);
  }

  /// Assigns this field a stable position inside [formFocusTraversal].
  Widget withFormFocusOrder(num order) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(order.toDouble()),
      child: this,
    );
  }
}
