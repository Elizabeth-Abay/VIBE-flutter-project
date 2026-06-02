/// Result of POST /auth/verify-email.
sealed class VerifyEmailResult {
  const VerifyEmailResult();
}

class VerifyEmailSuccess extends VerifyEmailResult {
  final String sessionId;
  final String email;
  const VerifyEmailSuccess({required this.sessionId, required this.email});
}

class VerifyEmailUserExists extends VerifyEmailResult {
  const VerifyEmailUserExists();
}

class VerifyEmailServerError extends VerifyEmailResult {
  const VerifyEmailServerError();
}

class VerifyEmailNetworkError extends VerifyEmailResult {
  final String message;
  const VerifyEmailNetworkError(this.message);
}
