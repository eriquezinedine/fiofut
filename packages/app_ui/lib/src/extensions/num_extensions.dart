import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

extension NumExtensions on num {
  // ============== Currency Formatting ==============
  String toCurrency({
    String symbol = '\$',
    int decimalDigits = 2,
    String locale = 'es_MX',
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(this);
  }

  String toCompactCurrency({
    String symbol = '\$',
    String locale = 'es_MX',
  }) {
    final formatter = NumberFormat.compactCurrency(
      locale: locale,
      symbol: symbol,
    );
    return formatter.format(this);
  }

  // ============== Number Formatting ==============
  String toCompact({String locale = 'es_MX'}) {
    final formatter = NumberFormat.compact(locale: locale);
    return formatter.format(this);
  }

  String toDecimal({
    int decimalDigits = 2,
    String locale = 'es_MX',
  }) {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: decimalDigits,
    );
    return formatter.format(this);
  }

  String toPercent({int decimalDigits = 0}) {
    return '${(this * 100).toStringAsFixed(decimalDigits)}%';
  }

  // ============== Spacing Helpers ==============
  Gap get gap => Gap(toDouble());
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get bottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get top => EdgeInsets.only(top: toDouble());
  EdgeInsets get left => EdgeInsets.only(left: toDouble());
  EdgeInsets get right => EdgeInsets.only(right: toDouble());

  // ============== Border Radius ==============
  BorderRadius get circularRadius => BorderRadius.circular(toDouble());
  Radius get radius => Radius.circular(toDouble());

  // ============== Duration ==============
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());
  Duration get days => Duration(days: toInt());

  // ============== Clamping ==============
  num clampMin(num min) => this < min ? min : this;
  num clampMax(num max) => this > max ? max : this;
}

extension IntExtensions on int {
  // ============== Ordinal ==============
  String get ordinal {
    if (this >= 11 && this <= 13) return '${this}th';
    switch (this % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }
}

extension DoubleExtensions on double {
  // ============== Precision ==============
  double toPrecision(int fractionDigits) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}
