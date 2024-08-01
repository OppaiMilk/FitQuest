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
  final String completedQuestId;

  UpdateStreak({
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

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
    on<UpdateStreak>(_onUpdateStreak);
    on<OptimisticUpdateStreak>(_onOptimisticUpdateStreak);
    on<RevertOptimisticUpdate>(_onRevertOptimisticUpdate);
  }

  Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final user = await _userRepository.getUserById(event.userId);
      final allQuestsCompletedToday = TimeParser.isToday(user.lastCompletedDate);
      emit(UserLoaded(user, allQuestsCompletedToday));
      print('User fetched successfully: ${user.id}');
    } catch (e) {
      print('Error fetching user: $e');
      emit(UserError('Failed to fetch user: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateStreak(UpdateStreak event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final currentUser = currentState.user;

      print('Updating streak for user: ${currentUser.id}');
      print('All quests completed: ${event.allQuestsCompleted}');
      print('Points earned: ${event.pointsEarned}');

      final today = TimeParser.getMalaysiaTime();
      final lastCompleted = currentUser.lastCompletedDate;

      int newStreak = currentUser.currentStreak;
      if (event.allQuestsCompleted) {
        if (!TimeParser.isToday(lastCompleted)) {
          if (TimeParser.isConsecutiveDay(lastCompleted)) {
            newStreak++;
            print('Streak increased to: $newStreak');
          } else {
            newStreak = 1;
            print('Streak reset to 1');
          }
        }
      }

      final updatedCompletedQuestIds = List<String>.from(currentUser.completedQuestIds);
      if (!updatedCompletedQuestIds.contains(event.completedQuestId)) {
        updatedCompletedQuestIds.add(event.completedQuestId);
        print('Added completed quest: ${event.completedQuestId}');
      }

      final updatedUser = currentUser.copyWith(
        currentStreak: newStreak,
        lastCompletedDate: event.allQuestsCompleted ? today : currentUser.lastCompletedDate,
        totalPoints: currentUser.totalPoints + event.pointsEarned,
        completedSessions: currentUser.completedSessions + (event.allQuestsCompleted ? 1 : 0),
        completedQuestIds: updatedCompletedQuestIds,
      );

      try {
        await _userRepository.updateUser(updatedUser);
        emit(UserLoaded(updatedUser, event.allQuestsCompleted));
        print('User updated successfully');
      } catch (e) {
        print('Error updating user: $e');
        emit(UserError('Failed to update user: ${e.toString()}'));
      }
    } else {
      print('UpdateStreak event received but state is not UserLoaded');
    }
  }

  Future<void> _onOptimisticUpdateStreak(OptimisticUpdateStreak event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      final currentUser = currentState.user;

      print('Optimistically updating streak for user: ${currentUser.id}');
      print('All quests completed: ${event.allQuestsCompleted}');
      print('Points earned: ${event.pointsEarned}');

      final today = TimeParser.getMalaysiaTime();
      final lastCompleted = currentUser.lastCompletedDate;

      int newStreak = currentUser.currentStreak;
      if (event.allQuestsCompleted) {
        if (!TimeParser.isToday(lastCompleted)) {
          if (TimeParser.isConsecutiveDay(lastCompleted)) {
            newStreak++;
            print('Streak optimistically increased to: $newStreak');
          } else {
            newStreak = 1;
            print('Streak optimistically reset to 1');
          }
        }
      }

      final updatedCompletedQuestIds = List<String>.from(currentUser.completedQuestIds);
      if (!updatedCompletedQuestIds.contains(event.completedQuestId)) {
        updatedCompletedQuestIds.add(event.completedQuestId);
        print('Optimistically added completed quest: ${event.completedQuestId}');
      }

      final updatedUser = currentUser.copyWith(
        currentStreak: newStreak,
        lastCompletedDate: event.allQuestsCompleted ? today : currentUser.lastCompletedDate,
        totalPoints: currentUser.totalPoints + event.pointsEarned,
        completedSessions: currentUser.completedSessions + (event.allQuestsCompleted ? 1 : 0),
        completedQuestIds: updatedCompletedQuestIds,
      );

      emit(UserLoaded(updatedUser, event.allQuestsCompleted));
      print('User state optimistically updated');

      // Perform the actual update on the server
      try {
        await _userRepository.updateUser(updatedUser);
        print('Server update successful');
      } catch (e) {
        print('Error updating user on server: $e');
        print('Reverting to previous state');
        emit(currentState);
      }
    } else {
      print('OptimisticUpdateStreak event received but state is not UserLoaded');
    }
  }

  Future<void> _onRevertOptimisticUpdate(RevertOptimisticUpdate event, Emitter<UserState> emit) async {
    if (state is UserLoaded) {
      final currentState = state as UserLoaded;
      print('Reverting optimistic update for user: ${event.userId}');
      // Fetch the latest user data from the server to ensure consistency
      try {
        final updatedUser = await _userRepository.getUserById(event.userId);
        print('Successfully fetched updated user data from server');
        emit(UserLoaded(updatedUser, TimeParser.isToday(updatedUser.lastCompletedDate)));
      } catch (e) {
        print('Failed to fetch updated user data: $e');
        print('Keeping current state to avoid data loss');
        emit(currentState);
      }
    } else {
      print('RevertOptimisticUpdate event received but state is not UserLoaded');
    }
  }
}