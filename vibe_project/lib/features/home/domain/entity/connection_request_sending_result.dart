class ConnectResult {
  final int statusCode;
  final String message; // The text from the backend (e.g., "Request Sent")

  ConnectResult({required this.statusCode, required this.message});

  // Simple getter to check if the request worked
  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  // Optional: Specific check for a "Sent" status if your backend uses 201
  bool get isPending => statusCode == 201;
}
