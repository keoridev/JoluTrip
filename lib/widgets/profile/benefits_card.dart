import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class BenefitItem {
  final IconData icon;
  final String label;
  final int discount;
  final Color color;
  final String? description;

  const BenefitItem({
    required this.icon,
    required this.label,
    required this.discount,
    required this.color,
    this.description,
  });
}

class BenefitsCard extends StatefulWidget {
  final String title;
  final IconData titleIcon;
  final List<BenefitItem> benefits;
  final bool isDark;
  final VoidCallback? onMoreTap;

  const BenefitsCard({
    super.key,
    required this.title,
    required this.titleIcon,
    required this.benefits,
    required this.isDark,
    this.onMoreTap,
  });

  @override
  State<BenefitsCard> createState() => _BenefitsCardState();
}

class _BenefitsCardState extends State<BenefitsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimens.spaceL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isDark 
              ? [
                  const Color(0xFF1a1a2e).withOpacity(0.9),
                  const Color(0xFF16213e).withOpacity(0.9),
                ]
              : [
                  Colors.white.withOpacity(0.95),
                  Colors.grey.shade50.withOpacity(0.95),
                ],
        ),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        child: Stack(
          children: [
            _buildBackgroundGlow(),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppDimens.spaceL),
                  _buildBenefitsGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return Positioned(
      top: -50,
      right: -50,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primary.withOpacity(0.2),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            widget.titleIcon, 
            color: Colors.white, 
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: AppTextStyles.titleMedium.copyWith(
                  color: widget.isDark 
                      ? AppColors.textPrimaryDark 
                      : AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              Text(
                'Активные скидки',
                style: AppTextStyles.bodySmall.copyWith(
                  color: widget.isDark 
                      ? AppColors.textSecondaryDark 
                      : AppColors.textSecondaryLight,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (widget.onMoreTap != null)
          GestureDetector(
            onTap: widget.onMoreTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBenefitsGrid() {
    return Row(
      children: widget.benefits.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.15;
              final value = _controller.value > delay 
                  ? ((_controller.value - delay) / (1 - delay)).clamp(0.0, 1.0)
                  : 0.0;
              
              return Transform.translate(
                offset: Offset(0, 30 * (1 - value)),
                child: Opacity(
                  opacity: value,
                  child: _BenefitBadge(
                    item: item, 
                    isDark: widget.isDark,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class _BenefitBadge extends StatefulWidget {
  final BenefitItem item;
  final bool isDark;

  const _BenefitBadge({required this.item, required this.isDark});

  @override
  State<_BenefitBadge> createState() => _BenefitBadgeState();
}

class _BenefitBadgeState extends State<_BenefitBadge> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.item.color.withOpacity(0.15),
              widget.item.color.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          border: Border.all(
            color: widget.item.color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.item.color.withOpacity(_isPressed ? 0.2 : 0.1),
              blurRadius: _isPressed ? 8 : 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.item.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.item.icon, 
                color: widget.item.color, 
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.item.color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.item.color.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                '-${widget.item.discount}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: widget.isDark 
                    ? AppColors.textSecondaryDark 
                    : AppColors.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}