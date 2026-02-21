import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xs = 8;
  static const double md = 16;
  static const double lg = 24;
}

class AppTransitions {
  AppTransitions._();

  static Route<T> fadeSlide<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      transitionsBuilder: (_, animation, __, child) {
        final offsetTween = Tween<Offset>(
          begin: const Offset(0, 0.05),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: animation.drive(
              offsetTween.chain(CurveTween(curve: Curves.easeOutCubic)),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
