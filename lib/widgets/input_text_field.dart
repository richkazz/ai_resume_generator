import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/spacing/app_spacing.dart';
import 'package:myapp/themes/themes.dart';
import 'package:myapp/widgets/texts.dart';

class AppInputTextField extends StatefulWidget {
  const AppInputTextField({
    super.key,
    this.icon,
    this.hintText,
    this.controller,
    this.borderRadius = 10,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.labelText,
    this.initialValue,
    this.textAlign,
    this.minLines,
    this.validator,
    this.borderColor,
    this.readOnly = false,
    this.maxLines = 1,
    this.useExternalLabel = true,
  });
  final Widget? icon;
  final String? hintText;
  final double borderRadius;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSubmitted;
  final String? errorText;
  final String? labelText;
  final String? initialValue;
  final TextAlign? textAlign;
  final bool useExternalLabel;
  final int? minLines;
  final int? maxLines;
  final bool readOnly;
  final String? Function(String?)? validator;
  final Color? borderColor;
  @override
  State<AppInputTextField> createState() => _AppInputTextFieldState();
}

class _AppInputTextFieldState extends State<AppInputTextField> {
  bool _isObscure = false;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _isObscure = widget.obscureText;
    super.initState();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }

  // ignore: avoid_positional_boolean_parameters
  void toggleObscure(bool isObscure) {
    setState(() => _isObscure = !_isObscure);
  }

  void _onChanged(String value) {
    _formKey.currentState?.validate();
    widget.onChanged?.call(value);
  }

  void _onSaved(String? value) {
    _formKey.currentState?.validate();
    widget.onSubmitted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.useExternalLabel && widget.labelText != null) ...[
                LabelText(widget.labelText ?? ''),
              ],
              Stack(
                children: [
                  TextFormField(
                    initialValue: widget.initialValue,
                    maxLines: widget.maxLines,
                    minLines: widget.minLines,
                    validator: widget.validator,
                    key: widget.key,
                    readOnly: widget.readOnly,
                    keyboardType: widget.keyboardType,
                    obscureText: _isObscure,
                    controller: widget.controller,
                    onChanged: _onChanged,
                    onSaved: _onSaved,
                    textAlign: widget.textAlign ?? TextAlign.start,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                        ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                      labelText:
                          widget.useExternalLabel ? null : widget.labelText,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                      floatingLabelStyle:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      contentPadding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 10,
                        vertical: kIsWeb ? 20 : 11,
                      ),
                      prefixIconConstraints:
                          const BoxConstraints.tightFor(width: 60, height: 40),
                      prefixIcon: switch (widget.icon != null) {
                        true => Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: widget.icon,
                          ),
                        false => null,
                      },
                      suffixIcon: widget.obscureText
                          ? const SizedBox(
                              width: 50,
                              height: 20,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                        borderSide: BorderSide(
                          color: switch (widget.errorText != null &&
                              widget.errorText!.isNotEmpty) {
                            true => AppColors.errorColor,
                            false => AppColors.inputTextFieldEnabledBorderColor,
                          },
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                        borderSide: const BorderSide(
                          color: AppColors.errorColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                        borderSide: BorderSide(
                          color: widget.borderColor ??
                              switch (widget.errorText != null &&
                                  widget.errorText!.isNotEmpty) {
                                true => AppColors.errorColor,
                                false =>
                                  AppColors.inputTextFieldEnabledBorderColor,
                              },
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius)),
                        borderSide: BorderSide(
                          color: widget.borderColor ??
                              Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  if (widget.obscureText)
                    Positioned(
                      right: 10,
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: PasswordVisibilityChanger(
                            onPasswordVisibilityChanged: toggleObscure,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          const SizedBox(
            height: AppSpacing.xs,
          ),
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Align(
            alignment: Alignment.topLeft,
            child: BodySmallText(
              widget.errorText!,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
      ],
    );
  }
}

class PasswordVisibilityChanger extends StatefulWidget {
  const PasswordVisibilityChanger({
    required this.onPasswordVisibilityChanged,
    super.key,
  });
  final ValueChanged<bool> onPasswordVisibilityChanged;
  @override
  State<PasswordVisibilityChanger> createState() =>
      _PasswordVisibilityChangerState();
}

class _PasswordVisibilityChangerState extends State<PasswordVisibilityChanger> {
  bool _isObscure = true;
  void toggleObscure() {
    setState(() => _isObscure = !_isObscure);
    widget.onPasswordVisibilityChanged(_isObscure);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      key: const Key('password_visibility_icon'),
      onPressed: toggleObscure,
      icon: Icon(
        switch (_isObscure) {
          true => Icons.visibility_outlined,
          false => Icons.visibility_off_outlined,
        },
      ),
    );
  }
}

class AppDropDown extends StatelessWidget {
  const AppDropDown({
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.labelText = '',
    this.borderRadius = 10,
    this.value,
    this.showError = false,
    super.key,
  });
  final List<String> items;
  final String labelText;
  final String hintText;
  final String? value;
  final ValueChanged<String?> onChanged;
  final double borderRadius;
  final bool showError;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          BodyText(labelText),
          const SizedBox(
            height: AppSpacing.xs,
          ),
        ],
        DropdownButtonFormField(
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(
                color: switch (showError) {
                  true => AppColors.errorColor,
                  false => AppColors.inputTextFieldEnabledBorderColor,
                },
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: const BorderSide(
                color: AppColors.errorColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
