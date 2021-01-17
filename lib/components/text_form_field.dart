import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/theme.dart';

class TextFormFieldComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool borderSide;
  final String errorText;
  final bool halfScreen;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final Function onEditingComplete;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final bool obscureText;
  final bool enabled;

  const TextFormFieldComponent({
    Key key,
    this.controller,
    this.label = "",
    this.hintText = "Enter value...",
    this.borderSide = false,
    this.errorText,
    this.halfScreen = false,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  _TextFormFieldComponentState createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  String _label;
  String _hintText;
  bool _borderSide;
  String _errorText;
  TextEditingController _controller;
  bool _halfScreen;
  TextInputAction _action;
  Function(String) _onFieldSubmitted;
  Function _onEditingComplete;
  Widget _prefixIcon;
  Widget _suffixIcon;
  bool _obscureText;
  bool _enabled;

  void initComponents() {
    _label = widget.label;
    _hintText = widget.hintText;
    _borderSide = widget.borderSide;
    _errorText = widget.errorText;
    _controller = widget.controller;
    _halfScreen = widget.halfScreen;
    _action = widget.textInputAction;
    _onFieldSubmitted = widget.onFieldSubmitted;
    _onEditingComplete = widget.onEditingComplete;
    _prefixIcon = widget.prefixIcon;
    _suffixIcon = widget.suffixIcon;
    _obscureText = widget.obscureText;
    _enabled = widget.enabled;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      height: 90,
      width: _halfScreen ? 140 : 260,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_label, style: TextStyle(color: Colors.white)),
          TextFormField(
            enabled: _enabled,
            obscureText: _obscureText,
            onFieldSubmitted: _onFieldSubmitted,
            controller: _controller,
            textInputAction: _action,
            onEditingComplete: _onEditingComplete,
            style: TextStyle(color: Colors.white, fontSize: 15),
            decoration: new InputDecoration(
              prefixIcon: _prefixIcon,
              suffixIcon: _suffixIcon,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15, vertical: 22),
              errorText: _errorText,
              errorStyle: TextStyle(fontSize: 12, height: 0.3),
              hintText: _hintText,
              hintStyle: TextStyle(color: Colors.white60, fontSize: 15),
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
