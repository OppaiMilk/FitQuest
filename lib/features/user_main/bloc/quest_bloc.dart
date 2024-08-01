import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/repositories/quest_repository.dart';

// Events
abstract class QuestEvent {
  const QuestEvent();

  List<Object> get props => [];
}

class FetchQuests extends QuestEvent {}

class UpdateQuestStatus extends QuestEvent {
  final int index;
  final bool status;

  const UpdateQuestStatus(this.index, this.status);

  @override
  List<Object> get props => [index, status];
}

// States
abstract class QuestState {
  const QuestState();

  List<Object> get props => [];
}

class QuestInitial extends QuestState {}

class QuestLoading extends QuestState {}

class QuestLoaded extends QuestState {
  final List<Quest> quests;
  final List<bool> questCompletionStatus;

  const QuestLoaded(this.quests, this.questCompletionStatus);

  @override
  List<Object> get props => [quests, questCompletionStatus];

  double get completionPercentage {
    int completedQuests =
        questCompletionStatus.where((status) => status).length;
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

  const QuestError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class QuestBloc extends Bloc<QuestEvent, QuestState> {
  final QuestRepository _questRepository;

  QuestBloc(this._questRepository) : super(QuestInitial()) {
    on<FetchQuests>(_onFetchQuests);
    on<UpdateQuestStatus>(_onUpdateQuestStatus);
  }

  Future<void> _onFetchQuests(
      FetchQuests event, Emitter<QuestState> emit) async {
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
      emit(currentState.copyWith(questCompletionStatus: updatedStatus));
    }
  }
}
