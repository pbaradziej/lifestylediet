import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lifestylediet/utils/theme.dart';

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

  const NumericComponent({
    Key key,
    this.controller,
    this.label = "",
    this.borderSide = false,
    this.errorText = "",
    this.halfScreen = false,
    this.textInputAction = TextInputAction.next,
    this.onEditingComplete,
    this.initialValue = "1",
    this.hintText = "Enter value...",
    this.unit = "",
    this.filled = true,
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
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      height: 90,
      width: _halfScreen ? 100 : 140,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _label,
            style: TextStyle(
              color: _filled ? Colors.white : Colors.black87,
            ),
          ),
          TextFormField(
            initialValue: _initialValue,
            //controller: _controller,
            textInputAction: _action,
            onEditingComplete: _onEditingComplete,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            onChanged: (value) => setState(() {
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
              suffixStyle: TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 7, vertical: 19),
              errorText: _errorText,
              errorStyle: TextStyle(fontSize: 12, height: 0.3),
              hintText: _hintText,
              hintStyle: TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
              border: new OutlineInputBorder(
                borderSide: _borderSide
                    ? BorderSide(color: Colors.red)
                    : BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: appTextFieldsColor,
            ),
          ),
        ],
      ),
    );
  }
}
