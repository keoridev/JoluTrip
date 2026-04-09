import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BookingBottomBar extends StatelessWidget {
  final int depositAmount;
  final VoidCallback onBookingPressed;

  const BookingBottomBar({
    super.key,
    required this.depositAmount,
    required this.onBookingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, provider, child) {
        final bool canBook = provider.selectedDay != null &&
            provider.isDateAvailable(provider.selectedDay!);

        return Container(
          padding: const EdgeInsets.all(AppDimens.spaceM),
          decoration: BoxDecoration(
            color: AppColors.cardDark,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimens.radiusXL),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (provider.selectedDay != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.event_available,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppDimens.spaceXS),
                      Text(
                        DateFormat('d MMMM yyyy', 'ru')
                            .format(provider.selectedDay!),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTextStyles.buttonLarge.fontWeight,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceS),
                ],
                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeightL,
                  child: ElevatedButton(
                    onPressed: canBook ? onBookingPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.cardDark,
                      disabledForegroundColor: AppColors.textSecondaryDark,
                      elevation: canBook ? 4 : 0,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusL),
                        side: canBook
                            ? BorderSide.none
                            : const BorderSide(color: Colors.white12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          canBook
                              ? Icons.calendar_today
                              : Icons.calendar_today_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: AppDimens.spaceS),
                        Text(
                          canBook
                              ? 'Забронировать за $depositAmount сом'
                              : 'Выберите дату',
                          style: AppTextStyles.buttonLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
