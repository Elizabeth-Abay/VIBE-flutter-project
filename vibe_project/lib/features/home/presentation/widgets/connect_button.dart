import 'package:flutter/material.dart';

enum ConnectButtonState { idle, sending, success, error }

class ConnectButton extends StatefulWidget {
  final String userId;
  final Future<ConnectResult> Function(String userId) onConnect;

  const ConnectButton({
    super.key,
    required this.userId,
    required this.onConnect,
  });

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> with SingleTickerProviderStateMixin {
  ConnectButtonState _state = ConnectButtonState.idle;
  String _label = 'Connect';
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color get _buttonColor {
    switch (_state) {
      case ConnectButtonState.idle:
        return const Color(0xFF7C3AED); // violet
      case ConnectButtonState.sending:
        return const Color(0xFF60A5FA); // light blue
      case ConnectButtonState.success:
        return const Color(0xFF22C55E); // green
      case ConnectButtonState.error:
        return const Color(0xFFEF4444); // red
    }
  }

  Future<void> _handleTap() async {
    if (_state != ConnectButtonState.idle) return;

    // Press animation
    await _animController.forward();
    await _animController.reverse();

    setState(() {
      _state = ConnectButtonState.sending;
      _label = 'Sending';
    });

    try {
      final result = await widget.onConnect(widget.userId);

      setState(() {
        if (result.statusCode == 200) {
          _state = ConnectButtonState.success;
          _label = result.message;
        } else {
          _state = ConnectButtonState.error;
          _label = result.message;
        }
      });
    } catch (_) {
      setState(() {
        _state = ConnectButtonState.error;
        _label = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _buttonColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: _buttonColor.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: _state == ConnectButtonState.idle ? _handleTap : null,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _state == ConnectButtonState.sending
                    ? Row(
                        key: const ValueKey('sending'),
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sending',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        _label,
                        key: ValueKey(_label),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}