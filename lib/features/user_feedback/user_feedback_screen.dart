import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';

class FeedbackScreen extends StatefulWidget {
  final String coachId;

  const FeedbackScreen({super.key, required this.coachId});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  double _rating = 0;

  void _updateRating(double rating) {
    setState(() {
      _rating = rating;
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(
          title: 'Confirm Submission',
          content: 'Are you sure you want to submit a rating of ${_rating.toStringAsFixed(1)} stars?',
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitRating();
              },
            ),
          ],
        );
      },
    );
  }

  void _submitRating() {
    if (_rating == 0) {
      _showAlert('Error', 'Please select a rating before submitting.');
      return;
    }

    final userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.add(SubmitCoachRating(coachId: widget.coachId, rating: _rating));

    _showAlert('Submitting...', 'Please wait while we submit your feedback.');
  }

  void _showAlert(String title, String content, {VoidCallback? onDismiss}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(
          title: title,
          content: content,
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onDismiss != null) onDismiss();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.tertiaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.tertiaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                color: AppTheme.tertiaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is CoachRatingSubmitted) {
            Navigator.of(context).pop(); // Dismiss the "Submitting..." dialog
            _showAlert(
              'Thank You',
              'Your feedback (${_rating.toStringAsFixed(1)} stars) has been submitted successfully.',
              onDismiss: () {
                Navigator.of(context).pop(true); // Return true to indicate successful submission
              },
            );
          } else if (state is UserError) {
            Navigator.of(context).pop(); // Dismiss the "Submitting..." dialog
            _showAlert('Error', state.message);
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildRatingBar(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
        onPressed: () => Navigator.pop(context, false), // Return false if user cancels
      ),
      title: const Text(
        'Rate Coach',
        style: TextStyle(
          color: AppTheme.primaryTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'How would you rate this coach?',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildRatingBar() {
    return RatingBar.builder(
      initialRating: _rating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 50,
      itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: _updateRating,
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        label: 'Submit',
        backgroundColor: AppTheme.primaryColor,
        textColor: Colors.white,
        onPressed: _showConfirmationDialog,
      ),
    );
  }
}