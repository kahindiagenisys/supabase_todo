import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';

class AppDayBarWidget extends StatefulWidget {
  const AppDayBarWidget({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    this.backgroundColor,
    required this.selectedDay,
    required this.onSelectDay,
  });

  final String selectedDay;
  final Function(String day) onSelectDay;
  final EdgeInsets padding;
  final Color? backgroundColor;

  @override
  State<AppDayBarWidget> createState() => _AppDayBarWidgetState();
}

class _AppDayBarWidgetState extends State<AppDayBarWidget> {
  late int initialValueIndex;
  final daysList = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    initialValueIndex = daysList.indexOf(widget.selectedDay);
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme;
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color:
            (widget.backgroundColor ?? color.primary).withValues(alpha: 0.95),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildArrowLeftIconButton(color),
          _buildModeTitle(color),
          _buildArrowRightIconButton(color),
        ],
      ),
    );
  }

  _buildArrowLeftIconButton(ColorScheme color) {
    return IconButton(
      onPressed: _selectPreviousDay,
      icon: const Icon(Icons.keyboard_arrow_left),
      color: color.surface,
    );
  }

  _buildModeTitle(ColorScheme color) {
    return Text(
      daysList[initialValueIndex],
      style: TextStyle(fontWeight: FontWeight.bold,color: color.surface),
    );
  }

  _buildArrowRightIconButton(ColorScheme color) {
    return IconButton(
      onPressed: _selectNextDay,
      icon: const Icon(Icons.keyboard_arrow_right),
      color: color.surface,
    );
  }


  void _selectPreviousDay() {
    setState(() {
      initialValueIndex = (initialValueIndex - 1) % daysList.length;
      if (initialValueIndex < 0) {
        initialValueIndex = daysList.length - 1;
      }
      widget.onSelectDay(daysList[initialValueIndex]);
    });
  }

  void _selectNextDay() {
    setState(() {
      initialValueIndex = (initialValueIndex + 1) % daysList.length;
      widget.onSelectDay(daysList[initialValueIndex]);
    });
  }

}
