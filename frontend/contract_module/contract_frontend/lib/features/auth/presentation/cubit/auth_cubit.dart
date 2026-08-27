import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../data/model/login_request_model.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends HydratedCubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    
    final request = LoginRequestModel(email: email, password: password);
    final result = await _authRepository.login(request);
    
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  void logout() {
    emit(const AuthInitial());
    clear();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['user'] != null) {
        final user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
        return AuthSuccess(user);
      }
      return const AuthInitial();
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthSuccess) {
      return {'user': state.user.toJson()};
    }
    return null;
  }
}
