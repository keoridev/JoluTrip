import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_dimens.dart';

class AuthToggle extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onToggle;
  final Animation<double> formAnimation;

  const AuthToggle({
    super.key,
    required this.isLogin,
    required this.onToggle,
    required this.formAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: formAnimation,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ToggleButton(
                isSelected: isLogin,
                label: 'Вход',
                onTap: onToggle,
              ),
            ),
            Expanded(
              child: _ToggleButton(
                isSelected: !isLogin,
                label: 'Регистрация',
                onTap: onToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceS),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}