import 'dart:math';

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
  static String qrDataGenerator() {
    var characters =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    Random random = Random.secure();
    return String.fromCharCodes(Iterable.generate(
        10, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
  }
}
enum SCANING_STATE { SCANING, FAIL, SUCCESS,SUCCESS_EXISTS }
enum ENTER_EVENT_STATE {EXISTED,NEW,ERROR}

class AppRouting{
  static const menu = '/menu';
  static const event = '/event';
  static const eventInfo = '/event-info';
  static const login = '/login';
    static const scan = '/scan';
    static const checkin = '/checkin';

}