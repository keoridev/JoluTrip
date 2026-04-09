import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  Future<void> openMBank() async {
    final Uri mbankUri = Uri.parse('mbank://payment');
    final Uri fallbackUri = Uri.parse('https://m-bank.kg');

    try {
      if (await canLaunchUrl(mbankUri)) {
        await launchUrl(mbankUri, mode: LaunchMode.externalApplication);
        return;
      } else {
        await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
        throw Exception('MBank не установлен');
      }
    } catch (e) {
      throw Exception('Не удалось открыть MBank');
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:+996$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw Exception('Не удалось открыть телефон');
    }
  }
}
