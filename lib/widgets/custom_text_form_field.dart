import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final String errorMessage;
  final String? title;
  final TextInputType? keyboardType;
  bool? obscureText;
  final TextCapitalization? textCapitalization;
  final String? prefixText;
  final TextEditingController? passwordController;
  final TextEditingController? controller;
  final bool isItPassword;
  final double? height;
  final double? textFieldVerticalPadding;
  final double? verticalPadding;
  final IconData? prefixIcon;
  final Function? onTap;
  final bool? filled;
  final bool? readOnly;
  final int? maxLines;
  final String? initialValue;
  CustomTextFormField({
    super.key,
    required this.onSaved,
    required this.regEx,
    required this.hintText,
    required this.errorMessage,
    this.obscureText = false,
    this.title,
    this.keyboardType,
    this.textCapitalization,
    this.prefixText,
    this.passwordController,
    this.controller,
    this.isItPassword = false,
    this.height,
    this.textFieldVerticalPadding,
    this.verticalPadding,
    this.prefixIcon,
    this.onTap,
    this.filled,
    this.readOnly,
    this.maxLines,
    this.initialValue,
  });

  @override
  State<CustomTextFormField> createState() {
    return _CustomTextFormFieldState();
  }
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  Color _borderColor = Colors.grey;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: widget.verticalPadding ?? 8.0),
      child: Container(
        height: widget.height ?? 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _borderColor,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: widget.textFieldVerticalPadding ?? 4.0),
          child: SizedBox(
            width: double.infinity,
            child: TextFormField(
              onTap: widget.onTap != null
                  ? () {
                      widget.onTap!();
                    }
                  : null,
              readOnly: widget.readOnly ?? false,
              initialValue: widget.initialValue,
              decoration: InputDecoration(
                prefixText: widget.prefixText,
                labelText: widget.title,
                //hintText: widget.hintText,
                fillColor: Colors.white,
                filled: true,

                border: InputBorder.none,
                prefixIcon:
                    widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
                suffixIcon: widget.isItPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            widget.obscureText = !widget.obscureText!;
                          });
                        },
                        icon: widget.obscureText == true
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility),
                      )
                    : null,
                errorStyle: const TextStyle(height: 0.6),
              ),
              style: const TextStyle(
                fontSize: 16,
              ),
              textCapitalization:
                  widget.textCapitalization ?? TextCapitalization.none,
              keyboardType: widget.keyboardType ?? TextInputType.text,
              cursorHeight: 18,
              maxLines: widget.maxLines ?? 1,
              textAlign: TextAlign.start,
              validator: (value) {
                String? validationResult;
                if (value!.isEmpty) {
                  validationResult = widget.errorMessage;
                } else if (widget.passwordController != null &&
                    widget.controller != null) {
                  if (widget.passwordController!.text !=
                      widget.controller!.text) {
                    widget.controller!.clear();
                    validationResult = 'Passwords do not match';
                  }
                } else if (widget.regEx.isNotEmpty) {
                  final regExp = RegExp(widget.regEx);
                  if (!regExp.hasMatch(value)) {
                    validationResult = widget.title;
                  }
                }

                setState(() {
                  _hasError = validationResult != null;
                  _borderColor = _hasError ? Colors.red : Colors.grey;
                });

                return validationResult;
              },
              onSaved: (value) {
                if (value!.isEmpty) {}
                widget.onSaved(value);
              },
              obscureText: widget.obscureText ?? false,
              controller:
                  widget.initialValue == null ? widget.controller : null,
            ),
          ),
        ),
      ),
    );
  }
}
