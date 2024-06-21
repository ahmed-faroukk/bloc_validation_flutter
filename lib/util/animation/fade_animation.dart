import 'package:flutter/cupertino.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration(milliseconds: 500), // Set transition duration to 2 seconds

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = 0.0;
      var end = 1.0;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return FadeTransition(
        opacity: animation.drive(tween),
        child: child,
      );
    },
  );
}