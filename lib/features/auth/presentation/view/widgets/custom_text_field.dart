import 'package:flutter/material.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:ongo_desk/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.bloc,
    required this.lightGreyColor,
    required this.state,
    required this.textLabel,
    required this.isPassword,
    this.onChanged,
    this.hintText,
    this.onPressed,
    this.validator,
  });

  final LoginViewModel bloc;
  final Color lightGreyColor;
  final LoginState state;
  final String textLabel;
  final bool isPassword;
  final Function(String?)? onChanged;
  final String? hintText;
  final VoidCallback? onPressed;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textLabel,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          onChanged: onChanged,
          obscureText: isPassword ? state.obscurePassword : false,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              isPassword ? Icons.lock : Icons.person,
              color: Colors.grey[500],
            ),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        state.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: onPressed,
                    )
                    : null,
            filled: true,
            fillColor: lightGreyColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
