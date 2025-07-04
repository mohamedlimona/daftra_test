extension MoneyExtension on num {
  String get asMoney => toStringAsFixed(2);
  double get asMoneyDouble => double.parse(toStringAsFixed(2));
}