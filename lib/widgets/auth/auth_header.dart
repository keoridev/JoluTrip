import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';

class AuthHeader extends StatelessWidget {
  final Animation<double> scaleAnimation;
  final Animation<double> formAnimation;

  const AuthHeader({
    super.key,
    required this.scaleAnimation,
    required this.formAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.travel_explore,
                size: 60,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          FadeTransition(
            opacity: formAnimation,
            child: const Text(
              'Jolu Trip',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceXS),
          FadeTransition(
            opacity: formAnimation,
            child: const Text(
              'Путешествуй с комфортом',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}