class UnitConversionService {
  double metersToKilometers(double m) => m / 1000;
  double kilometersToMeters(double km) => km * 1000;
  double gramsToKilograms(double g) => g / 1000;
  double kilogramsToGrams(double kg) => kg * 1000;
  double celsiusToFahrenheit(double c) => (c * 9 / 5) + 32;
  double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
  double usdToInr(double usd) => usd * 82.0;
  double inrToUsd(double inr) => inr / 82.0;
}
