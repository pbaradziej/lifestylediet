import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/common_utils.dart';

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
  final int minCharacters;
  final String minCharactersMessage;
  final bool searchField;

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
    this.minCharacters = 0,
    this.minCharactersMessage = "",
    this.searchField = false,
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
  int _minCharacters;
  String _minCharactersMessage;
  bool _searchField;

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
    _minCharacters = widget.minCharacters;
    _minCharactersMessage = widget.minCharactersMessage;
    _searchField = widget.searchField;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      height: _searchField ? 72 : 90,
      width: _halfScreen ? 140 : _searchField ? double.infinity : 260,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(_searchField ? 5.0 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label != "" ? Text(_label, style: labelStyle) : SizedBox(height: 0),
          TextFormField(
            enabled: _enabled,
            obscureText: _obscureText,
            onFieldSubmitted: _onFieldSubmitted,
            controller: _controller,
            onChanged: (_) {
              _errorText = null;
              setState(() {});
            },
            textInputAction: _action,
            onEditingComplete: _onEditingComplete,
            style: _searchField ? searchTextStyle : textStyle,
            validator: (value) {
              if (value.isEmpty) {
                _errorText = 'Please enter some text';
                return 'Please enter some text';
              }

              if (value.length < _minCharacters) {
                _errorText = _minCharactersMessage;
                return _minCharactersMessage;
              }

              return null;
            },
            decoration: new InputDecoration(
              prefixIcon: _prefixIcon,
              suffixIcon: _suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 15, vertical: _searchField ? 21 : 22),
              errorText: _errorText,
              errorStyle: errorStyle,
              hintText: _hintText,
              hintStyle: _searchField ? searchHintStyle : hintStyle,
              enabledBorder: new OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              errorBorder: new OutlineInputBorder(
                borderSide: BorderSide(color: errorColor),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              focusedBorder: new OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              border: new OutlineInputBorder(
                borderSide: _borderSide
                    ? BorderSide(color: errorColor)
                    : _searchField
                        ? BorderSide(color: defaultBorderColor)
                        : BorderSide.none,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: _searchField ? searchLupe : backgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}
