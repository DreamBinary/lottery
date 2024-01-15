import 'dart:math';

class RandomUtil {
  static List<T> randomList<T>(List<T> list) {
    return list..shuffle();
  }

  static T randomOne<T>(List<T> list) {
    return list[randomInt(0, list.length)];
  }

  static int randomInt(int min, int max) {
    return min + Random().nextInt(max - min);
  }

  static double randomDouble(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  static bool randomBool() {
    return Random().nextBool();
  }

  static String randomString(int length) {
    var rand = Random();
    var codeUnits = List.generate(length, (index) {
      return rand.nextInt(33) + 89;
    });

    return String.fromCharCodes(codeUnits);
  }
}
