import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';

class SuccessDialog extends StatelessWidget {
  final DateTime selectedDay;
  final int depositAmount;
  final int remainingAmount;
  final GuidesModel guide;
  final VoidCallback onClose;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  const SuccessDialog({
    super.key,
    required this.selectedDay,
    required this.depositAmount,
    required this.remainingAmount,
    required this.guide,
    required this.onClose,
    required this.onCall,
    required this.onWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceM),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade600,
                    Colors.green.shade400,
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'Бронирование подтверждено!',
              style: AppTextStyles.headlineMedium.copyWith(
                color: Colors.green.shade400,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              'Депозит $depositAmount сом получен',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceM),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    Icons.calendar_today,
                    'Дата тура',
                    DateFormat('d MMMM yyyy', 'ru').format(selectedDay),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: AppDimens.spaceS),
                  _buildDetailRow(
                    Icons.payments_outlined,
                    'Остаток к оплате',
                    '$remainingAmount сом гиду',
                    color: Colors.amber.shade400,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceM),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.contact_phone,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppDimens.spaceS),
                      Text(
                        'Контакты гида',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceM),
                  Text(
                    guide.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                  Row(
                    children: [
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.phone,
                          label: 'Позвонить',
                          onTap: onCall,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spaceS),
                      Expanded(
                        child: _buildContactButton(
                          icon: Icons.chat,
                          label: 'WhatsApp',
                          onTap: onWhatsApp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),
            ElevatedButton(
              onPressed: onClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                ),
              ),
              child: const Text('Отлично!'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? AppColors.textSecondaryDark),
        const SizedBox(width: AppDimens.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
              ),
              Text(
                value,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: color ?? AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceS),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: color ?? AppColors.primary,
            ),
            const SizedBox(width: AppDimens.spaceXS),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color ?? AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
