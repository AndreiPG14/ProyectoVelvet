// 1 StateNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import 'package:velvet/features/auth/presentation/providers/auth_provider.dart';
import 'package:velvet/features/shared/infrastructure/inputs/password.dart';
import 'package:velvet/features/shared/infrastructure/inputs/user.dart';

// 3 StateNotifierProvider - consume afuera
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final loginUserCallBack = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallBack: loginUserCallBack);
});

final obscuretextProvider = StateProvider<bool>((ref) => true);


class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallBack;
  LoginFormNotifier({required this.loginUserCallBack})
      : super(LoginFormState());

  void userChanged(String value) {
    final newUser = Username.dirty(value);
    state = state.copyWith(
        username: newUser, isValid: Formz.validate([newUser, state.password]));
  }

  void passwordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.username]),
    );
  }

  onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) return;
    await loginUserCallBack(state.username.value, state.password.value);
  }

  _touchEveryField() {
    final user = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      username: user,
      password: password,
      isValid: Formz.validate([user, password]),
    );
  }
}

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Username username;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Username? username,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return 'LoginFormState(isPosting: $isPosting, isFormPosted: $isFormPosted, isValid: $isValid, username: $username, password: $password)';
  }
}
