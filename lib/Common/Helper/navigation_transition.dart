import 'package:flutter/material.dart';

/// Custom page route with slide transition from the right to the center
PageRouteBuilder customPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Define the slide animation from the right
      const begin = Offset(1.0, 0.0); // Start off-screen on the right
      const end = Offset.zero; // End at the screen center
      const curve = Curves.easeInOut; // Smooth curve

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: Duration(milliseconds: 25), // Duration of the transition
  );
}
