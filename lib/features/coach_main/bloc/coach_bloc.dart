import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class CoachEvent {}

class FetchCoach extends CoachEvent {
  final String coachId;
  FetchCoach(this.coachId);
}

// States
abstract class CoachState {}

class CoachInitial extends CoachState {}

class CoachLoading extends CoachState {}

class CoachLoaded extends CoachState {
  final Coach coach;

  CoachLoaded(this.coach);
}

class CoachError extends CoachState {
  final String message;
  CoachError(this.message);
}

// BLoC
class CoachBloc extends Bloc<CoachEvent, CoachState> {
  final CoachRepository _coachRepository;
  String? _coachId;

  CoachBloc(this._coachRepository) : super(CoachInitial()) {
    on<FetchCoach>(_onFetchCoach);
  }

  String? get coachId => _coachId;

  Future<void> _onFetchCoach(FetchCoach event, Emitter<CoachState> emit) async {
    _coachId = event.coachId;
    emit(CoachLoading());
    try {
      Coach coach = await _coachRepository.getCoachDetails_uid(event.coachId);
      emit(CoachLoaded(coach));
      print('Coach fetched successfully: ${coach.id}');
    } catch (e) {
      print('Error fetching coach: $e');
      emit(CoachError('Failed to fetch coach: ${e.toString()}'));
    }
  }
}
