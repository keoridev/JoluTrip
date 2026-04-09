import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String label;
  final Animation<double> formAnimation;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.label,
    required this.formAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: formAnimation,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceM,
            vertical: AppDimens.spaceM,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppDimens.radiusXL),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppDimens.iconSizeS,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}