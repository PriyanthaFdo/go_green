import 'dart:math';

double randomBetween(double value1, double value2) {
  late final double min;
  late final double max;

  if (value1 > value2) {
    max = value1;
    min = value2;
  } else {
    max = value2;
    min = value1;
  }

  final random = Random();
  final value = (random.nextDouble() * (max - min)) + min;
  return value;
}
