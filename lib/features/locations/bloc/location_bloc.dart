import 'package:calories_tracking/features/locations/models/location.dart';
import 'package:calories_tracking/features/locations/repositories/location_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class LocationEvent {}

class LoadLocations extends LocationEvent {}

// States
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<Location> locations;

  LocationLoaded(this.locations);
}

class LocationError extends LocationState {
  final String message;

  LocationError(this.message);
}

// Bloc
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc(this._locationRepository) : super(LocationInitial()) {
    on<LoadLocations>((event, emit) async {
      emit(LocationLoading());
      try {
        final locations = await _locationRepository.getLocations();
        emit(LocationLoaded(locations));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });
  }
}
