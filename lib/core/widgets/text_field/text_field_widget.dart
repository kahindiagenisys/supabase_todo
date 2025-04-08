import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    this.textFieldType = TextFieldType.OTHER,
    this.textAlign = TextAlign.start,
    this.floatingLabelAlignment,
    this.textCapitalization,
    this.isOnlyRead = false,
    this.isFillColor = true,
    this.outSidePadding = 8,
    this.isExpands = false,
    this.autoFocus = false,
    this.onFieldSubmitted,
    this.contentPadding,
    this.errorTextStyle,
    this.nextFocusNode,
    this.borderRadius,
    this.controller,
    this.hoverColor,
    this.labelText,
    this.hintText,
    this.borderSide,
    this.fillColor,
    this.focusNode,
    this.isFlex = 0,
    this.isPassword,
    this.validator,
    this.textStyle,
    this.maxLength,
    this.onChange,
    this.maxLine,
    this.minLine,
    this.onTap,
    this.title,
    super.key,
    this.labelTextSize = 14,
    this.inputFormatters,
    this.enabled,
    this.obscuringCharacter = '•',
    this.suffix,
    this.hintStyle,
  });

  final TextEditingController? controller;
  final TextCapitalization? textCapitalization;
  final FloatingLabelAlignment? floatingLabelAlignment;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String? value)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onFieldSubmitted;
  final TextFieldType textFieldType;
  final BorderRadius? borderRadius;
  final Function(String)? onChange;
  final TextStyle? errorTextStyle;
  final FocusNode? nextFocusNode;
  final double outSidePadding;
  final BorderSide? borderSide;
  final FocusNode? focusNode;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final String? labelText;
  final Function()? onTap;
  final String? hintText;
  final Color? hoverColor;
  final Color? fillColor;
  final bool isFillColor;
  final bool? isPassword;
  final bool isOnlyRead;
  final bool isExpands;
  final Widget? suffix;
  final bool autoFocus;
  final int? maxLength;
  final int? labelTextSize;
  final String? title;
  final int? maxLine;
  final bool? enabled;
  final int? minLine;
  final int isFlex;
  final String obscuringCharacter;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    if (isFlex == 0) {
      return textFieldBuild(color);
    }

    return Flexible(
      flex: isFlex,
      child: textFieldBuild(color),
    );
  }

  Widget textFieldBuild(ColorScheme color) {
    return Padding(
      padding: EdgeInsets.all(outSidePadding),
      child: AppTextField(
        suffix: suffix,
        obscuringCharacter: obscuringCharacter,
        enabled: enabled ?? !isOnlyRead,
        autoFocus: autoFocus,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization ?? TextCapitalization.sentences,
        isValidationRequired: validator != null,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        textFieldType: textFieldType,
        isPassword: isPassword,
        obscureText: (isPassword != null && isPassword!),
        readOnly: isOnlyRead,
        maxLength: maxLength,
        expands: isExpands,
        minLines: minLine,
        maxLines: maxLine ?? (minLine ?? 0 + 1),
        validator: validator,
        focus: focusNode,
        nextFocus: nextFocusNode,
        onChanged: onChange,
        title: title,
        onTap: onTap,
        textStyle: !(enabled ?? !isOnlyRead)
            ? secondaryTextStyle()
            : textStyle ?? primaryTextStyle(color: color.onPrimaryContainer),
        textAlign: textAlign,
        decoration: InputDecoration(
          floatingLabelAlignment: floatingLabelAlignment,
          border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            gapPadding: labelText?.length.toDouble() ?? 0.0,
            borderSide: borderSide ?? BorderSide.none,
          ),
          contentPadding: contentPadding ?? const EdgeInsets.all(8),
          hintStyle: hintStyle ?? secondaryTextStyle(),
          hoverColor: hoverColor,
          labelText: labelText,
          labelStyle: secondaryTextStyle(size: labelTextSize),
          filled: isFillColor,
          hintText: hintText,
          alignLabelWithHint: true,
          fillColor: fillColor ?? color.outline.withValues(alpha: 0.1),
          errorStyle: errorTextStyle,
        ),
      ),
    );
  }
}
