import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class NumericComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String initialValue;
  final bool borderSide;
  final String errorText;
  final bool halfScreen;
  final TextInputAction textInputAction;
  final Function()? onEditingComplete;
  final String hintText;
  final String unit;
  final bool filled;
  final bool alertDialog;

  const NumericComponent({
    required this.controller,
    this.label = '',
    this.borderSide = false,
    this.errorText = '',
    this.halfScreen = false,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
    this.initialValue = '',
    this.hintText = 'Enter value...',
    this.unit = '',
    this.filled = true,
    this.alertDialog = false,
  });

  @override
  _NumericComponentState createState() => _NumericComponentState();
}

class _NumericComponentState extends State<NumericComponent> {
  late String? errorText;

  String get label => widget.label;

  bool get borderSide => widget.borderSide;

  TextEditingController get controller => widget.controller;

  bool get halfScreen => widget.halfScreen;

  TextInputAction get action => widget.textInputAction;

  Function()? get onEditingComplete => widget.onEditingComplete;

  String get initialValue => widget.initialValue;

  String get hintText => widget.hintText;

  String get unit => widget.unit;

  bool get filled => widget.filled;

  bool get alertDialog => widget.alertDialog;

  @override
  void initState() {
    super.initState();
    errorText = widget.errorText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: halfScreen ? 100 : 140,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          numericLabel(),
          numericComponent(),
        ],
      ),
    );
  }

  Widget numericLabel() {
    return Text(
      label,
      style: TextStyle(
        color: getColor(),
      ),
    );
  }

  Color getColor() {
    if (filled) {
      return alertDialog ? Colors.black : defaultColor;
    }

    return Colors.black87;
  }

  Widget numericComponent() {
    return TextFormField(
      initialValue: initialValue,
      textInputAction: action,
      onEditingComplete: onEditingComplete,
      style: TextStyle(
        color: defaultColor,
        fontSize: 20,
      ),
      validator: validator,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9\,\.]')),
      ],
      decoration: inputDecoration(),
    );
  }

  String? validator(String? value) {
    if (value?.isEmpty ?? false) {
      return errorText = 'Please enter a number';
    }

    return null;
  }

  void onChanged(String value) {
    errorText = null;
    value = value.replaceAll(',', '.');
    controller.text = value;
    setState(() {});
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      suffixText: unit,
      suffixStyle: hintStyle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 19),
      errorText: errorText,
      errorStyle: const TextStyle(fontSize: 12, height: 0.8),
      hintText: hintText,
      hintStyle: hintStyle,
      errorBorder: errorBorder(),
      border: border(),
      filled: true,
      fillColor: backgroundColor,
    );
  }

  InputBorder errorBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }

  InputBorder border() {
    return OutlineInputBorder(
      borderSide: borderSide ? BorderSide(color: errorColor) : BorderSide.none,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }
}
