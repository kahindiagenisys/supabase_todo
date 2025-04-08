import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:my_todo/core/widgets/buttons/app_button_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class NavigationItem extends Widget {
  const NavigationItem({super.key});

  @override
  Element createElement() {
    return Container().createElement();
  }
}

// Bottom Navigation Item Widget
class BottomNavigationItem extends StatelessWidget {
  final IconData iconData;
  final String name;
  final int index;

  const BottomNavigationItem({
    super.key,
    required this.iconData,
    required this.name,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return commonActiveBottomNavigationIcon(
      context: context,
      name: name,
      iconData: iconData,
      isActive: true, // Assume active for this example
    );
  }
}

// SizedBox Item Widget
class SizedBoxItem extends StatelessWidget {
  final double width;
  final List<Widget> children;

  const SizedBoxItem({
    super.key,
    required this.width,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: children,
      ),
    );
  }
}

// Common Active Bottom Navigation Icon Widget
Widget commonActiveBottomNavigationIcon({
  required BuildContext context,
  required String name,
  required IconData? iconData,
  Function()? onTap,
  bool isActive = false,
}) {
  final color = context.colorScheme;

  return AppButtonWidget(
    onTap: onTap,
    showBackground: false,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          color: isActive ? color.primary : Colors.grey,
        ),
        2.height,
        Flexible(
          fit: FlexFit.tight,
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelSmall?.copyWith(
              color: isActive ? color.primary : Colors.grey,
            ),
          ),
        ),
      ],
    ),
  );
}
