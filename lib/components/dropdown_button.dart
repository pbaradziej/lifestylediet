import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/common_utils.dart';

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
    Key key,
    this.controller,
    this.label = "",
    this.hintText = "Enter value...",
    this.borderSide = false,
    this.errorText,
    this.halfScreen = false,
    this.values,
    this.alertDialog = false,
  }) : super(key: key);

  @override
  _DropdownComponentState createState() => _DropdownComponentState();
}

class _DropdownComponentState extends State<DropdownComponent> {
  String _label;
  String _hintText;
  bool _borderSide;
  String _errorText;
  TextEditingController _controller;
  bool _halfScreen;
  List<String> _values;
  bool _alertDialog;

  void initComponents() {
    _label = widget.label;
    _hintText = widget.hintText;
    _borderSide = widget.borderSide;
    _errorText = widget.errorText;
    _controller = widget.controller;
    _halfScreen = widget.halfScreen;
    _values = widget.values;
    _alertDialog = widget.alertDialog;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      width: _halfScreen ? 140 : 260,
      height: _alertDialog ? 83 : 80,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _label,
            style: _alertDialog ? TextStyle(color: Colors.black) : labelStyle,
          ),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundColor,
                  errorText: _errorText,
                  errorStyle: errorStyle,
                  hintText: _hintText,
                  hintStyle: hintStyle,
                  border: new OutlineInputBorder(
                    borderSide: _borderSide
                        ? BorderSide(color: errorColor)
                        : BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10),
                    ),
                  ),
                ),
                isEmpty: _controller.text == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: iconColors,
                    ),
                    dropdownColor: backgroundColor,
                    value: _controller.text,
                    style: textStyle,
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        _controller.text = newValue;
                        state.didChange(newValue);
                      });
                    },
                    items: _values.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: textStyle),
                        );
                      },
                    ).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
