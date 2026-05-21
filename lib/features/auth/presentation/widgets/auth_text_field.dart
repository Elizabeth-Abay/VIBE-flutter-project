import 'package:flutter/material.dart';

/// Reusable text field for all auth screens.
/// Now accepts a [controller] so screens can read the typed value.
class AuthTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final String? errorText;
  final String? successText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.errorText,
    this.successText,
    this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscure,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hintText,
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
            // Toggle password visibility
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (widget.successText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              widget.successText!,
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ),
      ],
    );
  }
}

