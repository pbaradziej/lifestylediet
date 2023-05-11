import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';
import 'package:lifestylediet/utils/theme.dart';

class DateTimeFieldComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool validationEnabled;
  final bool halfScreen;

  const DateTimeFieldComponent({
    required this.controller,
    this.label = '',
    this.hintText = 'Enter value...',
    this.validationEnabled = false,
    this.halfScreen = false,
  });

  @override
  _DateTimeFieldComponentState createState() => _DateTimeFieldComponentState();
}

class _DateTimeFieldComponentState extends State<DateTimeFieldComponent> {
  late DateTime selectedDate;

  String get label => widget.label;

  String get hintText => widget.hintText;

  bool get validationEnabled => widget.validationEnabled;

  TextEditingController get controller => widget.controller;

  bool get halfScreen => widget.halfScreen;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        dateTimeLabel(),
        dateTimeComponent(),
      ],
    );
  }

  Text dateTimeLabel() {
    return Text(
      label,
      style: labelStyle,
    );
  }

  FormField<String> dateTimeComponent() {
    return FormField<String>(
      enabled: validationEnabled,
      validator: validator,
      builder: builder,
    );
  }

  Widget builder(FormFieldState<String> state) {
    return Column(
      children: <Widget>[
        dateTimeField(state),
        if (state.errorText != null) errorText(state),
      ],
    );
  }

  String? validator(String? value) {
    if (controller.text.isEmpty) {
      return 'Please enter a date';
    } else {
      return null;
    }
  }

  Widget dateTimeField(FormFieldState<String> state) {
    return GestureDetector(
      onTap: () => selectDate(state),
      child: AbsorbPointer(
        child: Container(
          alignment: Alignment.centerLeft,
          height: 65,
          width: halfScreen ? 140 : 260,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: state.hasError ? errorColor : backgroundColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: dateTime(),
        ),
      ),
    );
  }

  Widget dateTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        textFormField(),
        dateIcon(),
      ],
    );
  }

  Widget textFormField() {
    return Flexible(
      flex: 7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          style: textStyle,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            hintText: hintText,
            hintStyle: hintStyle,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: backgroundColor,
          ),
        ),
      ),
    );
  }

  Widget dateIcon() {
    return Flexible(
      flex: 3,
      child: Icon(
        Icons.calendar_today,
        color: iconColors,
      ),
    );
  }

  Widget errorText(FormFieldState<String> state) {
    return Text(
      state.errorText ?? '',
      style: TextStyle(
        fontSize: 12,
        color: errorColor,
      ),
    );
  }

  void selectDate(FormFieldState<String> state) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2022),
      builder: datePickerBuilder,
    );

    if (pickedDateTime != null && pickedDateTime != selectedDate) {
      updateDateTime(state, pickedDateTime);
    }
  }

  Widget datePickerBuilder(BuildContext context, Widget? child) {
    return datePickerTheme(
      child ?? const SizedBox(),
    );
  }

  void updateDateTime(FormFieldState<String> state, DateTime pickedDateTime) {
    state.reset();
    selectedDate = pickedDateTime;
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final String strDate = dateFormat.format(selectedDate);
    controller.text = strDate;
    setState(() {});
  }
}
