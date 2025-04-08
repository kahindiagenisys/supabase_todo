import 'package:flutter/material.dart';
import 'package:my_todo/core/extensions/build_context_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

class AppButtonWidget extends StatefulWidget {
  const AppButtonWidget({
    this.childAlignment = Alignment.center,
    this.backgroundColor,
    this.showBackground = true,
    this.enableScaleAnimation,
    this.borderRadius = 8,
    this.enabled = true,
    this.height = 50,
    this.textStyle,
    this.textColor,
    this.padding,
    this.margin,
    this.onTap,
    this.child,
    this.text,
    super.key,
    this.width,
    this.isLoading = false,
    this.border,
  });

  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry childAlignment;
  final bool? enableScaleAnimation;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final bool showBackground;
  final double borderRadius;
  final Function()? onTap;
  final Color? textColor;
  final Widget? child;
  final double height;
  final double? width;
  final BoxBorder? border;
  final bool enabled;
  final bool isLoading;
  final String? text;

  @override
  State<AppButtonWidget> createState() => _AppButtonWidgetState();
}

class _AppButtonWidgetState extends State<AppButtonWidget>
    with SingleTickerProviderStateMixin {
  double scale = 1.0;
  AnimationController? _controller;

  late Color textColor;

  @override
  void initState() {
    super.initState();
    if (widget.enableScaleAnimation == true) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: appButtonScaleAnimationDurationGlobal ?? 50,
        ),
        lowerBound: 0.0,
        upperBound: 0.1,
      )..addListener(() {
          setState(() {
            scale = 1 - _controller!.value;
          });
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? context.colorScheme.primary;
    textColor = widget.textColor ??
        (widget.showBackground
            ? context.colorScheme.onPrimary
            : context.colorScheme.primary);

    final bool isOnTapAvailable = widget.enabled && !widget.isLoading;

    // Using GestureDetector and Listener only if scaling animation is enabled
    return Padding(
      padding: widget.margin ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: GestureDetector(
        onTap: isOnTapAvailable ? widget.onTap : null,
        child: Container(
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.showBackground ? backgroundColor : null,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.border,
          ),
          child: Align(
            alignment: widget.childAlignment,
            child: Padding(
              padding: buttonPadding(),
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeAlign: -3,
                    )
                  : widget.child ??
                      Text(
                        widget.text.validate(),
                        style:
                            widget.textStyle ?? boldTextStyle(color: textColor),
                      ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry buttonPadding() {
    return widget.padding ??
        const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  }
}
