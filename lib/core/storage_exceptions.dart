/* Copyright (c) 2026-Present Osama Khalifa. All rights reserved. */

/// Raised by repository implementations; the domain never sees SQL errors.
sealed class StorageException implements Exception {
  const StorageException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NotFound extends StorageException {
  const NotFound(super.message);
}

final class Conflict extends StorageException {
  const Conflict(super.message);
}

final class StorageUnavailable extends StorageException {
  const StorageUnavailable(super.message);
}
