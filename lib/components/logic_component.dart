import 'package:flutter/material.dart';

class LogicComponent extends StatefulWidget {
  final String label;
  final bool submitted;
  final TextEditingController controller;

  const LogicComponent({
    Key key,
    this.label = "",
    this.submitted = false,
    this.controller,
  }) : super(key: key);

  @override
  _LogicComponentState createState() => _LogicComponentState();
}

class _LogicComponentState extends State<LogicComponent> {
  String _label;
  bool _submitted;
  TextEditingController _controller;

  void initComponents() {
    _label = widget.label;
    _submitted = widget.submitted;
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
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
                      _submitted ? Colors.red : Colors.white),
              child: Checkbox(
                value: _controller.text == 'true',
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    _controller.text = value.toString();
                  });
                },
              ),
            ),
            Text(
              _label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
