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

class SubmitCoachRating extends UserEvent {
  final String coachId;
  final double rating;

  SubmitCoachRating({required this.coachId, required this.rating});
}

class UpdateUserStreak extends UserEvent {
  final String userId;
  final bool allQuestsCompleted;
  final int pointsEarned;
  final String completedQuestId;

  UpdateUserStreak({
    required this.userId,
    required this.allQuestsCompleted,
    required this.pointsEarned,
    required this.completedQuestId,
  });
}

class OptimisticUpdateStreak extends UserEvent {
  final String userId;
  final bool allQuestsCompleted;
  final int pointsEarned;
  final String completedQuestId;

  OptimisticUpdateStreak({
    required this.userId,
    required this.allQuestsCompleted,
    required this.pointsEarned,
    required this.completedQuestId,
  });
}

class RevertOptimisticUpdate extends UserEvent {
  final String userId;

  RevertOptimisticUpdate({required this.userId});
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

class CoachRatingSubmitted extends UserState {}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  String? _userId;
  User? _lastConfirmedUser;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<UpdateUserStreak>(_onUpdateUserStreak);
    on<OptimisticUpdateStreak>(_onOptimisticUpdateStreak);
    on<RevertOptimisticUpdate>(_onRevertOptimisticUpdate);
    on<SubmitCoachRating>(_onSubmitCoachRating);
  }

  String? get userId => _userId;

  Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    _userId = event.userId;
    emit(UserLoading());
    try {
      User user = await _userRepository.getUserById(event.userId);
      user = _recalculateStreak(user);
      _lastConfirmedUser = user;
      final allQuestsCompletedToday =
          TimeParser.isToday(user.lastCompletedDate);
      emit(UserLoaded(user, allQuestsCompletedToday));
      print(
          'User fetched successfully: ${user.id}, current streak: ${user.currentStreak}');
    } catch (e) {
      print('Error fetching user: $e');
      emit(UserError('Failed to fetch user: ${e.toString()}'));
    }
  }

  User _recalculateStreak(User user) {
    TimeParser.getMalaysiaTime();
    final lastCompleted = user.lastCompletedDate;
    final lastQuestUpdate = user.lastQuestUpdate;

    int newStreak = user.currentStreak;
    List<String> newCompletedQuestIds = List.from(user.completedQuestIds);

    bool shouldClearQuests = false;

    if (!TimeParser.isToday(lastCompleted) &&
        !TimeParser.isToday(lastQuestUpdate)) {
      if (TimeParser.isConsecutiveDay(lastCompleted) &&
          TimeParser.isConsecutiveDay(lastQuestUpdate)) {
        // If both lastCompleted and lastQuestUpdate were yesterday, just reset completedQuestIds
        shouldClearQuests = true;
      } else {
        // If either lastCompleted or lastQuestUpdate was earlier than yesterday, reset streak and completedQuestIds
        newStreak = 0;
        shouldClearQuests = true;
      }
    }

    if (shouldClearQuests) {
      newCompletedQuestIds = [];
    }

    if (newStreak != user.currentStreak ||
        newCompletedQuestIds != user.completedQuestIds) {
      user = user.copyWith(
        currentStreak: newStreak,
        completedQuestIds: newCompletedQuestIds,
      );
      _userRepository.updateUser(user).then((_) {
        print('User streak recalculated and updated to: $newStreak');
        print('CompletedQuestIds reset: ${newCompletedQuestIds.isEmpty}');
      }).catchError((e) {
        print('Error updating user streak and completedQuestIds: $e');
      });
    }

    return user;
  }

  Future<void> _onUpdateUserStreak(
      UpdateUserStreak event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final updatedUser = _updateUserData(currentState.user, event);

      try {
        await _userRepository.updateUser(updatedUser);
        _lastConfirmedUser = updatedUser;
        emit(UserLoaded(updatedUser, event.allQuestsCompleted));
        print('User updated successfully');
      } catch (e) {
        print('Error updating user: $e');
        emit(UserError('Failed to update user: ${e.toString()}'));
      }
    } else {
      print('UpdateUserStreak event received but state is not UserLoaded');
    }
  }

  void _onOptimisticUpdateStreak(
      OptimisticUpdateStreak event, Emitter<UserState> emit) {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final updatedUser = _updateUserData(currentState.user, event);
      emit(UserLoaded(updatedUser, event.allQuestsCompleted));
      print('User state optimistically updated');
    } else {
      print(
          'OptimisticUpdateStreak event received but state is not UserLoaded');
    }
  }

  Future<void> _onRevertOptimisticUpdate(
      RevertOptimisticUpdate event, Emitter<UserState> emit) async {
    if (_lastConfirmedUser != null) {
      print('Reverting optimistic update for user: ${event.userId}');
      emit(UserLoaded(_lastConfirmedUser!,
          TimeParser.isToday(_lastConfirmedUser!.lastCompletedDate)));
    } else {
      print('No confirmed user state to revert to');
    }
  }

  User _updateUserData(User user, dynamic event) {
    final today = TimeParser.getMalaysiaTime();
    final lastCompleted = user.lastCompletedDate;

    int newStreak = user.currentStreak;
    if (event.allQuestsCompleted) {
      if (!TimeParser.isToday(lastCompleted)) {
        if (TimeParser.isConsecutiveDay(lastCompleted)) {
          newStreak++;
        } else {
          newStreak = 1;
        }
      }
    }

    final updatedCompletedQuestIds = List<String>.from(user.completedQuestIds);
    if (!updatedCompletedQuestIds.contains(event.completedQuestId)) {
      updatedCompletedQuestIds.add(event.completedQuestId);
    }

    return user.copyWith(
      currentStreak: newStreak,
      lastCompletedDate:
          event.allQuestsCompleted ? today : user.lastCompletedDate,
      lastQuestUpdate: today,
      // Always update lastQuestUpdate when a quest is completed
      totalPoints: event.pointsEarned + user.totalPoints,
      completedSessions:
          user.completedSessions + (event.allQuestsCompleted ? 1 : 0),
      completedQuestIds: updatedCompletedQuestIds,
    );
  }

  Future<void> _onSubmitCoachRating(
      SubmitCoachRating event, Emitter<UserState> emit) async {
    try {
      await _userRepository.submitCoachRating(event.coachId, event.rating);
      emit(CoachRatingSubmitted());
    } catch (e) {
      emit(UserError('Failed to submit coach rating: ${e.toString()}'));
    }
  }
}
