import 'package:equatable/equatable.dart';
import '../../data/models/auth_models.dart';

enum AuthStatus { initial, loading, success, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthResponse? response;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.response,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    AuthResponse? response,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      response: response ?? this.response,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, response, errorMessage];
}
