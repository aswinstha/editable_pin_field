// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:editable_pin_field/backspace_detector_formatter.dart';
import 'package:editable_pin_field/pin_code_text_editing_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:flutter/services.dart'
    show TextInputType, TextInputAction, TextCapitalization;

/// Signature for the [PinCodeTextField.buildCounter] callback.
typedef InputCounterWidgetBuilder = Widget Function(
  /// The build context for the PinCodeTextField
  BuildContext context, {
  /// The length of the string currently in the input.
  required int currentLength,

  /// The maximum string length that can be entered into the PinCodeTextField.
  required int maxLength,

  /// Whether or not the PinCodeTextField is currently focused.
  required bool isFocused,
});

/// A material design text field optimized for PIN code entry.
///
/// This is a specialized wrapper around Flutter's [TextField] that adds
/// support for detecting backspace presses on empty fields. This is useful
/// for implementing PIN code or OTP input UIs where each digit is in a
/// separate field, and pressing backspace on an empty field should move
/// focus to the previous field.
///
/// The text field maintains a leading space character internally to enable
/// backspace detection, but this is transparent to the user.
///
/// Example usage:
/// ```dart
/// PinCodeTextField(
///   maxLength: 2,
///   controller: myController,
///   onBackspacePressedOnEmptyField: () {
///     // Move focus to previous field
///     FocusScope.of(context).previousFocus();
///   },
///   onChanged: (value) {
///     if (value.length == 2) {
///       // Move to next field when this one is filled
///       FocusScope.of(context).nextFocus();
///     }
///   },
/// )
/// ```
///
/// See also:
///  * [TextField], which this widget wraps
///  * [PinCodeTextEditingController], the specialized controller used internally
class PinCodeTextField extends StatefulWidget {
  /// Creates a material design text field for PIN code entry.
  ///
  /// The [onBackspacePressedOnEmptyField] callback is required and is triggered
  /// when the user presses backspace on an empty field.
  const PinCodeTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textDirection,
    this.readOnly = false,
    this.showCursor,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = true,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection,
    this.onTap,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    required this.onBackspacePressedOnEmptyField,
  }) : super(key: key);

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [PinCodeTextEditingController].
  final TextEditingController? controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// The type of keyboard to use for editing the text.
  final TextInputType? keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Configures how the platform keyboard will select an uppercase or
  /// lowercase keyboard.
  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// The strut style used for the vertical layout.
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign textAlign;

  /// How the text should be aligned vertically.
  final TextAlignVertical? textAlignVertical;

  /// The directionality of the text.
  final TextDirection? textDirection;

  /// Whether the text field is read-only.
  final bool readOnly;

  /// Whether to show the cursor.
  final bool? showCursor;

  /// Whether this text field should focus itself if nothing else is already focused.
  final bool autofocus;

  /// Whether to hide the text being edited.
  final bool obscureText;

  /// Whether to enable autocorrection.
  final bool autocorrect;

  /// The maximum number of lines to show at one time.
  final int? maxLines;

  /// The minimum number of lines to occupy when the content spans fewer lines.
  final int? minLines;

  /// Whether this widget's height will be sized to fill its parent.
  final bool expands;

  /// The maximum number of characters to allow in the text field.
  final int? maxLength;

  /// Whether to enforce the maximum length with a [LengthLimitingTextInputFormatter].
  final bool maxLengthEnforced;

  /// Called when the user changes the text in the field.
  final ValueChanged<String>? onChanged;

  /// Called when the user indicates they are done editing.
  final VoidCallback? onEditingComplete;

  /// Called when the user indicates they are done editing the text in the field.
  final ValueChanged<String>? onSubmitted;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether the text field is enabled.
  final bool? enabled;

  /// How thick the cursor will be.
  final double cursorWidth;

  /// How rounded the corners of the cursor should be.
  final Radius? cursorRadius;

  /// The color of the cursor.
  final Color? cursorColor;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// Configures padding to edges surrounding a Scrollable when the Textfield scrolls into view.
  final EdgeInsets scrollPadding;

  /// Determines the way that drag start behavior is handled.
  final DragStartBehavior dragStartBehavior;

  /// Whether to enable user interface affordances for changing the text selection.
  final bool? enableInteractiveSelection;

  /// Called when the user taps on this text field.
  final GestureTapCallback? onTap;

  /// Callback that generates a custom [InputDecorator.counter] widget.
  final InputCounterWidgetBuilder? buildCounter;

  /// The [ScrollController] to use when vertically scrolling the input.
  final ScrollController? scrollController;

  /// The [ScrollPhysics] to use when vertically scrolling the input.
  final ScrollPhysics? scrollPhysics;

  /// Callback triggered when the user presses backspace on an empty field.
  ///
  /// This is useful for implementing navigation between PIN code fields,
  /// where pressing backspace on an empty field should move focus to the
  /// previous field.
  final VoidCallback onBackspacePressedOnEmptyField;

  /// The value used by [maxLength] to indicate that no maximum length should be enforced.
  static const int noMaxLength = -1;

  @override
  State<PinCodeTextField> createState() => _PinCodeTextFieldState();
}

class _PinCodeTextFieldState extends State<PinCodeTextField> {
  TextEditingController? _controller;

  TextEditingController get _effectiveController =>
      widget.controller ?? _controller!;

  @override
  void initState() {
    super.initState();
    // Create controller only if not provided
    if (widget.controller == null) {
      _controller = PinCodeTextEditingController();
    }
  }

  @override
  void didUpdateWidget(PinCodeTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If controller was switched from null to non-null, dispose our internal controller
    if (widget.controller != null && oldWidget.controller == null) {
      _controller?.dispose();
      _controller = null;
    }
    // If controller was switched from non-null to null, create a new internal controller
    else if (widget.controller == null && oldWidget.controller != null) {
      _controller = PinCodeTextEditingController();
    }
  }

  @override
  void dispose() {
    // Only dispose if we created it
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Combine user-provided formatters with our backspace detector
    final formatters = <TextInputFormatter>[
      BackspaceDetectorFormatter(
        onBackspaceOnEmpty: widget.onBackspacePressedOnEmptyField,
      ),
      if (widget.inputFormatters != null) ...widget.inputFormatters!,
    ];

    return TextField(
      controller: _effectiveController,
      focusNode: widget.focusNode,
      decoration: widget.decoration,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      style: widget.style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      showCursor: widget.showCursor,
      autofocus: widget.autofocus,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      maxLengthEnforced: widget.maxLengthEnforced,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      onSubmitted: widget.onSubmitted,
      inputFormatters: formatters,
      enabled: widget.enabled,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      keyboardAppearance: widget.keyboardAppearance,
      scrollPadding: widget.scrollPadding,
      dragStartBehavior: widget.dragStartBehavior,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      onTap: widget.onTap,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      buildCounter: widget.buildCounter == null
          ? null
          : (
              BuildContext context, {
              required int currentLength,
              required int? maxLength,
              required bool isFocused,
            }) {
              return widget.buildCounter!(
                context,
                currentLength: currentLength,
                maxLength: maxLength ?? 0,
                isFocused: isFocused,
              );
            },
    );
  }
}
