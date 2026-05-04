class ConnectResult {
  final int statusCode;
  final String message; // The text from the backend (e.g., "Request Sent")


  ConnectResult({
    required this.statusCode,
    required this.message
  });
}