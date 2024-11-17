import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTextFormField extends ConsumerWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool enabled;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextFormField({
    super.key,
    this.label,
    this.suffixIcon,
    this.hint,
    this.errorMessage,
    this.enabled = true,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.validator,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context, ref) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black54),
        borderRadius: BorderRadius.circular(6));

    const borderRadius = Radius.circular(6);

    return Container(
      // padding: const EdgeInsets.only(bottom: 0, top: 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: borderRadius,
              bottomLeft: borderRadius,
              bottomRight: borderRadius,
              topRight: borderRadius),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.003),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]),
      child: TextFormField(
        enabled: enabled,
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
            fontSize: 16.8, color: Colors.black, fontWeight: FontWeight.w300),
        decoration: InputDecoration(
          suffixIcon: suffixIcon,

          prefixIcon: prefixIcon,
          floatingLabelStyle: const TextStyle(fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorStyle: const TextStyle(fontSize: 12),
          errorBorder:
              border.copyWith(borderSide: const BorderSide(color: Colors.red)),
          focusedErrorBorder:
              border.copyWith(borderSide: const BorderSide(color: Colors.red)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}
