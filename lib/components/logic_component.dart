import 'package:flutter/material.dart';

class LogicComponent extends StatefulWidget {
  final String label;
  final bool value;
  final bool submitted;


  const LogicComponent({
    Key key,
    this.label = "",
    this.value = false,
    this.submitted = false,
  }) : super(key: key);

  @override
  _LogicComponentState createState() => _LogicComponentState();
}

class _LogicComponentState extends State<LogicComponent> {
  String _label;
  bool _value;
  bool _submitted;

  void initComponents() {
    _label = widget.label;
    _value = widget.value;
    _submitted = widget.submitted;
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
                unselectedWidgetColor: _submitted ? Colors.red : Colors.white),
              child: Checkbox(
                value: _value,
                checkColor: Colors.green,
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    _value = value;
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
