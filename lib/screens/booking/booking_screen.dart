import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/providers/booking_provider.dart';
import 'package:jolu_trip/services/payment_service.dart';
import 'package:jolu_trip/utils/booking_utils.dart';
import 'package:jolu_trip/widgets/booking/booking_bottom_bar.dart';
import 'package:jolu_trip/widgets/booking/booking_calendar.dart';
import 'package:jolu_trip/widgets/booking/booking_confirmation_sheet.dart';
import 'package:jolu_trip/widgets/booking/booking_dialogs/card_payment_sheet.dart';
import 'package:jolu_trip/widgets/booking/booking_dialogs/loading_dialog.dart';
import 'package:jolu_trip/widgets/booking/booking_dialogs/payment_methods_sheet.dart';
import 'package:jolu_trip/widgets/booking/booking_dialogs/qr_code_dialog.dart';
import 'package:jolu_trip/widgets/booking/booking_dialogs/success_dialog.dart';
import 'package:jolu_trip/widgets/booking/price_info_card.dart';
import 'package:jolu_trip/widgets/booking/booking_header.dart';

import 'package:provider/provider.dart';

class BookingScreen extends StatefulWidget {
  final GuidesModel guide;
  final LocationModel location;

  const BookingScreen({
    super.key,
    required this.guide,
    required this.location,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final BookingProvider _bookingProvider;
  late final PaymentService _paymentService;
  late final BookingUtils _bookingUtils;

  final double _depositPercent = 10;
  late int _depositAmount;
  late int _remainingAmount;

  @override
  void initState() {
    super.initState();
    _bookingProvider = BookingProvider();
    _bookingProvider.init();
    _paymentService = PaymentService();
    _bookingUtils = BookingUtils();

    _depositAmount =
        (widget.guide.priceService * _depositPercent / 100).round();
    _remainingAmount = widget.guide.priceService - _depositAmount;
  }

  @override
  void dispose() {
    _bookingProvider.disposeProvider();
    super.dispose();
  }

  void _showBookingConfirmation() {
    if (_bookingProvider.selectedDay == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BookingConfirmationSheet(
        selectedDate: _bookingProvider.selectedDay!,
        guide: widget.guide,
        depositAmount: _depositAmount,
        remainingAmount: _remainingAmount,
        depositPercent: _depositPercent,
        onConfirm: () {
          Navigator.pop(context);
          _showPaymentMethods();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showPaymentMethods() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodsSheet(
        depositAmount: _depositAmount,
        onQRPayment: () {
          Navigator.pop(context);
          _showQRPayment();
        },
        onMBankPayment: () {
          Navigator.pop(context);
          _openMBank();
        },
        onCardPayment: () {
          Navigator.pop(context);
          _showCardPayment();
        },
      ),
    );
  }

  void _showQRPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QRCodeDialog(
        depositAmount: _depositAmount,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pop(context);
          _processPaymentSuccess();
        },
      ),
    );
  }

  void _showCardPayment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CardPaymentSheet(
        depositAmount: _depositAmount,
        onPay: () {
          Navigator.pop(context);
          _processCardPayment();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _openMBank() async {
    try {
      await _paymentService.openMBank();
      _showPaymentConfirmationDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showPaymentConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimens.spaceXS),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: AppColors.primary),
            ),
            const SizedBox(width: AppDimens.spaceS),
            const Text('Подтверждение', style: AppTextStyles.titleLarge),
          ],
        ),
        content: Text(
          'Вы успешно оплатили депозит $_depositAmount сом?',
          style: AppTextStyles.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Еще нет',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processPaymentSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
            child: const Text('Да, оплачено'),
          ),
        ],
      ),
    );
  }

  void _processCardPayment() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          const LoadingDialog(message: 'Обработка платежа...'),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _processPaymentSuccess();
    });
  }

  void _processPaymentSuccess() {
    if (_bookingProvider.selectedDay != null) {
      _bookingProvider.markDateAsBooked(_bookingProvider.selectedDay!);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SuccessDialog(
        selectedDay: _bookingProvider.selectedDay!,
        depositAmount: _depositAmount,
        remainingAmount: _remainingAmount,
        guide: widget.guide,
        onClose: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onCall: () =>
            _paymentService.makePhoneCall(widget.guide.whatsapp.toString()),
        onWhatsApp: () => _bookingUtils.openWhatsApp(
          widget.guide.whatsapp.toString(),
          _bookingProvider.selectedDay!,
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text('Ошибка', style: AppTextStyles.titleLarge),
        content: Text(message, style: AppTextStyles.bodyLarge),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _bookingProvider,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: CustomScrollView(
          slivers: [
            BookingHeader(
              guide: widget.guide,
              location: widget.location,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppDimens.spaceXS),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusM,
                            ),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceS),
                        Text(
                          'Выберите дату тура',
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spaceXS),
                    Text(
                      'Зеленые точки — доступные даты, красные — занятые',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spaceL),
                    const BookingCalendar(),
                    const SizedBox(height: AppDimens.spaceXL),
                    PriceInfoCard(
                      guide: widget.guide,
                      depositAmount: _depositAmount,
                      remainingAmount: _remainingAmount,
                      depositPercent: _depositPercent,
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BookingBottomBar(
          depositAmount: _depositAmount,
          onBookingPressed: _showBookingConfirmation,
        ),
      ),
    );
  }
}
