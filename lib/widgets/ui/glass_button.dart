import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final IconData icon;
  final double opacity;
  final VoidCallback onTap;

  const GlassButton({
    super.key,
    required this.icon,
    required this.opacity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        opacity: opacity < 0.05 ? 0 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.28),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
