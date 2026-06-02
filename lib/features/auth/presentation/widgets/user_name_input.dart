import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_name_unique_notifier.dart';

class UsernameInputField extends ConsumerWidget {
  final TextEditingController controller;

  const UsernameInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the real-time debounced backend state
    final usernameState = ref.watch(usernameCheckProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Direct native TextField to utilize onChanged natively
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          onChanged: (val) {
            ref
                .read(usernameCheckProvider.notifier)
                .checkUsernameDebounced(val);
          },
          decoration: InputDecoration(
            labelText: 'User Name',
            labelStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFFF40E5), // Vibe Brand Purple/Pink accent
                width: 2,
              ),
            ),
          ),
        ),

        // 2. The Dynamic Status Indicator Sub-Row
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildFeedback(usernameState),
          ),
        ),
      ],
    );
  }

  /// Helper builder method to render the UI state based on the backend state
  Widget _buildFeedback(UsernameCheckState state) {
    if (state is UsernameChecking) {
      return Row(
        key: const ValueKey('checking'),
        children: const [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.white70,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Checking availability...',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      );
    }

    if (state is UsernameAvailable) {
      return Row(
        key: const ValueKey('available'),
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.greenAccent,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            state.message,
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    if (state is UsernameUnavailable) {
      return Row(
        key: const ValueKey('unavailable'),
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 14),
          const SizedBox(width: 4),
          Text(
            state.message,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink(key: ValueKey('initial'));
  }
}
