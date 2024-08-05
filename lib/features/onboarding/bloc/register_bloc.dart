import 'dart:io';
import 'package:calories_tracking/features/onboarding/model/User.dart';
import 'package:calories_tracking/service/auth_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Event ///
sealed class RegisterEvent {}

final class FileSelected extends RegisterEvent {
  final PlatformFile file;

  FileSelected(this.file);
}

final class FileRemove extends RegisterEvent {
}

final class FileSubmit extends RegisterEvent {}

final class EmailChanged extends RegisterEvent {
  EmailChanged(this.email);

  final String email;
}

final class RoleChanged extends RegisterEvent {
  final UserType role;

  RoleChanged(this.role);
}

final class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged(this.password);
}

final class LocationChanged extends RegisterEvent {
  final String location;

  LocationChanged(this.location);
}

final class userNameChanged extends RegisterEvent {
  final String userName;

  userNameChanged(this.userName);
}

final class FormSubmit extends RegisterEvent {}

/// State ///

enum FormStatus {
  initial,
  pending,
  success,
  error,
}

enum UserType { initial, user, admin, coach }


@immutable
final class RegisterState {
  final SystemUser? user;
  final String password;
  final FormStatus status;
  final FormStatus fileStatus;
  final String? errorMsg;
  final PlatformFile? selectedFile;

  const RegisterState({
    this.user,
    this.password = "",
    this.selectedFile,
    this.status = FormStatus.initial,
    this.fileStatus = FormStatus.initial,
    this.errorMsg,
  });

  RegisterState copyWith({
    SystemUser? user,
    String? password,
    PlatformFile? selectedFile,
    FormStatus? fileStatus,
    FormStatus? status,
    String? errorMsg,
  }) =>
      RegisterState(
        user: user ?? this.user,
        password: password ?? this.password,
        selectedFile: selectedFile ?? this.selectedFile,
        fileStatus: fileStatus ?? this.fileStatus,
        status: status ?? this.status,
        errorMsg: errorMsg ?? this.errorMsg,
      );
}

/// Bloc ///

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepo _authService;

  RegisterBloc(this._authService) : super(RegisterState()) {
    on<EmailChanged>(_emailChange);
    on<PasswordChanged>(_passwordChange);
    on<FormSubmit>(_formSubmit);
    on<LocationChanged>(_locationChanged);
    on<userNameChanged>(_userNameChanged);
    on<FileSelected>(_fileSelected);
    on<FileRemove>(_fileRemove);
    on<RoleChanged>(_roleChange);
  }

  void _emailChange(EmailChanged event, Emitter<RegisterState> emit) {
    // Ensure user is not null
    final updatedUser = state.user?.copyWith(email: event.email) ??
        SystemUser(email: event.email);
    emit(state.copyWith(user: updatedUser));
  }

  void _roleChange(RoleChanged event, Emitter<RegisterState> emit) {
    if (event.role == UserType.user) {
      final updatedUser = state.user?.copyWith(role: userRole.user) ??
          SystemUser(role: userRole.user);
      emit(state.copyWith(user: updatedUser));
    } else if (event.role == UserType.admin) {
      final updatedUser = state.user?.copyWith(role: userRole.admin) ??
          SystemUser(role: userRole.admin);
      emit(state.copyWith(user: updatedUser));
    } else if (event.role == UserType.coach) {
      final updatedUser = state.user?.copyWith(role: userRole.coach) ??
          SystemUser(role: userRole.coach);
      emit(state.copyWith(user: updatedUser));
    }
  }

  void _fileSelected(FileSelected event, Emitter<RegisterState> emit) {
      emit(state.copyWith(
        selectedFile: event.file,
        fileStatus: FormStatus.pending,
      ));
  }

  void _fileRemove(FileRemove event, Emitter<RegisterState> emit) {
    try {
      emit(state.copyWith(
        selectedFile: null,
        fileStatus: FormStatus.initial, // 文件成功移除后，将状态设置为成功
      ));
    } catch (error) {
      emit(state.copyWith(
        fileStatus: FormStatus.pending, // 如果发生错误，设置状态为错误
        errorMsg: 'Failed to remove file', // 提供错误信息
      ));
    }
  }

  void _userNameChanged(userNameChanged event, Emitter<RegisterState> emit) {
    final updatedUser = state.user?.copyWith(name: event.userName) ??
        SystemUser(name: event.userName);
    emit(state.copyWith(user: updatedUser));
  }

  void _locationChanged(LocationChanged event, Emitter<RegisterState> emit) {
    final updatedUser = state.user?.copyWith(location: event.location) ??
        SystemUser(location: event.location);
    emit(state.copyWith(user: updatedUser));
  }

  void _passwordChange(PasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _formSubmit(FormSubmit event, Emitter<RegisterState> emit) async {
    final user = state.user;
    final password = state.password;

    // Ensure user object and password are not empty
    if (user == null ||
        user.email == null ||
        user.email!.isEmpty ||
        password.isEmpty) return;

    if (state.selectedFile != null) {
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
            storage.ref().child('uploads/${state.selectedFile!.name}');
        UploadTask uploadTask = ref.putFile(File(state.selectedFile!.path!));

        await uploadTask.whenComplete(() => {});
        String downloadUrl = await ref.getDownloadURL();

        print('File uploaded: $downloadUrl');

        emit(state.copyWith(fileStatus: FormStatus.success));
      } catch (e) {
        emit(state.copyWith(fileStatus: FormStatus.error));
      }
    }
    // Call AuthService's signUp method to register the user
    final registeredUser = await _authService.signUp(user.email!, password);

    // If registration is successful
    if (registeredUser != null) {
      // Create a new SystemUser object with the returned UID
      final newUser = user.copyWith(uid: registeredUser.uid);

      // Call createUser method to save the user data to Firestore
      final userId = await newUser.createUser();

      // Check if the user was successfully created in Firestore
      if (userId.isNotEmpty) {
        emit(state.copyWith(status: FormStatus.success));
      } else {
        emit(state.copyWith(
            status: FormStatus.error,
            errorMsg: "Failed to create user in Firestore"));
      }
    } else {
      emit(state.copyWith(
          status: FormStatus.error, errorMsg: "Registration failed"));
    }
  }
}
