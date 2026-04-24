import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/auth_models.dart';
import '../../data/services/auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthState()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  // لما اليوزر يدوس على زرار الدخول
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _authService.login(
      LoginRequest(email: event.email, password: event.password),
    );

    if (result.isAuthenticated) {
      // لو دخل صح، بنبعت حالة النجاح
      emit(state.copyWith(status: AuthStatus.success, response: result));
    } else {
      // لو في حاجة غلط، بنبعت حالة الفشل مع رسالة السبب
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: result.message));
    }
  }

  // لما اليوزر يدوس على زرار إنشاء حساب
  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _authService.register(
      RegisterRequest(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );

    if (result.isAuthenticated) {
      emit(state.copyWith(status: AuthStatus.success, response: result));
    } else {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: result.message));
    }
  }

  // لما اليوزر يعوز يخرج من الأكونت
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.logout();
    emit(const AuthState());
  }
}
