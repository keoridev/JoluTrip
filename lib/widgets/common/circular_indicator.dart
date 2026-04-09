import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class CircularIndicator extends StatelessWidget {
  final double value;
  final double size;
  final double strokeWidth;
  final bool showPercentage;
  final Color? backgroundColor;

  const CircularIndicator({
    super.key,
    required this.value,
    this.size = 60,
    this.strokeWidth = 4,
    this.showPercentage = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final percent = (value * 100).toInt();
    
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: value),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, child) {
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: animatedValue,
                strokeWidth: strokeWidth,
                backgroundColor: backgroundColor ?? Colors.grey.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                strokeCap: StrokeCap.round,
              ),
              if (showPercentage)
                Center(
                  child: Text(
                    '$percent%',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: size * 0.2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}