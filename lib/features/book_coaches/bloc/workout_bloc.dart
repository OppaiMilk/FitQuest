import 'package:calories_tracking/features/workouts/models/workout.dart';
import 'package:calories_tracking/features/workouts/repositories/workout_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class WorkoutEvent {}

class LoadWorkouts extends WorkoutEvent {}

// States
abstract class WorkoutState {}

class WorkoutInitial extends WorkoutState {}

class WorkoutLoading extends WorkoutState {}

class WorkoutLoaded extends WorkoutState {
  final List<Workout> workouts;
  WorkoutLoaded(this.workouts);
}

class WorkoutError extends WorkoutState {
  final String message;
  WorkoutError(this.message);
}

// Bloc
class WorkoutBloc extends Bloc<WorkoutEvent, WorkoutState> {
  final WorkoutRepository _workoutRepository;

  WorkoutBloc(this._workoutRepository) : super(WorkoutInitial()) {
    on<LoadWorkouts>((event, emit) async {
      emit(WorkoutLoading());
      try {
        final workouts = await _workoutRepository.getWorkouts();
        emit(WorkoutLoaded(workouts));
      } catch (e) {
        emit(WorkoutError(e.toString()));
      }
    });
  }
}
