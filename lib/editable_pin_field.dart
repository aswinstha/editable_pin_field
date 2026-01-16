// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A Flutter library for PIN code and OTP input fields.
///
/// This library provides a specialized TextField implementation optimized for
/// PIN code entry, with support for:
/// - Individual character input fields
/// - Automatic focus navigation between fields
/// - Backspace detection for moving to previous fields
/// - Rapid input edge case handling
///
/// The implementation uses composition instead of duplication, wrapping
/// Flutter's standard TextField with custom formatters and controllers.
///
/// ## Example Usage
///
/// ```dart
/// import 'package:editable_pin_field/editable_pin_field.dart';
///
/// PinCodeTextField(
///   maxLength: 2,
///   controller: TextEditingController(text: " "),
///   onBackspacePressedOnEmptyField: () {
///     FocusScope.of(context).previousFocus();
///   },
///   onChanged: (value) {
///     if (value.length == 2) {
///       FocusScope.of(context).nextFocus();
///     }
///   },
/// )
/// ```
library editable_pin_field;

export 'pin_code_text_field.dart';
export 'pin_code_text_editing_controller.dart';
export 'backspace_detector_formatter.dart';
