import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/fonts.dart';
import 'package:lifestylediet/utils/palette.dart';

class TextFormFieldComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool borderSide;
  final String errorText;
  final bool halfScreen;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool enabled;
  final int minCharacters;
  final String minCharactersMessage;
  final bool searchField;
  final void Function()? onChangedParameter;

  const TextFormFieldComponent({
    required this.controller,
    this.label = '',
    this.hintText = 'Enter value...',
    this.borderSide = false,
    this.errorText = '',
    this.halfScreen = false,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
    this.minCharacters = 0,
    this.minCharactersMessage = '',
    this.searchField = false,
    this.onChangedParameter,
  });

  @override
  _TextFormFieldComponentState createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  late String? errorText;

  String get label => widget.label;

  String get hintText => widget.hintText;

  bool get borderSide => widget.borderSide;

  TextEditingController get controller => widget.controller;

  bool get halfScreen => widget.halfScreen;

  TextInputAction get action => widget.textInputAction;

  void Function(String)? get onFieldSubmitted => widget.onFieldSubmitted;

  void Function()? get onEditingComplete => widget.onEditingComplete;

  Widget? get prefixIcon => widget.prefixIcon;

  Widget? get suffixIcon => widget.suffixIcon;

  bool get obscureText => widget.obscureText;

  bool get enabled => widget.enabled;

  int get minCharacters => widget.minCharacters;

  String get minCharactersMessage => widget.minCharactersMessage;

  bool get searchField => widget.searchField;

  void Function()? get onChangedParameter => widget.onChangedParameter;

  @override
  void initState() {
    super.initState();
    errorText = widget.errorText;
  }

  @override
  Widget build(final BuildContext context) {
    return Container(
      height: searchField ? 84 : 90,
      width: width(),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(searchField ? 5.0 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (label.isNotEmpty) textLabel(),
          textFormField(),
        ],
      ),
    );
  }

  double width() {
    if (halfScreen) {
      return 140;
    }

    return searchField ? double.infinity : 260;
  }

  Widget textLabel() {
    return Text(
      label,
      style: labelStyle,
    );
  }

  Widget textFormField() {
    return TextFormField(
      enabled: enabled,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      onChanged: onChanged,
      textInputAction: action,
      onEditingComplete: onEditingComplete,
      style: searchField ? searchTextStyle : textStyle,
      validator: validator,
      decoration: inputDecoration(),
    );
  }

  void onChanged(final String _) {
    errorText = null;
    if(onChangedParameter != null) onChangedParameter!();
    setState(() {});
  }

  String? validator(final String? value) {
    final String parsedValue = value ?? '';
    if (parsedValue.isEmpty) {
      return errorText = 'Please enter some text';
    }

    if (parsedValue.length < minCharacters) {
      return errorText = minCharactersMessage;
    }

    return null;
  }

  InputDecoration inputDecoration() {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: searchField ? 21 : 22),
      errorText: errorText,
      errorStyle: errorStyle,
      hintText: hintText,
      hintStyle: searchField ? searchHintStyle : hintStyle,
      enabledBorder: enabledBorder(),
      errorBorder: errorBorder(),
      focusedBorder: focusedBorder(),
      border: border(),
      filled: true,
      fillColor: searchField ? searchLupe : backgroundColor,
    );
  }

  InputBorder enabledBorder() {
    return OutlineInputBorder(
      borderSide: searchField ? BorderSide(color: defaultBorderColor) : BorderSide.none,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
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

  InputBorder focusedBorder() {
    return OutlineInputBorder(
      borderSide: searchField ? const BorderSide(color: Colors.lightBlueAccent) : BorderSide.none,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }

  InputBorder border() {
    return OutlineInputBorder(
      borderSide: borderSide
          ? BorderSide(color: errorColor)
          : searchField
              ? BorderSide(color: defaultBorderColor)
              : BorderSide.none,
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
    );
  }
}
