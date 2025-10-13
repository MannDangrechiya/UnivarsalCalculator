import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _baseUrl = 'https://api.exchangerate.host';
  final Map<String, double> _cachedRates = {};
  DateTime? _lastFetched;

  /// Convert currency from one to another
  Future<double> convertCurrency(String from, String to, double amount) async {
    try {
      final cacheKey = '$from-$to';
      if (_cachedRates.containsKey(cacheKey) && isCacheValid) {
        return amount * _cachedRates[cacheKey]!;
      }

      final url = Uri.parse(
        '$_baseUrl/convert?from=$from&to=$to&amount=$amount',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['result'] != null) {
          final result = (data['result'] as num).toDouble();
          _cachedRates[cacheKey] = result / amount;
          _lastFetched = DateTime.now();
          return result;
        }
      }

      // fallback
      if (_cachedRates.containsKey(cacheKey)) {
        return amount * _cachedRates[cacheKey]!;
      }

      throw Exception('Currency conversion failed');
    } on TimeoutException {
      if (_cachedRates.containsKey('$from-$to')) {
        return amount * _cachedRates['$from-$to']!;
      }
      throw Exception('Request timed out');
    } catch (e) {
      rethrow;
    }
  }

  /// Load all available currencies
  Future<Map<String, String>> getAvailableCurrencies() async {
    final url = Uri.parse('$_baseUrl/symbols');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['symbols'] != null) {
        final symbols = Map<String, dynamic>.from(data['symbols']);
        return symbols.map((key, value) => MapEntry(key, value['description']));
      }
    }

    throw Exception('Failed to load currency list');
  }

  /// Check if cache is valid for 60 minutes
  bool get isCacheValid {
    if (_lastFetched == null) return false;
    return DateTime.now().difference(_lastFetched!).inMinutes < 60;
  }
}
