import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';

// Events
abstract class UserEvent {}

class FetchUser extends UserEvent {
  final String userId;
  FetchUser(this.userId);
}

class UpdateStreak extends UserEvent {
  final String userId;
  final bool allQuestsCompleted;
  final int pointsEarned;

  UpdateStreak({
    required this.userId,
    required this.allQuestsCompleted,
    required this.pointsEarned,
  });
}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final bool allQuestsCompletedToday;

  UserLoaded(this.user, this.allQuestsCompletedToday);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<UpdateStreak>(_onUpdateStreak);
  }

  Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await _userRepository.getUserById(event.userId);
      final allQuestsCompletedToday = TimeParser.isToday(user.lastCompletedDate);
      emit(UserLoaded(user, allQuestsCompletedToday));
    } catch (e) {
      emit(UserError('Failed to fetch user: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateStreak(UpdateStreak event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final currentUser = currentState.user;

      final today = TimeParser.getMalaysiaTime();
      final lastCompleted = currentUser.lastCompletedDate;

      int newStreak = currentUser.currentStreak;
      if (event.allQuestsCompleted) {
        if (!TimeParser.isToday(lastCompleted)) {
          if (TimeParser.isConsecutiveDay(lastCompleted)) {
            // Increment streak if it's a consecutive day
            newStreak++;
          } else {
            // Reset streak if it's not consecutive
            newStreak = 1;
          }
        }
      }

      final updatedUser = currentUser.copyWith(
        currentStreak: newStreak,
        lastCompletedDate: event.allQuestsCompleted ? today : currentUser.lastCompletedDate,
        totalPoints: currentUser.totalPoints + event.pointsEarned,
        completedSessions: currentUser.completedSessions + (event.allQuestsCompleted ? 1 : 0),
      );

      await _userRepository.updateUser(updatedUser);
      emit(UserLoaded(updatedUser, event.allQuestsCompleted));
    }
  }
}