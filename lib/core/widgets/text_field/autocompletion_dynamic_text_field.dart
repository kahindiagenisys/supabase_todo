import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_todo/core/widgets/text_field/text_field_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class AutocompletionDynamicTextField<T extends Object> extends StatefulWidget {
  const AutocompletionDynamicTextField({
    this.optionsAlignment = Alignment.topLeft,
    this.addOptionButtonVisibility = true,
    this.isOnlyRead = false,
    this.addOptionButtonOnTapFunction,
    required this.findMatchingItems,
    required this.dynamicItems,
    this.submitFieldHandle,
    required this.child,
    this.onChange,
    this.labelText,
    this.validator,
    this.hintText,
    this.flexible,
    this.buildOptionsListFlexible,
    super.key,
    this.nextFocusNode,
    this.focusNode,
    this.controllerValue,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.outSidePadding,
  });

  final Function(T, {required TextEditingController controller})? submitFieldHandle;
  final List<T> Function(String value, List<T> items) findMatchingItems;
  final Function(String? value)? addOptionButtonOnTapFunction;
  final String? Function(String?)? validator;
  final AlignmentGeometry optionsAlignment;
  final Function(String value, {List<T>? items})? onChange;
  final bool addOptionButtonVisibility;
  final bool isOnlyRead;
  final Widget Function(T item) child;
  final List<T> dynamicItems;
  final String? labelText;
  final String? hintText;
  final FocusNode? nextFocusNode;
  final int? flexible;
  final int? buildOptionsListFlexible;
  final FocusNode? focusNode;
  final String? controllerValue;
  final OptionsViewOpenDirection? optionsViewOpenDirection;
  final double? outSidePadding;

  @override
  State<AutocompletionDynamicTextField<T>> createState() =>
      _AutocompletionDynamicTextFieldState<T>();
}

class _AutocompletionDynamicTextFieldState<T extends Object>
    extends State<AutocompletionDynamicTextField<T>> {
  final autoCompletionGlobalKey = GlobalKey();

  T? filterOption;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (!widget.controllerValue.isEmptyOrNull) {
      controller.text = widget.controllerValue!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AutocompletionDynamicTextField<T> oldWidget) {
    if (widget.dynamicItems.length > oldWidget.dynamicItems.length) {
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          if (!controller.text.isEmptyOrNull) {
            String a = controller.text;
            controller.text = a.substring(0, a.length - 1);
            controller.text = a;
          }
        },
      );
    }

    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (widget.controllerValue.isEmptyOrNull &&
            !controller.text.isEmptyOrNull) {
          controller.text = widget.controllerValue ?? '';
        }
      },
    );

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.flexible == null) return _buildAutoCompleteTextField();

    return Flexible(
      flex: widget.flexible!,
      child: _buildAutoCompleteTextField(),
    );
  }

  Widget _buildAutoCompleteTextField() {
    return Autocomplete(
      key: autoCompletionGlobalKey,
      initialValue: controller.value,
      optionsBuilder: optionsBuilder,
      optionsViewOpenDirection: widget.optionsViewOpenDirection!,
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        controller = textEditingController;
        if (widget.focusNode?.hasFocus ?? false) focusNode.requestFocus();
        return TextFieldWidget(
          isOnlyRead:widget.isOnlyRead ,
          outSidePadding: widget.outSidePadding ?? 8,
          onChange: (value) =>
              widget.onChange?.call(value, items: widget.dynamicItems),
          controller: controller,
          onFieldSubmitted: submitFieldHandle,
          labelText: widget.labelText,
          validator: widget.validator,
          hintText: widget.hintText,
          focusNode: focusNode,
          nextFocusNode: widget.nextFocusNode,
        );
      },
      onSelected: (option) => widget.submitFieldHandle?.call(option, controller: controller),
      optionsViewBuilder: (context, onSelected, options) {
        double optionsLength = options.toList().length.toDouble();
        RenderBox renderBox = (autoCompletionGlobalKey.currentContext?.findRenderObject() as RenderBox);
        return Align(
          alignment:
              widget.optionsViewOpenDirection == OptionsViewOpenDirection.up
                  ? Alignment.bottomLeft
                  : widget.optionsAlignment,
          child: Card(
            elevation: 5,
            child: SizedBox(
              height: 40 * _calculateHeight(optionsLength),
              width: renderBox.size.width,
              child: _buildOptionsList(context, onSelected, options),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionsList(
    BuildContext context,
    AutocompleteOnSelected<T> onSelected,
    Iterable<T> options,
  ) {
    final List<T> optionsList = options.toList();
    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      itemCount:
          optionsList.length + (widget.addOptionButtonVisibility ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        final bool highlight =
            AutocompleteHighlightedOption.of(context) == index;

        if (highlight) {
          filterOption = optionsList[index];
        }

        if (widget.addOptionButtonVisibility &&
            (options.isEmpty || index == options.length)) {
          return GestureDetector(
            onTap: () =>
                widget.addOptionButtonOnTapFunction?.call(controller.text),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 40,
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add New',
                  style: secondaryTextStyle(),
                ),
              ),
            ),
          );
        }
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            onSelected(optionsList[index]);
          },
          child: Container(
            height: 43,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: highlight ? Theme.of(context).focusColor : Colors.transparent,
            child: widget.child(optionsList[index]),
          ),
        );
      },
    );
  }

  List<T> optionsBuilder(TextEditingValue textEditingValue) {
    if (textEditingValue.text.isEmptyOrNull) return [];

    List<T> filterList =
        widget.findMatchingItems(controller.text, widget.dynamicItems);
    if (filterList.isEmpty) {
      /// selected option clear
      // filterOption = null;
      // TODO:: default data add
    }
    return filterList;
  }

  void submitFieldHandle(String value) {
    if (filterOption != null) {
      widget.submitFieldHandle?.call(filterOption!, controller: controller);
    }
  }

  double _calculateHeight(double optionsLength) {
    final effectiveOptionsLength = optionsLength > 4
        ? 4
        : widget.addOptionButtonVisibility
            ? optionsLength + 1.09
            : (optionsLength + 0.09);
    return effectiveOptionsLength.toDouble();
  }
}
