import 'package:xave/core/models/account.dart';

/// An interface for the authentication repository.
abstract class IAuthRepository {
  /// Logs the user into their account.
  Future<Account> login();

  /// Logs the user out of their account.
  Future<void> logout();

  /// Real-time stream of the user's authentication state.
  Stream<Account?> get loggedAccountState;
}

/// An exception thrown when an authentication operation fails.
class AuthException implements Exception {
  /// Initializes a new [AuthException].
  const AuthException({this.message});

  /// Error message.
  final String? message;
}
