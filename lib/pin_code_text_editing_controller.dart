// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// A specialized [TextEditingController] for PIN code input fields.
///
/// This controller maintains a leading space character to enable backspace
/// detection when the field appears "empty" to the user. The space character
/// is always preserved at the beginning of the text.
///
/// ## When to Use
///
/// This controller is **optional**. You can use either:
/// 1. This specialized controller: `PinCodeTextEditingController()`
/// 2. A regular controller: `TextEditingController(text: " ")`
///
/// Both work identically, as the [BackspaceDetectorFormatter] handles most
/// of the logic. This controller just provides convenience and extra safety.
///
/// ## Behavior
///
/// - Initializes with a single space character by default
/// - Prevents the leading space from being deleted
/// - Handles rapid input edge cases where the space might be replaced
///
/// ## Example
///
/// ```dart
/// // Option 1: Use this specialized controller
/// final controller1 = PinCodeTextEditingController();
///
/// // Option 2: Use regular controller with space
/// final controller2 = TextEditingController(text: " ");
///
/// // Both work the same in PinCodeTextField
/// PinCodeTextField(
///   controller: controller1, // or controller2
///   onBackspacePressedOnEmptyField: () { ... },
/// )
/// ```
class PinCodeTextEditingController extends TextEditingController {
  /// Creates a PIN code text editing controller.
  ///
  /// If [text] is provided, it will be used as the initial text. Otherwise,
  /// the controller initializes with a single space character.
  PinCodeTextEditingController({String? text}) : super(text: text ?? " ");

  @override
  set value(TextEditingValue newValue) {
    super.value = _processValue(newValue);
  }

  /// Processes the text editing value to maintain PIN code field constraints.
  ///
  /// This handles two key scenarios:
  /// 1. Rapid input: If user presses backspace and quickly enters two numbers,
  ///    the blank space could get replaced. This ensures first digit is a space.
  /// 2. Empty prevention: If the text becomes completely empty (user tried to
  ///    delete the leading space), restore the space character.
  TextEditingValue _processValue(TextEditingValue value) {
    if (value.text.length == 2) {
      // Sometimes if user pressed backspace and tries to enter 2 numbers very fast,
      // the blank space could get replaced by number value. For such case make sure
      // first digit is space.
      return value.copyWith(
        text: " ${value.text.substring(1, 2)}",
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    if (value.text.isEmpty) {
      // User tried to remove the leading space - restore it
      return value.copyWith(
        text: " ",
        selection: const TextSelection.collapsed(offset: 1),
      );
    }

    return value;
  }
}
