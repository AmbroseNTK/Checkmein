class Utils {
  static double valueBetween(double min, double max, double value) {
    if (value > max) {
      return max;
    }
    if (value < min) {
      return min;
    }
    return value;
  }
}
