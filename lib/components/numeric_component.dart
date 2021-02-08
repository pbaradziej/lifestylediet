import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class NumericComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String initialValue;
  final bool borderSide;
  final String errorText;
  final bool halfScreen;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final String hintText;
  final String unit;
  final bool filled;
  final bool alertDialog;

  const NumericComponent({
    Key key,
    this.controller,
    this.label = "",
    this.borderSide = false,
    this.errorText,
    this.halfScreen = false,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
    this.initialValue = "",
    this.hintText = "Enter value...",
    this.unit = "",
    this.filled = true,
    this.alertDialog = false,
  }) : super(key: key);

  @override
  _NumericComponentState createState() => _NumericComponentState();
}

class _NumericComponentState extends State<NumericComponent> {
  String _label;
  bool _borderSide;
  String _errorText;
  TextEditingController _controller;
  bool _halfScreen;
  TextInputAction _action;
  Function _onEditingComplete;
  String _initialValue;
  String _hintText;
  String _unit;
  bool _filled;
  bool _alertDialog;

  void initComponents() {
    _label = widget.label;
    _borderSide = widget.borderSide;
    _errorText = widget.errorText;
    _controller = widget.controller;
    _halfScreen = widget.halfScreen;
    _action = widget.textInputAction;
    _onEditingComplete = widget.onEditingComplete;
    _initialValue = widget.initialValue;
    _hintText = widget.hintText;
    _unit = widget.unit;
    _filled = widget.filled;
    _alertDialog = widget.alertDialog;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      height: 95,
      width: _halfScreen ? 100 : 140,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _label,
            style: TextStyle(
              color: _filled
                  ? _alertDialog ? Colors.black : defaultColor
                  : Colors.black87,
            ),
          ),
          TextFormField(
            initialValue: _initialValue ?? '',
            textInputAction: _action,
            onEditingComplete: _onEditingComplete,
            style: TextStyle(
              color: defaultColor,
              fontSize: 20,
            ),
            validator: (value) {
              if (value.isEmpty) {
                _errorText = 'Please enter a number';
                return 'Please enter a number';
              }

              return null;
            },
            onChanged: (value) => setState(() {
              _errorText = null;
              value = value.replaceAll(',', '.');
              _controller.text = value;
            }),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(new RegExp('[0-9\,\.]')),
            ],
            decoration: new InputDecoration(
              suffixText: _unit,
              suffixStyle: hintStyle,
              contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 19),
              errorText: _errorText,
              errorStyle: TextStyle(fontSize: 12, height: 0.8),
              hintText: _hintText,
              hintStyle: hintStyle,
              errorBorder: new OutlineInputBorder(
                borderSide: BorderSide(color: errorColor),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              border: new OutlineInputBorder(
                borderSide: _borderSide
                    ? BorderSide(color: errorColor)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
