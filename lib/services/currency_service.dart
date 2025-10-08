import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  /// Convert [amount] from [from] currency to [to] currency using exchangerate.host API
  Future<double> convertCurrency(String from, String to, double amount) async {
    final url = Uri.parse(
      'https://api.exchangerate.host/convert?from=$from&to=$to&amount=$amount',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return (data['result'] as num).toDouble();
      } else {
        throw Exception('Conversion failed');
      }
    } else {
      throw Exception('Failed to fetch currency data');
    }
  }
}
