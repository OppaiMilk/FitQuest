import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';

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
        return AlertDialog(
          title: const Text(
            'Confirm Submission',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: Text(
            'Are you sure you want to submit a rating of ${_rating.toStringAsFixed(1)} stars?',
            style: const TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _submitRating();
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
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
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: Text(
            content,
            style: const TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (onDismiss != null) onDismiss();
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
        );
      },
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
                Navigator.of(context)
                    .pop(true); // Return true to indicate successful submission
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
        onPressed: () =>
            Navigator.pop(context, false), // Return false if user cancels
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
        backgroundColor: Colors.grey,
        textColor: Colors.black,
        onPressed: _showConfirmationDialog,
      ),
    );
  }
}
