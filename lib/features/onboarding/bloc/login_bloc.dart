import 'package:calories_tracking/features/onboarding/model/User.dart';
import 'package:calories_tracking/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Event ///
sealed class LoginEvent {}

final class EmailChanged extends LoginEvent {
  EmailChanged(this.email);

  final String email;
}

final class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged(this.password);
}

final class FormSubmit extends LoginEvent {}

/// State ///

enum FormStatus {
  initial,
  pending,
  success,
  error,
}

enum UserType { initial, user, admin, coach }

@immutable
final class LoginState {
  final SystemUser? user;
  final String password;
  final FormStatus status;
  final UserType role;
  final String? errorMsg;

  const LoginState({
    this.user,
    this.password = "",
    this.status = FormStatus.initial,
    this.role = UserType.initial,
    this.errorMsg,
  });

  LoginState copyWith({
    SystemUser? user,
    String? password,
    FormStatus? status,
    UserType? role,
    String? errorMsg,
  }) =>
      LoginState(
        user: user ?? this.user,
        password: password ?? this.password,
        status: status ?? this.status,
        role: role ?? this.role,
        errorMsg: errorMsg ?? this.errorMsg,
      );
}

/// Bloc ///

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo _authService;

  LoginBloc(this._authService) : super(LoginState()) {
    on<EmailChanged>(_emailChange);
    on<PasswordChanged>(_passwordChange);
    on<FormSubmit>(_formSubmit);
  }

  void _emailChange(EmailChanged event, Emitter<LoginState> emit) {
    // Ensure user is not null
    final updatedUser = state.user?.copyWith(email: event.email) ??
        SystemUser(email: event.email);
    emit(state.copyWith(user: updatedUser));
  }

  void _passwordChange(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _formSubmit(FormSubmit event, Emitter<LoginState> emit) async {
    final updatedUser = state.user?.copyWith(role: userRole.user) ??
        SystemUser(role: userRole.user);
    emit(state.copyWith(user: updatedUser));
    final user = state.user;
    final password = state.password;

    if (user == null ||
        user.email == null ||
        user.email!.isEmpty ||
        password.isEmpty) return;

    final loggedInUser = await _authService.signIn(user.email!, password);

    if (loggedInUser != null) {
      final currentUserID = user.copyWith(uid: loggedInUser.uid);
      final currentUser = await currentUserID.getUserByUid(loggedInUser.uid);
      emit(state.copyWith(user: currentUser));

      if (currentUser?.role == userRole.user) {
        emit(state.copyWith(
          status: FormStatus.success,role: UserType.user
        ));
      } else if (currentUser?.role == userRole.admin) {
        emit(state.copyWith(
          status: FormStatus.success,role: UserType.admin
        ));
      } else if (currentUser?.role == userRole.coach) {
        emit(state.copyWith(
          status: FormStatus.success,role: UserType.coach
        ));
        emit(state.copyWith(
          role: UserType.coach,
        ));
      } else {
        emit(state.copyWith(
            status: FormStatus.error, errorMsg: "No current user."));
      }
    } else {
      emit(state.copyWith(status: FormStatus.error, errorMsg: "Login failed"));
    }
  }
}
