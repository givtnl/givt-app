import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:givt_app/features/family/shared/design/components/input/fun_input_label.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
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
    super.key,
  });

  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool readOnly;
  final Widget? prefixIcon;
  /// When non-empty, shown inside the field before the text (e.g. currency).
  /// The default search icon is omitted when this is set.
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

  @override
  State<FunInput> createState() => _FunInputState();
}

class _FunInputState extends State<FunInput> {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  bool _ownsTextController = false;
  bool _ownsFocusNode = false;

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
    final prefixIcon = hasPrefixText
        ? null
        : (widget.prefixIcon ??
            Icon(
              Icons.search,
              color: theme.neutral40,
            ));
    final prefix = hasPrefixText
        ? Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LabelLargeText(
              widget.prefixText!,
              color: theme.primary20,
            ),
          )
        : null;

    final field = TextField(
      controller: _textController,
      focusNode: _focusNode,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      textInputAction: widget.textInputAction,
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
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: theme.neutralVariant60,
        ),
        errorText: widget.errorText,
        prefixIcon: prefixIcon,
        prefix: prefix,
        filled: true,
        fillColor: theme.neutral100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
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
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        color: theme.primary20,
      ),
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
