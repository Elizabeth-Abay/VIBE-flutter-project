class ConnectResult {
  final bool isSuccess;
  final String message; // The text from the backend (e.g., "Request Sent")
  final String? errorCode;

  ConnectResult({
    required this.isSuccess,
    required this.message,
    this.errorCode,
  });
}