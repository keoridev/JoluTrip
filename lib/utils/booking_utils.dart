import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingUtils {
  Future<void> openWhatsApp(String phoneNumber, DateTime selectedDay) async {
    final String message = Uri.encodeComponent(
      'Здравствуйте! Я забронировал(а) тур с вами через Jolu Trip на ${DateFormat('d MMMM yyyy', 'ru').format(selectedDay)}. Хотел(а) бы обсудить детали.',
    );
    final Uri whatsappUri =
        Uri.parse('https://wa.me/996$phoneNumber?text=$message');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Не удалось открыть WhatsApp');
    }
  }
}
