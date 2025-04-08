import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

extension DoubleExtensions on double? {
  String get isStringOrEmpty {
    if (this == null || this! <= 0) return "";

    return toString();
  }

  String get formatDoubleNumber {
    if (this == null) return "0.00";
    return this! > 9999
        ? NumberFormat.compact().format(this)
        : this!.toStringAsFixed(2);
  }

  String get formatCurrency {
    final format = (this ?? 0) % 1 == 0 ? "#,##0" : "#,##0.00";
    return NumberFormat(format, 'en_US').format(this);
  }

  String toStringOmitDecimal() {
    final format =
        (this ?? 0) % 1 == 0 ? "0" : "0.###"; // almost 3 decimal places
    return NumberFormat(format).format(this);
  }

  String get formatToDecimalWhenNeeded {
    // Format to 2 decimal places
    String formatted = (this ?? 0).toStringAsFixed(2);

    // RegExp to remove trailing zeros and the decimal point if not needed
    RegExp regExp = RegExp(r"([.]*0+)(?!.*\d)");
    return formatted.replaceAll(regExp, '');
  }

  String get formatToDecimalWhenNeededOrEmpty {
    // Format to 2 decimal places
    if (this == null || 0 >= this!) return '';
    String formatted = this!.toStringAsFixed(2);

    // RegExp to remove trailing zeros and the decimal point if not needed
    RegExp regExp = RegExp(r"([.]*0+)(?!.*\d)");
    return formatted.replaceAll(regExp, '');
  }

  double get formatToDecimalWhenNeededAndDouble {
    // Format to 2 decimal places
    String formatted = (this ?? 0).toStringAsFixed(2);

    // RegExp to remove trailing zeros and the decimal point if not needed
    RegExp regExp = RegExp(r"([.]*0+)(?!.*\d)");
    return double.parse(formatted.replaceAll(regExp, ''));
  }

  String get toCurrencyAmountOrString =>
      "$defaultCurrencySymbol ${formatToDecimalWhenNeeded.validate()}";
}
