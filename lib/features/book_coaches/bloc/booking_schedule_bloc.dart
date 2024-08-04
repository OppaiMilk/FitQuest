import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';

// Events
abstract class CoachScheduleEvent {
  const CoachScheduleEvent();

  List<Object> get props => [];
}

class LoadCoachSchedule extends CoachScheduleEvent {
  final String coachId;

  const LoadCoachSchedule(this.coachId);

  @override
  List<Object> get props => [coachId];
}

// States
abstract class CoachScheduleState {
  const CoachScheduleState();

  List<Object> get props => [];
}

class CoachScheduleInitial extends CoachScheduleState {}

class CoachScheduleLoading extends CoachScheduleState {}

class CoachScheduleLoaded extends CoachScheduleState {
  final List<Booking> bookings;

  const CoachScheduleLoaded(this.bookings);

  @override
  List<Object> get props => [bookings];
}

class CoachScheduleError extends CoachScheduleState {
  final String message;

  const CoachScheduleError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class CoachScheduleBloc extends Bloc<CoachScheduleEvent, CoachScheduleState> {
  final BookingRepository bookingRepository;

  CoachScheduleBloc({required this.bookingRepository}) : super(CoachScheduleInitial()) {
    on<LoadCoachSchedule>(_onLoadCoachSchedule);
  }

  Future<void> _onLoadCoachSchedule(
    LoadCoachSchedule event,
    Emitter<CoachScheduleState> emit,
  ) async {
    emit(CoachScheduleLoading());
    try {
      final bookings = await bookingRepository.getBookingsForCoach(event.coachId);
      emit(CoachScheduleLoaded(bookings));
    } catch (e) {
      emit(CoachScheduleError(e.toString()));
    }
  }
}