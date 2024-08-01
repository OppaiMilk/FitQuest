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

  QuestLoaded(this.quests);

  double get completionPercentage {
    int completedQuests = quests.where((quest) => quest.completed).length;
    return completedQuests / quests.length;
  }

  bool get allQuestsCompleted {
    return quests.every((quest) => quest.completed);
  }

  QuestLoaded copyWith({List<Quest>? quests}) {
    return QuestLoaded(quests ?? this.quests);
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
      emit(QuestLoaded(quests));
    } catch (e) {
      emit(QuestError('Failed to fetch quests: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateQuestStatus(UpdateQuestStatus event, Emitter<QuestState> emit) async {
    if (state is QuestLoaded) {
      final currentState = state as QuestLoaded;
      final updatedQuests = currentState.quests.map((quest) {
        if (quest.id == event.questId) {
          // Only allow updating if the quest is not already completed
          if (!quest.completed) {
            return quest.copyWith(completed: event.completed);
          }
        }
        return quest;
      }).toList();

      final newState = currentState.copyWith(quests: updatedQuests);
      emit(newState);

      // Calculate total points earned
      int pointsEarned = updatedQuests
          .where((quest) => quest.completed)
          .fold(0, (sum, quest) => sum + quest.points);

      // Update the user's streak and points
      _userBloc.add(UpdateStreak(
        userId: 'currentUserId', // TODO get current user id
        allQuestsCompleted: newState.allQuestsCompleted,
        pointsEarned: pointsEarned,
      ));

      // Only update the quest status on the server if it was actually changed
      if (updatedQuests != currentState.quests) {
        await _questRepository.updateQuestStatus(event.questId, event.completed);
      }
    }
  }
}