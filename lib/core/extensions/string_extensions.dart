
import 'package:nb_utils/nb_utils.dart';

extension StringExtention on String? {
  bool get isValueEmptyOrNull {
    return (this == null || this == "null" || (this!.isEmpty));
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(r'^(?!^0+$)[a-zA-Z0-9]{8,12}$');
    return !isValueEmptyOrNull && passwordRegExp.hasMatch(this!);
  }

  bool get isDouble => double.tryParse(this ?? '') != null;

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return !isValueEmptyOrNull && emailRegExp.hasMatch(this!);
  }


  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^[6-9]\d{9}$");
    return !isValueEmptyOrNull && phoneRegExp.hasMatch(this!);
  }

  int? get isIntOrNull {
    if (this == null || this!.isEmpty) {
      return null;
    }
    return int.parse(this!);
  }

  double? get isDoubleOrNull {
    if (this == null || this!.trim().isEmpty) {
      return null;
    }
    return double.parse(this!);
  }

  double get isDoubleValue {
    if (this == null || this!.trim().isEmpty) {
      return 0.00;
    }
    return double.tryParse(this!) ?? 0.0;
  }

  double? get isDoubleOrNotNull {
    if (this?.trim() == null || this!.trim().isEmpty) {
      return 0.0;
    }
    return double.parse(this!);
  }

  String get capitalizeFirstInStringOrEmpty {
    if (isValueEmptyOrNull) return "";

    return this![0].toUpperCase() + this!.substring(1, this!.length);
  }

  bool get isDoctor {
    if (isValueEmptyOrNull) return false;

    return this!.toLowerCase() == "doctor";
  }

  String get isNotNull => (this == null) ? "" : this!;
  String? get isReturnNullOrValue => (this == "") ? null : this;
  String? get isNotEmptyAndNull => (this == "") ? null : this;


  String get toCurrencyAmount => "$defaultCurrencySymbol${validate()}";

}
