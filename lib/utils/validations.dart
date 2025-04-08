import 'package:my_todo/core/extensions/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

String? validateRequiredField(String fieldName, String? value) {
  if (value.isEmptyOrNull) {
    return "$fieldName is required.";
  }
  return null;
}

String? validateEmail(String? value) {
  final hasValid = validateRequiredField("Email", value);
  if (hasValid != null) return hasValid; // Return required field error if any

  if (value != null && !value.isValidEmail) {
    return "Invalid email address";
  }

  return null; // No errors
}

String? validatePassword(String? value) {
  final hasValid = validateRequiredField("Password", value);
  if (hasValid != null) return hasValid; // Return required field error if any

  if (value != null && !value.isValidPassword) {
    return "Invalid password";
  }

  return null; // No errors
}

String? validateConfirmPassword(
  String? value,
  String? originalPassword,
) {
  final hasValid = validateRequiredField(
    "Confirm password",
    value,
  );
  if (hasValid != null) return hasValid; // Return required field error if any

  final hasPassValid = validateRequiredField(
    "Password",
    originalPassword,
  );
  if (hasPassValid != null) {
    return hasPassValid; // Return required field error if any
  }

  if (value != originalPassword) {
    return "Passwords do not match.";
  }
  return null;
}

String? validatePhone(String? value) {
  final hasValid = validateRequiredField("Phone", value);
  if (hasValid != null) return hasValid; // Return required field error if any

  if (!value.isValidPhone) {
    return "Invalid phone number";
  }
  return null;
}

String? validateInteger(String? value) {
  if (value.isEmptyOrNull) {
    return "Value is required.";
  } else if (!value.isInt) {
    return "Invalid integer format.";
  }
  return null;
}

String? validateDouble(String? value) {
  if (value.isEmptyOrNull) {
    return "Value is required.";
  } else if (!value.isDouble) {
    return "Invalid number format.";
  }
  return null;
}
