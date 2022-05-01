part of 'auth_cubit.dart';

/// Base type of the state that should be emitted by [AuthCubit].
abstract class AuthState extends Equatable {
  /// Initializes a new [AuthState].
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class AuthInitial extends AuthState {}

/// State emitted when an authentication operation is running.
class AuthLoading extends AuthState {}

/// State emitted when the user is logged in.
class AuthLoggedIn extends AuthState {
  /// Initializes a new [AuthLoggedIn].
  const AuthLoggedIn({required this.account});

  /// The logged account.
  final Account account;

  @override
  List<Object> get props => [account];
}

/// State emitted when the user is logged out.
class AuthLoggedOut extends AuthState {}

/// State emitted when an error occurs while running an authentication operation
class AuthFailure extends AuthState {
  /// Initiailzes a new [AuthFailure].
  const AuthFailure({this.message});

  /// Error message.
  final String? message;

  @override
  List<Object?> get props => [message];
}
