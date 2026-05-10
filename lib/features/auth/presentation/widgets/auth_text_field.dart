import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final bool isPassword;
  final String? errorText;
  final String? successText;
  final String? hintText;

  const AuthTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.errorText,
    this.successText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: isPassword
                ? const Icon(
                    Icons.visibility_outlined,
                    size: 18,
                    color: Colors.grey,
                  )
                : null,
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (successText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              successText!,
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
