/// The only AI type features may depend on. See ADR-0005.
abstract interface class AiClient {
  /// Throws [AiUnavailable], [AiQuotaExceeded] or [AiFailure].
  Future<AiReply> complete(AiPrompt prompt);
}

class AiPrompt {
  const AiPrompt({
    required this.instruction,
    required this.input,
    this.maxOutputTokens = 1024,
  });

  /// What the model must do and how to answer (the system prompt).
  final String instruction;

  /// The data to work on.
  final String input;

  final int maxOutputTokens;
}

class AiReply {
  const AiReply(this.text);

  final String text;
}

sealed class AiException implements Exception {
  const AiException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// AI is switched off, not configured, or not supported on this device.
final class AiUnavailable extends AiException {
  const AiUnavailable(super.message);
}

/// The free quota or the rate limit was hit. Retry later.
final class AiQuotaExceeded extends AiException {
  const AiQuotaExceeded({this.retryAfter}) : super('AI quota exceeded.');

  final Duration? retryAfter;
}

final class AiFailure extends AiException {
  const AiFailure(super.message);
}
