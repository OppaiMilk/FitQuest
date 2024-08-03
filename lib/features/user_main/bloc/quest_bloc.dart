import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';

// Events
abstract class QuestEvent {}

class FetchQuests extends QuestEvent {}

class UpdateQuestStatus extends QuestEvent {
  final String questId;
  final bool completed;

  UpdateQuestStatus(this.questId, this.completed);
}

// States
abstract class QuestState {}

class QuestInitial extends QuestState {}

class QuestLoading extends QuestState {}

class QuestLoaded extends QuestState {
  final List<Quest> quests;
  final List<String> completedQuestIds;

  QuestLoaded(this.quests, this.completedQuestIds);

  double get completionPercentage {
    return completedQuestIds.length / quests.length;
  }

  bool get allQuestsCompleted {
    return completedQuestIds.length == quests.length;
  }

  QuestLoaded copyWith({List<Quest>? quests, List<String>? completedQuestIds}) {
    return QuestLoaded(
      quests ?? this.quests,
      completedQuestIds ?? this.completedQuestIds,
    );
  }
}

class QuestError extends QuestState {
  final String message;

  QuestError(this.message);
}

// BLoC
class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final QuestRepository _questRepository;
  final UserBloc _userBloc;

  QuestBloc(this._questRepository, this._userBloc) : super(QuestInitial()) {
    on<FetchQuests>(_onFetchQuests);
    on<UpdateQuestStatus>(_onUpdateQuestStatus);
  }

  Future<void> _onFetchQuests(FetchQuests event, Emitter<QuestState> emit) async {
    emit(QuestLoading());
    try {
      final quests = await _questRepository.getQuests();
      final userState = _userBloc.state;
      if (userState is UserLoaded) {
        emit(QuestLoaded(quests, userState.user.completedQuestIds));
      } else {
        emit(QuestLoaded(quests, []));
      }
    } catch (e) {
      emit(QuestError('Failed to fetch quests: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateQuestStatus(UpdateQuestStatus event, Emitter<QuestState> emit) async {
    if (state is QuestLoaded) {
      final currentState = state as QuestLoaded;
      final updatedCompletedQuestIds = List<String>.from(currentState.completedQuestIds);

      // Only allow completing uncompleted quests
      if (event.completed && !updatedCompletedQuestIds.contains(event.questId)) {
        updatedCompletedQuestIds.add(event.questId);

        final newState = currentState.copyWith(completedQuestIds: updatedCompletedQuestIds);
        emit(newState);

        // Calculate points earned
        final quest = currentState.quests.firstWhere((q) => q.id == event.questId);
        int pointsEarned = quest.points;

        // Optimistically update the user's streak and points
        _userBloc.add(OptimisticUpdateStreak(
          userId: 'currentUserId', // TODO: get current user id
          allQuestsCompleted: newState.allQuestsCompleted,
          pointsEarned: pointsEarned,
          completedQuestId: event.questId,
        ));

        // Update the quest status on the server
        try {
          await _questRepository.updateQuestStatus(event.questId, true);
        } catch (e) {
          // If the server update fails, revert the optimistic update
          emit(currentState);
          _userBloc.add(RevertOptimisticUpdate(userId: 'currentUserId'));
        }
      }
      // Ignore attempts to uncheck completed quests
    }
  }
}