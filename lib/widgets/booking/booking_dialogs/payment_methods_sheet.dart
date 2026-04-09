import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class PaymentMethodsSheet extends StatelessWidget {
  final int depositAmount;
  final VoidCallback onQRPayment;
  final VoidCallback onMBankPayment;
  final VoidCallback onCardPayment;

  const PaymentMethodsSheet({
    super.key,
    required this.depositAmount,
    required this.onQRPayment,
    required this.onMBankPayment,
    required this.onCardPayment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ),
      ),
      padding: const EdgeInsets.all(AppDimens.spaceL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.payment,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),
          Text(
            'Способ оплаты',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXS),
          Text(
            'Сумма депозита: $depositAmount сом',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),
          _buildPaymentOption(
            icon: Icons.qr_code_scanner,
            title: 'QR-код',
            subtitle: 'Отсканируйте в приложении банка',
            color: Colors.green.shade600,
            onTap: onQRPayment,
          ),
          const SizedBox(height: AppDimens.spaceM),
          _buildPaymentOption(
            icon: Icons.phone_android,
            title: 'MBank',
            subtitle: 'Переход в приложение',
            color: Colors.blue.shade600,
            onTap: onMBankPayment,
          ),
          const SizedBox(height: AppDimens.spaceM),
          _buildPaymentOption(
            icon: Icons.credit_card,
            title: 'Банковская карта',
            subtitle: 'Visa, MasterCard, Элкарт',
            color: Colors.orange.shade600,
            onTap: onCardPayment,
          ),
          const SizedBox(height: AppDimens.spaceXL),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spaceM),
        decoration: BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceS),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: AppDimens.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondaryDark,
            ),
          ],
        ),
      ),
    );
  }
}
