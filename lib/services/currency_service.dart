import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey =
      '53c73e2c4c200ca6ef4ea036'; // 🔑 replace with your valid key
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';

  /// Fetch list of all supported currency codes and names
  Future<Map<String, String>> getAvailableCurrencies() async {
    final url = Uri.parse('$_baseUrl/$_apiKey/codes');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Network error: Failed to fetch currency list');
    }

    final data = jsonDecode(response.body);
    if (data['result'] != 'success') {
      throw Exception('Invalid API response');
    }

    final Map<String, String> symbols = {};
    for (var code in data['supported_codes']) {
      symbols[code[0]] = code[1];
    }
    return symbols;
  }

  /// Convert from one currency to another
  Future<Map<String, dynamic>> convertCurrency(
    String from,
    String to,
    double amount,
  ) async {
    final url = Uri.parse('$_baseUrl/$_apiKey/latest/$from');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Network error: Unable to fetch rates');
    }

    final data = jsonDecode(response.body);
    if (data['result'] != 'success' || data['conversion_rates'] == null) {
      throw Exception('Invalid response from API');
    }

    final rates = data['conversion_rates'] as Map<String, dynamic>;
    final rate = rates[to];
    if (rate == null) throw Exception('Currency not supported');

    return {'converted': amount * (rate as num), 'rate': rate};
  }
}
//   static const String _apiKey = '53c73e2c4c200ca6ef4ea036'; 