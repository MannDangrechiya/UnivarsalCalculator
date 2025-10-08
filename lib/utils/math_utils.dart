import 'dart:math';

class MathUtils {
  // -------------------- Length --------------------
  static double convertLength(double value, String from, String to) {
    Map<String, double> lengthMap = {
      'Meter': 1,
      'Kilometer': 0.001,
      'Centimeter': 100,
      'Millimeter': 1000,
      'Mile': 0.000621371,
      'Yard': 1.09361,
      'Foot': 3.28084,
      'Inch': 39.3701,
    };
    return value * (lengthMap[to]! / lengthMap[from]!);
  }

  // -------------------- Weight --------------------
  static double convertWeight(double value, String from, String to) {
    Map<String, double> weightMap = {
      'Kilogram': 1,
      'Gram': 1000,
      'Milligram': 1e6,
      'Pound': 2.20462,
      'Ounce': 35.274,
    };
    return value * (weightMap[to]! / weightMap[from]!);
  }

  // -------------------- Volume --------------------
  static double convertVolume(double value, String from, String to) {
    Map<String, double> volumeMap = {
      'Liter': 1,
      'Milliliter': 1000,
      'Gallon': 0.264172,
      'Quart': 1.05669,
      'Pint': 2.11338,
      'Cup': 4.22675,
    };
    return value * (volumeMap[to]! / volumeMap[from]!);
  }

  // -------------------- Temperature --------------------
  static double convertTemperature(double value, String from, String to) {
    if (from == to) return value;
    double celsius = value;
    if (from == 'Fahrenheit') celsius = (value - 32) * 5 / 9;
    if (from == 'Kelvin') celsius = value - 273.15;

    if (to == 'Celsius') return celsius;
    if (to == 'Fahrenheit') return (celsius * 9 / 5) + 32;
    if (to == 'Kelvin') return celsius + 273.15;
    return value;
  }

  // -------------------- Speed / Distance / Time --------------------
  static double calculateSpeed(double distance, double time) => distance / time;
  static double calculateDistance(double speed, double time) => speed * time;
  static double calculateTime(double distance, double speed) =>
      distance / speed;

  // -------------------- Date / Age --------------------
  static int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Trigonometry
  static double sinDeg(double deg) => sin(deg * pi / 180);
  static double cosDeg(double deg) => cos(deg * pi / 180);
  static double tanDeg(double deg) => tan(deg * pi / 180);

  // Physics
  static double calculateForce(double mass, double acc) => mass * acc;
  static double calculateKineticEnergy(double mass, double velocity) =>
      0.5 * mass * pow(velocity, 2);
  static double calculatePower(double work, double time) => work / time;

  // Electrical
  static double calculateResistance(double voltage, double current) =>
      current == 0 ? 0 : voltage / current;

  // Chemistry
  static double calculateMolarity(double moles, double volume) =>
      volume == 0 ? 0 : moles / volume;
  static double calculatePH(double hConcentration) =>
      hConcentration <= 0 ? 0 : -log(hConcentration) / ln10;

  // fun calculation
  static double calculateTip(double amount, double tipPercent) {
    return amount * tipPercent / 100;
  }

  static double calculateDiscountGST(
    double price,
    double discount,
    double gst,
  ) {
    double discounted = price - (price * discount / 100);
    return discounted + (discounted * gst / 100);
  }

  static int calculateDateDifference(DateTime start, DateTime end) {
    return end.difference(start).inDays.abs();
  }

  static String getZodiacSign(DateTime birthDate) {
    int day = birthDate.day;
    int month = birthDate.month;
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
}
