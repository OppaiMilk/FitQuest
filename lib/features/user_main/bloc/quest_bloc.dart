import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';

// Events
abstract class QuestEvent {}

class FetchQuests extends QuestEvent {}

class UpdateQuestStatus extends QuestEvent {
  final int index;
  final bool status;

  UpdateQuestStatus(this.index, this.status);
}

// States
abstract class QuestState {}

class QuestInitial extends QuestState {}

class QuestLoading extends QuestState {}

class QuestLoaded extends QuestState {
  final List<Quest> quests;
  final List<bool> questCompletionStatus;

  QuestLoaded(this.quests, this.questCompletionStatus);

  double get completionPercentage {
    int completedQuests = questCompletionStatus.where((status) => status).length;
    return completedQuests / questCompletionStatus.length;
  }

  QuestLoaded copyWith({
    List<Quest>? quests,
    List<bool>? questCompletionStatus,
  }) {
    return QuestLoaded(
      quests ?? this.quests,
      questCompletionStatus ?? this.questCompletionStatus,
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
      final questCompletionStatus = List<bool>.filled(quests.length, false);
      emit(QuestLoaded(quests, questCompletionStatus));
    } catch (e) {
      emit(QuestError('Failed to fetch quests: ${e.toString()}'));
    }
  }

  void _onUpdateQuestStatus(UpdateQuestStatus event, Emitter<QuestState> emit) {
    if (state is QuestLoaded) {
      final currentState = state as QuestLoaded;
      final updatedStatus = List<bool>.from(currentState.questCompletionStatus);
      updatedStatus[event.index] = event.status;

      final newState = currentState.copyWith(questCompletionStatus: updatedStatus);
      emit(newState);

      // Calculate total points earned and check if all quests are completed
      int pointsEarned = 0;
      bool allQuestsCompleted = true;
      for (int i = 0; i < newState.quests.length; i++) {
        if (newState.questCompletionStatus[i]) {
          pointsEarned += newState.quests[i].points;
        } else {
          allQuestsCompleted = false;
        }
      }

      // Update the user's streak and points
      _userBloc.add(UpdateStreak(
        userId: 'currentUserId', // You'll need to get the actual user ID
        allQuestsCompleted: allQuestsCompleted,
        pointsEarned: pointsEarned,
      ));
    }
  }
}