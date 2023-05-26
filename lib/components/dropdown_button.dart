import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class DropdownComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool borderSide;
  final String errorText;
  final bool halfScreen;
  final List<String> values;
  final bool alertDialog;

  const DropdownComponent({
    required this.controller,
    required this.values,
    this.label = '',
    this.hintText = 'Enter value...',
    this.borderSide = false,
    this.errorText = '',
    this.halfScreen = false,
    this.alertDialog = false,
  });

  @override
  _DropdownComponentState createState() => _DropdownComponentState();
}

class _DropdownComponentState extends State<DropdownComponent> {
  String get label => widget.label;

  String get hintText => widget.hintText;

  bool get borderSide => widget.borderSide;

  String get errorText => widget.errorText;

  TextEditingController get controller => widget.controller;

  bool get halfScreen => widget.halfScreen;

  List<String> get values => widget.values;

  bool get alertDialog => widget.alertDialog;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: halfScreen ? 140 : 260,
      height: alertDialog ? 83 : 80,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dropdownLabel(),
          dropDown(),
        ],
      ),
    );
  }

  Widget dropdownLabel() {
    return Text(
      label,
      style: alertDialog ? const TextStyle(color: Colors.black) : labelStyle,
    );
  }

  Widget dropDown() {
    return FormField<String>(
      builder: builder,
    );
  }

  Widget builder(final FormFieldState<String> state) {
    return InputDecorator(
      decoration: inputDecoration(),
      isEmpty: controller.text == '',
      child: dropdownButton(state),
    );
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: backgroundColor,
      errorText: errorText,
      errorStyle: errorStyle,
      hintText: hintText,
      hintStyle: hintStyle,
      border: OutlineInputBorder(
        borderSide: borderSide ? BorderSide(color: errorColor) : BorderSide.none,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }

  Widget dropdownButton(final FormFieldState<String> state) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: icon(),
        dropdownColor: backgroundColor,
        value: controller.text,
        style: textStyle,
        isDense: true,
        onChanged: (final String? newValue) => onChanged(newValue, state),
        items: getItems(),
      ),
    );
  }

  Widget icon() {
    return Icon(
      Icons.arrow_drop_down,
      color: iconColors,
    );
  }

  void onChanged(final String? newValue, final FormFieldState<String> state) {
    setState(() {
      controller.text = newValue ?? '';
      state.didChange(newValue);
    });
  }

  List<DropdownMenuItem<String>> getItems() {
    return <DropdownMenuItem<String>>[
      for (String value in values) getDropdownMenuItem(value),
    ];
  }

  DropdownMenuItem<String> getDropdownMenuItem(final String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        style: textStyle,
      ),
    );
  }
}
