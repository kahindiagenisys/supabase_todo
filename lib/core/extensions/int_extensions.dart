import 'package:intl/intl.dart';

extension IntExtention on int? {
  String get isStringOrEmpty {
    if (this == null) return "";

    return toString();
  }

  String get formatIntNumber {
    if (this == null) return "0";
    return this! > 9999 ? NumberFormat.compact().format(this) : toString();
  }
}
