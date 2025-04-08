import 'package:my_todo/resources/theme/app_theme.dart';
import 'package:nb_utils/nb_utils.dart';

void showSuccessToastMessage({required String message}) {
  toast(
    message,
    bgColor: greenColor.withValues(alpha: 0.5),
    length: Toast.LENGTH_LONG,
  );
}

void showErrorToastMessage({required String message}) {
  toast(
    message,
    bgColor: AppTheme.appFlexSchemeColor.data.dark.error,
    length: Toast.LENGTH_LONG,
  );
}
