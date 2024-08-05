import 'package:calories_tracking/features/book_coaches/models/booking.dart';
import 'package:calories_tracking/features/book_coaches/repositories/booking_repository.dart';
import 'package:calories_tracking/features/coach_main/bloc/coach_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class BookingEvent{}

class FetchBooking extends BookingEvent {}

class UpdateBookingStatus extends BookingEvent {
  final String bookingId;
  final String status;

  UpdateBookingStatus(this.bookingId, this.status);
}

// States
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;

  BookingLoaded(this.bookings);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

// BLoC
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository _bookingRepository;
  final CoachBloc _coachBloc;

  BookingBloc(this._bookingRepository, this._coachBloc) : super(BookingInitial()) {
    on<FetchBooking>(_onFetchBooking);
  }

  Future<void> _onFetchBooking(FetchBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await _bookingRepository.getBookings();
      final coachState = _coachBloc.state;
      if (coachState is CoachLoaded) {
        emit(BookingLoaded(bookings));
      } else {
        emit(BookingLoaded(bookings));
      }
    } catch (e) {
      emit(BookingError('Failed to fetch bookings: ${e.toString()}'));
    }
  }
}