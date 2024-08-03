import 'package:flutter/material.dart';

class RouteHelper {
  void redirectTo(BuildContext context, Widget route) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => route),
    );
  }

  Future<T?> redirectToReturn<T>(BuildContext context, Widget route) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (context) => route),
    );
  }

  void backToPrevious(BuildContext context) {
    Navigator.pop(context);
  }
}
