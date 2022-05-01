import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xave/core/models/account.dart';
import 'package:xave/features/auth/logic/repository/auth_repository.dart';

part 'auth_state.dart';

/// A [Cubit] that manages the state of the authentication.
class AuthCubit extends Cubit<AuthState> {
  /// Initializes a new [AuthCubit].
  AuthCubit({required IAuthRepository repository})
      : _repository = repository,
        super(AuthInitial()) {
    _repository.loggedAccountState.listen((event) {
      if (event != null) {
        emit(AuthLoggedIn(account: event));
      } else {
        emit(AuthInitial());
      }
    });
  }

  final IAuthRepository _repository;

  /// Handles the logic of logging the user in.
  Future<void> login() async {
    emit(AuthLoading());
    try {
      final account = await _repository.login();
      emit(AuthLoggedIn(account: account));
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    }
  }

  /// Handles the logic of logging account.
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _repository.logout();
      emit(AuthLoggedOut());
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    }
  }
}
