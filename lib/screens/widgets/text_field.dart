import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/common/constants.dart';

class MyTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool enabled;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final bool alignLabelWithHint;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final String? caption;
  final EdgeInsetsGeometry? contentPadding;
  final bool noneBorder;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? fontSize;
  final TextStyle? hintStyle;
  final double? pleft;
  final double? ptop;
  final double? pright;
  final double? pbottom;
  final Widget? suffix;
  final String? errorText;
  const MyTextField({
    Key? key,
    this.errorText,
    this.labelText,
    this.noneBorder = false,
    this.contentPadding,
    this.suffixIcon,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.alignLabelWithHint = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.validator,
    this.caption,
    this.letterSpacing,
    this.wordSpacing,
    this.fontSize,
    this.hintStyle,
    this.pleft,
    this.ptop,
    this.pright,
    this.pbottom,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (caption != null)
          Text(
            caption!,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface),
          ).marginOnly(bottom: 4, left: 4),
        TextFormField(
          //   forceErrorText: errorText,
          controller: controller,
          style: TextStyle(
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            fontSize: fontSize ?? 14,
          ),

          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          textAlign: textAlign,
          textAlignVertical: textAlignVertical,
          enabled: enabled,
          decoration: InputDecoration(
            errorText: errorText,
            border: noneBorder ? InputBorder.none : null,
            disabledBorder: noneBorder ? InputBorder.none : null,
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(strokeAlign: BorderSide.strokeAlignCenter),
            // ),
            enabledBorder: noneBorder ? InputBorder.none : null,
            contentPadding: contentPadding,
            labelText: labelText,
            hintText: hintText,
            hintStyle: hintStyle,
            suffixIcon: suffixIcon,

            suffix: suffix,
            prefixIcon: prefixIcon,
            alignLabelWithHint: alignLabelWithHint,
          ),
          validator: validator,
        ),
      ],
    ).marginOnly(
        left: pleft ?? 0,
        right: pright ?? 0,
        top: ptop != null
            ? ptop!
            : caption != null
                ? 0
                : Constants.primaryPadding / 2,
        bottom: pbottom != null
            ? pbottom!
            : maxLength != null
                ? 0
                : Constants.primaryPadding);
  }
}
