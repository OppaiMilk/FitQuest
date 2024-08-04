import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/features/community/models/activity.dart';
import 'package:calories_tracking/features/community/repositories/activity_repository.dart';

// Events
abstract class ActivityEvent {}

class LoadActivities extends ActivityEvent {}

class LoadActivityDetails extends ActivityEvent {
  final String activityId;

  LoadActivityDetails(this.activityId);
}

// States
abstract class ActivityState {}

class ActivityInitial extends ActivityState {}

class ActivityLoading extends ActivityState {}

class ActivitiesLoaded extends ActivityState {
  final List<Activity> activities;

  ActivitiesLoaded(this.activities);
}

class ActivityDetailsLoaded extends ActivityState {
  final Activity activity;

  ActivityDetailsLoaded(this.activity);
}

class ActivityError extends ActivityState {
  final String message;

  ActivityError(this.message);
}

// Bloc
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final ActivityRepository _activityRepository;

  ActivityBloc(this._activityRepository) : super(ActivityInitial()) {
    on<LoadActivities>((event, emit) async {
      emit(ActivityLoading());
      try {
        final activities = await _activityRepository.getActivities();
        emit(ActivitiesLoaded(activities));
      } catch (e) {
        emit(ActivityError(e.toString()));
      }
    });

    on<LoadActivityDetails>((event, emit) async {
      emit(ActivityLoading());
      try {
        final activity = await _activityRepository.getActivityDetails(event.activityId);
        emit(ActivityDetailsLoaded(activity));
      } catch (e) {
        emit(ActivityError(e.toString()));
      }
    });
  }
}