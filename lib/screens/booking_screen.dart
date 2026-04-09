import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';

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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Статусы дат для календаря
  final Set<DateTime> _unavailableDates = {};
  final Set<DateTime> _loadingDates = {};

  final double _depositPercent = 10;
  late int _depositAmount;
  late int _remainingAmount;

  @override
  void initState() {
    super.initState();
    _depositAmount =
        (widget.guide.priceService * _depositPercent / 100).round();
    _remainingAmount = widget.guide.priceService - _depositAmount;
    _loadBookedDates();
  }

  // Имитация загрузки занятых дат с сервера
  void _loadBookedDates() {
    setState(() {
      _loadingDates.addAll([
        DateTime(2026, 4, 10),
        DateTime(2026, 4, 11),
        DateTime(2026, 4, 15),
        DateTime(2026, 4, 20),
        DateTime(2026, 4, 21),
        DateTime(2026, 4, 22),
      ]);
    });
  }

  bool _isDateAvailable(DateTime date) {
    return !_loadingDates.any((bookedDate) => isSameDay(bookedDate, date));
  }

  bool _isDateInPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return date.isBefore(today);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (_isDateInPast(selectedDay)) {
      _showSnackBar('Нельзя выбрать прошедшую дату', isError: true);
      return;
    }

    if (!_isDateAvailable(selectedDay)) {
      _showSnackBar('Эта дата уже забронирована', isError: true);
      return;
    }

    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: AppDimens.spaceS),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
        ),
        margin: const EdgeInsets.all(AppDimens.spaceM),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ==================== ДИАЛОГИ ОПЛАТЫ ====================

  void _showBookingConfirmation() {
    if (_selectedDay == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BookingConfirmationSheet(
        selectedDate: _selectedDay!,
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
      builder: (context) => _PaymentMethodsSheet(
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
      builder: (context) => _QRCodeDialog(
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
      builder: (context) => _CardPaymentSheet(
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
    final Uri mbankUri = Uri.parse('mbank://payment');
    final Uri fallbackUri = Uri.parse('https://m-bank.kg');

    try {
      if (await canLaunchUrl(mbankUri)) {
        await launchUrl(mbankUri, mode: LaunchMode.externalApplication);
        _showPaymentConfirmationDialog();
      } else {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _showErrorDialog('Не удалось открыть MBank');
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
          const _LoadingDialog(message: 'Обработка платежа...'),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _processPaymentSuccess();
    });
  }

  void _processPaymentSuccess() {
    setState(() {
      if (_selectedDay != null) {
        _unavailableDates.add(_selectedDay!);
      }
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _SuccessDialog(
        selectedDay: _selectedDay!,
        depositAmount: _depositAmount,
        remainingAmount: _remainingAmount,
        guide: widget.guide,
        onClose: () {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onCall: () => _makePhoneCall(widget.guide.whatsapp.toString()),
        onWhatsApp: () => _openWhatsApp(widget.guide.whatsapp.toString()),
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:+996$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showErrorDialog('Не удалось открыть телефон');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    final String message = Uri.encodeComponent(
      'Здравствуйте! Я забронировал(а) тур с вами через Jolu Trip на ${DateFormat('d MMMM yyyy', 'ru').format(_selectedDay!)}. Хотел(а) бы обсудить детали.',
    );
    final Uri whatsappUri =
        Uri.parse('https://wa.me/996$phoneNumber?text=$message');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      _showErrorDialog('Не удалось открыть WhatsApp');
    }
  }

  // ==================== UI ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // AppBar с градиентом и информацией о гиде
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.bgDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                      const Color(0xFF004D40),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.spaceM,
                      60,
                      AppDimens.spaceM,
                      AppDimens.spaceM,
                    ),
                    child: Row(
                      children: [
                        // Аватар гида
                        Hero(
                          tag: 'guide_avatar_${widget.guide.name}',
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.network(
                                widget.guide.avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: AppColors.accent.withOpacity(0.3),
                                  child: const Icon(
                                    Icons.person,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spaceM),
                        // Информация о гиде
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.guide.name,
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppDimens.spaceXXS),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.location.name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.spaceXS),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppDimens.spaceXS,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(
                                        AppDimens.radiusS,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Colors.amber,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${widget.guide.rating}',
                                          style:
                                              AppTextStyles.bodyMedium.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppDimens.spaceS),
                                  Text(
                                    '${widget.guide.priceService} сом',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Контент
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок календаря
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

                  // Календарь
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardDark,
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      child: TableCalendar(
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(const Duration(days: 90)),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        onDaySelected: _onDaySelected,
                        onPageChanged: (focusedDay) {
                          setState(() => _focusedDay = focusedDay);
                        },
                        calendarFormat: CalendarFormat.month,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Месяц',
                        },
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        locale: 'ru_RU',

                        // Стили календаря
                        headerStyle: HeaderStyle(
                          titleCentered: true,
                          formatButtonVisible: false,
                          titleTextStyle: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.textPrimaryDark,
                          ),
                          leftChevronIcon: const Icon(
                            Icons.chevron_left,
                            color: AppColors.primary,
                          ),
                          rightChevronIcon: const Icon(
                            Icons.chevron_right,
                            color: AppColors.primary,
                          ),
                          headerPadding: const EdgeInsets.symmetric(
                            vertical: AppDimens.spaceM,
                          ),
                        ),

                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                          weekendStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: true,
                          todayDecoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          todayTextStyle: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                          selectedDecoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          defaultTextStyle: TextStyle(
                            color: AppColors.textPrimaryDark,
                          ),
                          weekendTextStyle: TextStyle(
                            color: AppColors.textPrimaryDark.withOpacity(0.7),
                          ),
                          disabledTextStyle: TextStyle(
                            color: AppColors.textSecondaryDark.withOpacity(0.5),
                          ),
                          outsideTextStyle: TextStyle(
                            color: AppColors.textSecondaryDark.withOpacity(0.3),
                          ),
                          cellMargin: const EdgeInsets.all(4),
                        ),

                        // Кастомные билдеры
                        calendarBuilders: CalendarBuilders(
                          disabledBuilder: (context, date, _) {
                            if (_loadingDates.any((d) => isSameDay(d, date))) {
                              return Container(
                                margin: const EdgeInsets.all(4),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: AppColors.error.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                          markerBuilder: (context, date, events) {
                            if (_isDateAvailable(date) &&
                                !_isDateInPast(date)) {
                              return Positioned(
                                bottom: 6,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // Информация о цене
                  Container(
                    padding: const EdgeInsets.all(AppDimens.spaceL),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.cardDark,
                          AppColors.cardDark.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Полная стоимость',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                            Text(
                              '${widget.guide.priceService} сом',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: AppColors.textPrimaryDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spaceM),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: AppDimens.spaceM),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppDimens.spaceXS),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusS,
                                ),
                              ),
                              child: Icon(
                                Icons.lock_outline,
                                size: 20,
                                color: Colors.amber.shade400,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spaceS),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Депозит для бронирования ($_depositPercent%)',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.amber.shade400,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Остаток $_remainingAmount сом — гиду на месте',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '$_depositAmount сом',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.amber.shade400,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100), // Отступ для кнопки
                ],
              ),
            ),
          ),
        ],
      ),

      // Плавающая кнопка бронирования
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final bool canBook =
        _selectedDay != null && _isDateAvailable(_selectedDay!);

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
            if (_selectedDay != null) ...[
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
                    DateFormat('d MMMM yyyy', 'ru').format(_selectedDay!),
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
                onPressed: canBook ? _showBookingConfirmation : null,
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
                          ? 'Забронировать за $_depositAmount сом'
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
  }
}

// ==================== ВИДЖЕТЫ ДИАЛОГОВ ====================

class _BookingConfirmationSheet extends StatelessWidget {
  final DateTime selectedDate;
  final GuidesModel guide;
  final int depositAmount;
  final int remainingAmount;
  final double depositPercent;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _BookingConfirmationSheet({
    required this.selectedDate,
    required this.guide,
    required this.depositAmount,
    required this.remainingAmount,
    required this.depositPercent,
    required this.onConfirm,
    required this.onCancel,
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
          // Индикатор свайпа
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // Иконка
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_user,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: AppDimens.spaceM),

          Text(
            'Подтверждение брони',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: AppDimens.spaceS),

          // Дата
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spaceL,
              vertical: AppDimens.spaceS,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            child: Text(
              DateFormat('d MMMM yyyy', 'ru').format(selectedDate),
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // Детали оплаты
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                _buildPriceRow('Полная стоимость', '${guide.priceService} сом'),
                const SizedBox(height: AppDimens.spaceS),
                const Divider(color: Colors.white12),
                const SizedBox(height: AppDimens.spaceS),
                _buildPriceRow(
                  'Депозит (${depositPercent.toInt()}%)',
                  '$depositAmount сом',
                  isHighlighted: true,
                  color: Colors.amber.shade400,
                ),
                const SizedBox(height: AppDimens.spaceS),
                Container(
                  padding: const EdgeInsets.all(AppDimens.spaceS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppDimens.spaceS),
                      Expanded(
                        child: Text(
                          'Остаток $remainingAmount сом оплатите гиду на месте',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // Кнопки
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondaryDark,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                    ),
                  ),
                  child: const Text('Перейти к оплате'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceM),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value,
      {bool isHighlighted = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isHighlighted ? color : AppColors.textSecondaryDark,
            fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: isHighlighted ? color : AppColors.textPrimaryDark,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodsSheet extends StatelessWidget {
  final int depositAmount;
  final VoidCallback onQRPayment;
  final VoidCallback onMBankPayment;
  final VoidCallback onCardPayment;

  const _PaymentMethodsSheet({
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

class _QRCodeDialog extends StatelessWidget {
  final int depositAmount;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _QRCodeDialog({
    required this.depositAmount,
    required this.onCancel,
    required this.onConfirm,
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
            Text(
              'Оплата по QR-коду',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),

            // QR код
            Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(AppDimens.spaceM),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
              ),
              child: Image.network(
                'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=MBankPayment$depositAmount',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.qr_code_2,
                  size: 150,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceL),

            // Сумма
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceL,
                vertical: AppDimens.spaceS,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
              child: Text(
                '$depositAmount сом',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              'Отсканируйте QR-код в приложении банка',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceL),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondaryDark,
                      side: const BorderSide(color: Colors.white24),
                    ),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ),
                const SizedBox(width: AppDimens.spaceM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Оплачено'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardPaymentSheet extends StatefulWidget {
  final int depositAmount;
  final VoidCallback onPay;
  final VoidCallback onCancel;

  const _CardPaymentSheet({
    required this.depositAmount,
    required this.onPay,
    required this.onCancel,
  });

  @override
  State<_CardPaymentSheet> createState() => _CardPaymentSheetState();
}

class _CardPaymentSheetState extends State<_CardPaymentSheet> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusXL),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppDimens.spaceL,
        right: AppDimens.spaceL,
        top: AppDimens.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimens.spaceL,
      ),
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

          Text(
            'Оплата картой',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // Номер карты
          TextField(
            controller: _cardNumberController,
            style: const TextStyle(color: AppColors.textPrimaryDark),
            decoration: InputDecoration(
              labelText: 'Номер карты',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              hintText: '0000 0000 0000 0000',
              hintStyle: TextStyle(
                color: AppColors.textSecondaryDark.withOpacity(0.5),
              ),
              prefixIcon: const Icon(
                Icons.credit_card,
                color: AppColors.textSecondaryDark,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                borderSide: const BorderSide(color: Colors.white24),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusL),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              filled: true,
              fillColor: AppColors.bgDark,
            ),
            keyboardType: TextInputType.number,
            maxLength: 19,
          ),
          const SizedBox(height: AppDimens.spaceM),

          // Срок и CVV
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  style: const TextStyle(color: AppColors.textPrimaryDark),
                  decoration: InputDecoration(
                    labelText: 'MM/YY',
                    labelStyle:
                        const TextStyle(color: AppColors.textSecondaryDark),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.bgDark,
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  style: const TextStyle(color: AppColors.textPrimaryDark),
                  decoration: InputDecoration(
                    labelText: 'CVV',
                    labelStyle:
                        const TextStyle(color: AppColors.textSecondaryDark),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusL),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.bgDark,
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spaceL),

          // Сумма
          Container(
            padding: const EdgeInsets.all(AppDimens.spaceM),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'К оплате:',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                Text(
                  '${widget.depositAmount} сом',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spaceL),

          // Кнопки
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondaryDark,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
              ),
              const SizedBox(width: AppDimens.spaceM),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: widget.onPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 4,
                  ),
                  child: const Text('Оплатить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingDialog extends StatelessWidget {
  final String message;

  const _LoadingDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final DateTime selectedDay;
  final int depositAmount;
  final int remainingAmount;
  final GuidesModel guide;
  final VoidCallback onClose;
  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  const _SuccessDialog({
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
            // Анимированная иконка успеха
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

            // Детали брони
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

            // Контакты гида
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
