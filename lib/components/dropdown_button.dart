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

  const DropdownComponent({
    Key key,
    this.controller,
    this.label = "",
    this.hintText = "Enter value...",
    this.borderSide = false,
    this.errorText,
    this.halfScreen = false,
    this.values,
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

  void initComponents() {
    _label = widget.label;
    _hintText = widget.hintText;
    _borderSide = widget.borderSide;
    _errorText = widget.errorText;
    _controller = widget.controller;
    _halfScreen = widget.halfScreen;
    _values = widget.values;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      width: _halfScreen ? 140 : 260,
      height: 80,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_label, style: TextStyle(color: Colors.white)),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: appTextFieldsColor,
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
                ),
                isEmpty: _controller.text == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey[200],
                    ),
                    dropdownColor: Colors.orangeAccent,
                    value: _controller.text,
                    style: TextStyle(color: Colors.white, fontSize: 15),
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
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
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
