import 'package:flutter/material.dart';

class RaisedButtonComponent extends StatefulWidget {
  final String label;
  final bool halfScreen;
  final Function onPressed;
  final bool circle;

  const RaisedButtonComponent({
    Key key,
    this.label = "",
    this.halfScreen = false,
    this.onPressed,
    this.circle = true,
  }) : super(key: key);

  @override
  _RaisedButtonComponentState createState() => _RaisedButtonComponentState();
}

class _RaisedButtonComponentState extends State<RaisedButtonComponent> {
  String _label;
  bool _halfScreen;
  Function _onPressed;
  bool _circle;

  void initComponents() {
    _label = widget.label;
    _onPressed = widget.onPressed;
    _halfScreen = widget.halfScreen;
    _circle = widget.circle;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: _halfScreen ? 80 : 20),
      width: double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_circle ? 30 : 5),
        ),
        color: Colors.white,
        onPressed: _onPressed,
        child: Text(
          _label,
          softWrap: true,
          style: TextStyle(color: _circle ? Colors.black45 : Colors.black87),
        ),
      ),
    );
  }
}
