// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';

/// A [TextInputFormatter] that manages PIN code field behavior.
///
/// This formatter maintains a leading space character in the field and detects
/// backspace presses on "empty" fields. It handles two key scenarios:
///
/// 1. **Rapid input protection**: If the user presses backspace and quickly
///    enters two digits, the space might get replaced. This formatter ensures
///    the first character remains a space.
///
/// 2. **Backspace detection**: When the user presses backspace on a field that
///    only contains a space (appears empty), this triggers a callback for
///    navigation to the previous field.
///
/// This is useful for implementing PIN/OTP input UIs where each digit is in a
/// separate field.
class BackspaceDetectorFormatter extends TextInputFormatter {
  /// Creates a PIN code formatter.
  ///
  /// The [onBackspaceOnEmpty] callback is triggered when the user presses
  /// backspace on a field that only contains a space character.
  BackspaceDetectorFormatter({
    required this.onBackspaceOnEmpty,
  });

  /// Callback triggered when backspace is pressed on an empty field.
  final VoidCallback onBackspaceOnEmpty;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handle rapid input: if text length is 2, ensure first character is a space
    // Sometimes if user pressed backspace and tries to enter 2 numbers very fast,
    // the blank space could get replaced by a number value.
    if (newValue.text.length == 2) {
      return newValue.copyWith(
        text: " ${newValue.text.substring(1, 2)}",
        selection: const TextSelection.collapsed(offset: 2),
      );
    }

    // Handle empty field: detect backspace on "empty" (space-only) field
    // oldValue.text should be " " (just a space) or " X" (space + digit)
    // newValue.text would be "" (empty) if they tried to delete the space
    if (newValue.text.isEmpty) {
      // User pressed backspace when only the space character remained
      onBackspaceOnEmpty();

      // Restore the space character
      return const TextEditingValue(
        text: " ",
        selection: TextSelection.collapsed(offset: 1),
      );
    }

    return newValue;
  }
}
