import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Event class
abstract class CoachApprovalEvent {}

class LoadPendingApprovals extends CoachApprovalEvent {}

// State class
abstract class CoachApprovalState {}

class CoachApprovalInitial extends CoachApprovalState {}

class CoachApprovalLoading extends CoachApprovalState {}

class CoachApprovalLoaded extends CoachApprovalState {
  final List<QueryDocumentSnapshot> pendingApprovals;

  CoachApprovalLoaded(this.pendingApprovals);
}

class CoachApprovalError extends CoachApprovalState {
  final String message;

  CoachApprovalError(this.message);
}

// Bloc class
class CoachApprovalBloc extends Bloc<CoachApprovalEvent, CoachApprovalState> {
  final FirebaseFirestore firestore;

  CoachApprovalBloc(this.firestore) : super(CoachApprovalInitial()) {
    on<LoadPendingApprovals>(_onLoadPendingApprovals);
  }

  Future<void> _onLoadPendingApprovals(
      LoadPendingApprovals event, Emitter<CoachApprovalState> emit) async {
    emit(CoachApprovalLoading());
    try {
      var snapshot = await firestore
          .collection('Users')
          .where('role', isEqualTo: 'coach')
          .where('status', isEqualTo: 'pending')
          .get();
      emit(CoachApprovalLoaded(snapshot.docs));
    } catch (e) {
      emit(CoachApprovalError(e.toString()));
    }
  }
}
