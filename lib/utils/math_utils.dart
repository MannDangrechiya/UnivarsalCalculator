import 'dart:math';

/// Utility class providing mathematical, scientific, and health-related formulas.
/// Every function is static and pure (no side effects).
class MathUtils {
  // ============================================================
  // 🔹 UNIT CONVERSIONS
  // ============================================================

  /// Convert between different length units.
  static double convertLength(double value, String from, String to) {
    const Map<String, double> lengthMap = {
      'Meter': 1,
      'Kilometer': 0.001,
      'Centimeter': 100,
      'Millimeter': 1000,
      'Mile': 0.000621371,
      'Yard': 1.09361,
      'Foot': 3.28084,
      'Inch': 39.3701,
    };
    if (!lengthMap.containsKey(from) || !lengthMap.containsKey(to)) return 0;
    return value * (lengthMap[to]! / lengthMap[from]!);
  }

  /// Convert between different weight/mass units.
  static double convertWeight(double value, String from, String to) {
    const Map<String, double> weightMap = {
      'Kilogram': 1,
      'Gram': 1000,
      'Milligram': 1e6,
      'Pound': 2.20462,
      'Ounce': 35.274,
    };
    if (!weightMap.containsKey(from) || !weightMap.containsKey(to)) return 0;
    return value * (weightMap[to]! / weightMap[from]!);
  }

  /// Convert between different volume units.
  static double convertVolume(double value, String from, String to) {
    const Map<String, double> volumeMap = {
      'Liter': 1,
      'Milliliter': 1000,
      'Gallon': 0.264172,
      'Quart': 1.05669,
      'Pint': 2.11338,
      'Cup': 4.22675,
    };
    if (!volumeMap.containsKey(from) || !volumeMap.containsKey(to)) return 0;
    return value * (volumeMap[to]! / volumeMap[from]!);
  }

  /// Convert between Celsius, Fahrenheit, and Kelvin.
  static double convertTemperature(double value, String from, String to) {
    if (from == to) return value;

    double celsius;
    switch (from) {
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    switch (to) {
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  // ============================================================
  // 🔹 SPEED / DISTANCE / TIME
  // ============================================================
  static double calculateSpeed(double distance, double time) =>
      time == 0 ? 0 : distance / time;
  static double calculateDistance(double speed, double time) => speed * time;
  static double calculateTime(double distance, double speed) =>
      speed == 0 ? 0 : distance / speed;

  // ============================================================
  // 🔹 DATE / AGE
  // ============================================================
  static int calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static int calculateDateDifference(DateTime start, DateTime end) =>
      end.difference(start).inDays.abs();

  // ============================================================
  // 🔹 TRIGONOMETRY
  // ============================================================
  static double sinDeg(double deg) => sin(deg * pi / 180);
  static double cosDeg(double deg) => cos(deg * pi / 180);
  static double tanDeg(double deg) => tan(deg * pi / 180);

  // ============================================================
  // 🔹 PHYSICS
  // ============================================================
  static double calculateForce(double mass, double acc) => mass * acc;
  static double calculateKineticEnergy(double mass, double velocity) =>
      0.5 * mass * pow(velocity, 2);
  static double calculatePower(double work, double time) =>
      time == 0 ? 0 : work / time;

  // ============================================================
  // 🔹 ELECTRICAL
  // ============================================================
  static double calculateResistance(double voltage, double current) =>
      current == 0 ? 0 : voltage / current;

  // ============================================================
  // 🔹 CHEMISTRY
  // ============================================================
  static double calculateMolarity(double moles, double volume) =>
      volume == 0 ? 0 : moles / volume;

  static double calculatePH(double hConcentration) =>
      (hConcentration <= 0) ? 0 : -log(hConcentration) / ln10;

  // ============================================================
  // 🔹 MISC / FINANCE
  // ============================================================
  static double calculateTip(double amount, double tipPercent) =>
      amount * tipPercent / 100;

  static double calculateDiscountGST(
    double price,
    double discount,
    double gst,
  ) {
    final discounted = price - (price * discount / 100);
    return discounted + (discounted * gst / 100);
  }

  static String getZodiacSign(DateTime birthDate) {
    final day = birthDate.day;
    final month = birthDate.month;
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "Aries";
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return "Taurus";
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return "Gemini";
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return "Cancer";
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return "Leo";
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return "Virgo";
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return "Libra";
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return "Scorpio";
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return "Sagittarius";
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return "Capricorn";
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return "Aquarius";
    }
    return "Pisces";
  }

  // ============================================================
  // 🔹 HEALTH CALCULATIONS
  // ============================================================
  static double calculateBMI(double weightKg, double heightCm) =>
      heightCm == 0 ? 0 : weightKg / pow(heightCm / 100, 2);

  static String bmiStatus(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  static double calculateBMR(
    double weightKg,
    double heightCm,
    int age,
    String gender,
  ) {
    final g = gender.toLowerCase();
    return g == "male"
        ? 88.36 + (13.4 * weightKg) + (4.8 * heightCm) - (5.7 * age)
        : 447.6 + (9.2 * weightKg) + (3.1 * heightCm) - (4.3 * age);
  }

  static double calculateBodyFat(double bmi, int age, String gender) {
    final g = gender.toLowerCase();
    return g == "male"
        ? (1.20 * bmi) + (0.23 * age) - 16.2
        : (1.20 * bmi) + (0.23 * age) - 5.4;
  }

  static double calculateIdealWeight(double heightCm, String gender) {
    final g = gender.toLowerCase();
    return g == "male"
        ? 50 + 0.9 * (heightCm - 152)
        : 45.5 + 0.9 * (heightCm - 152);
  }

  static double calculateDailyCalories(
    double bmr, {
    double multiplier = 1.375,
  }) => bmr * multiplier;

  static double calculateCaloriesBurned(
    double weightKg,
    double durationMin,
    double mets,
  ) => mets * 3.5 * weightKg / 200 * durationMin;

  static int calculateMaxHeartRate(int age) => 220 - age;

  static Map<String, int> calculateHeartRateZone(int age) {
    final max = calculateMaxHeartRate(age);
    return {"Min": (0.5 * max).round(), "Max": (0.85 * max).round()};
  }
}
