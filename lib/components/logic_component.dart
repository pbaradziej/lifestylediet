import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class LogicComponent extends StatefulWidget {
  final String label;
  final bool validationEnabled;
  final TextEditingController controller;
  final Function navigate;

  const LogicComponent({
    Key key,
    this.label = "",
    this.validationEnabled = false,
    this.controller,
    this.navigate,
  }) : super(key: key);

  @override
  _LogicComponentState createState() => _LogicComponentState();
}

class _LogicComponentState extends State<LogicComponent> {
  String _label;
  bool _validationEnabled;
  TextEditingController _controller;
  Function _navigate;

  void initComponents() {
    _label = widget.label;
    _validationEnabled = widget.validationEnabled;
    _controller = widget.controller;
    _navigate = widget.navigate;
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
                          state.hasError ? errorColor : defaultColor),
                  child: Checkbox(
                    value: _controller.text == 'true',
                    checkColor: Colors.green,
                    activeColor: defaultColor,
                    onChanged: (bool value) {
                      setState(() {
                        state.reset();
                        _controller.text = value.toString();
                      });
                    },
                  ),
                ),
                GestureDetector(
                  onTap: _navigate,
                  child: Text(
                    state.errorText ?? _label,
                    style: TextStyle(
                      color: state.hasError
                          ? Theme.of(context).errorColor
                          : defaultColor,
                      fontSize: 12,
                    ),
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
