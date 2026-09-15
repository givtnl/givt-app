import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/shared/design_system/components/input/fun_input_label.dart';
import 'package:givt_app/shared/design_system/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/utils/utils.dart';

class FunInput extends StatefulWidget {
  const FunInput({
    required this.hintText,
    this.onTap,
    this.onChanged,
    this.focusNode,
    this.readOnly = false,
    this.prefixIcon,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction = TextInputAction.next,
    this.analyticsEvent,
    this.heroTag,
    this.label,
    this.controller,
    this.errorText,
    this.enabled = true,
    this.obscureText = false,
    this.suffixIcon,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20),
    this.errorMaxLines,
    this.minLines,
    this.maxLines = 1,
    super.key,
  });

  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;

  /// Leading icon inside the field. Laid out in the FUN Input slot:
  /// 16px inset, 30×24 centered box, 10px gap before the text.
  final Widget? prefixIcon;

  /// When non-empty, shown inside the field before the text (e.g. currency).
  /// [prefixIcon] is not shown when this is set.
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction textInputAction;
  final AnalyticsEvent? analyticsEvent;
  final String? heroTag;
  final String? label;
  final TextEditingController? controller;
  final String? errorText;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final EdgeInsets scrollPadding;
  final int? errorMaxLines;
  final int? minLines;
  final int? maxLines;

  @override
  State<FunInput> createState() => _FunInputState();
}

class _FunInputState extends State<FunInput> {
  /// FUN Input leading-icon slot (Figma Input: px 16, 30-wide icon box, gap 10).
  static const _prefixInset = 16.0;
  static const _prefixIconSlotWidth = 30.0;
  static const _prefixIconSize = 24.0;
  static const _prefixIconGap = 10.0;
  static const _fieldPadding = 16.0;
  static const _fieldPaddingWithPrefix = 12.0;

  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _ownsTextController = false;
  bool _ownsFocusNode = false;

  Widget? _leadingIcon(Widget? icon) {
    if (icon == null) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: _prefixInset,
        right: _prefixIconGap,
      ),
      child: SizedBox(
        width: _prefixIconSlotWidth,
        height: _prefixIconSize,
        child: Center(child: icon),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _textController = widget.controller!;
    } else {
      _textController = TextEditingController();
      _ownsTextController = true;
    }
    _textController.addListener(_onControllerChanged);

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant FunInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _textController.removeListener(_onControllerChanged);
      if (_ownsTextController) {
        _textController.dispose();
      }
      if (widget.controller != null) {
        _textController = widget.controller!;
        _ownsTextController = false;
      } else {
        _textController = TextEditingController();
        _ownsTextController = true;
      }
      _textController.addListener(_onControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode != null) {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      } else {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      }
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onControllerChanged);
    if (_ownsTextController) {
      _textController.dispose();
    }
    _focusNode.removeListener(_onFocusChanged);
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  FunInputLabelState _labelState() {
    if (!widget.enabled) {
      return FunInputLabelState.disabled;
    }
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      return FunInputLabelState.error;
    }
    if (_focusNode.hasFocus) {
      return FunInputLabelState.focused;
    }
    if (_textController.text.isNotEmpty) {
      return FunInputLabelState.filled;
    }
    return FunInputLabelState.defaultState;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    final hasPrefixText =
        widget.prefixText != null && widget.prefixText!.isNotEmpty;
    final prefixIcon = hasPrefixText ? null : _leadingIcon(widget.prefixIcon);
    final hasLeadingIcon = prefixIcon != null;
    final prefix = hasPrefixText
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LabelLargeText(
              widget.prefixText!,
              color: theme.primary20,
            ),
          )
        : null;

    final hint = widget.hintText.isEmpty ? null : widget.hintText;
    final labelStyle = Theme.of(context).textTheme.labelLarge;
    // TextField asserts: !obscureText || maxLines == 1
    final effectiveMinLines = widget.obscureText ? null : widget.minLines;
    final effectiveMaxLines = widget.obscureText ? 1 : widget.maxLines;

    final field = TextField(
      controller: _textController,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      autofillHints: widget.autofillHints?.toList(),
      textCapitalization: widget.textCapitalization,
      scrollPadding: widget.scrollPadding,
      minLines: effectiveMinLines,
      maxLines: effectiveMaxLines,
      onTap: () {
        if (widget.analyticsEvent != null) {
          AnalyticsHelper.logEvent(
            eventName: widget.analyticsEvent!.name,
            eventProperties: widget.analyticsEvent!.parameters,
          );
        }
        widget.onTap?.call();
      },
      onChanged: widget.onChanged,
      autocorrect: false,
      cursorColor: theme.primary30,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: labelStyle?.copyWith(color: theme.neutralVariant60),
        errorText: widget.errorText,
        errorMaxLines: widget.errorMaxLines,
        errorStyle: labelStyle?.copyWith(color: theme.error40),
        suffixIcon: widget.suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconConstraints: hasLeadingIcon
            ? const BoxConstraints(minWidth: 0, minHeight: 0)
            : null,
        isDense: hasLeadingIcon,
        prefix: prefix,
        filled: true,
        fillColor: theme.neutral100,
        contentPadding: hasLeadingIcon
            ? const EdgeInsets.fromLTRB(
                0,
                _fieldPaddingWithPrefix,
                _fieldPadding,
                _fieldPaddingWithPrefix,
              )
            : const EdgeInsets.symmetric(
                horizontal: _fieldPadding,
                vertical: _fieldPadding,
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.neutralVariant80,
            width: theme.borderWidthThinner,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.neutralVariant80,
            width: theme.borderWidthThinner,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.secondary80,
            width: theme.borderWidthThin,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.error40,
            width: theme.borderWidthThinner,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.error40,
            width: theme.borderWidthThin,
          ),
        ),
      ),
      style: labelStyle?.copyWith(color: theme.primary20),
    );

    final content = LabeledField(
      label: widget.label,
      labelState: _labelState(),
      child: field,
    );

    if (widget.heroTag == null) {
      return content;
    }

    return Hero(
      tag: widget.heroTag!,
      child: Material(
        type: MaterialType.transparency,
        child: content,
      ),
    );
  }
}
