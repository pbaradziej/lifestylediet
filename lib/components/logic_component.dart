import 'package:flutter/material.dart';

class LogicComponent extends StatefulWidget {
  final String label;
  final bool validationEnabled;
  final TextEditingController controller;

  const LogicComponent({
    Key key,
    this.label = "",
    this.validationEnabled = false,
    this.controller,
  }) : super(key: key);

  @override
  _LogicComponentState createState() => _LogicComponentState();
}

class _LogicComponentState extends State<LogicComponent> {
  String _label;
  bool _validationEnabled;
  TextEditingController _controller;

  void initComponents() {
    _label = widget.label;
    _validationEnabled = widget.validationEnabled;
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return FormField<bool>(
      validator: (value) {
        if (_controller.text != 'true' && _validationEnabled) {
          return 'You need to accept terms';
        } else {
          return null;
        }
      },
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
          child: Container(
            height: 20,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Theme(
                  data: ThemeData(
                      unselectedWidgetColor:
                          state.hasError ? Colors.red : Colors.white),
                  child: Checkbox(
                    value: _controller.text == 'true',
                    checkColor: Colors.green,
                    activeColor: Colors.white,
                    onChanged: (bool value) {
                      setState(() {
                        state.reset();
                        _controller.text = value.toString();
                      });
                    },
                  ),
                ),
                Text(
                  state.errorText ?? _label,
                  style: TextStyle(
                    color: state.hasError
                        ? Theme.of(context).errorColor
                        : Colors.white,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
