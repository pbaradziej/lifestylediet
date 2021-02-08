import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class RaisedButtonComponent extends StatefulWidget {
  final String label;
  final bool halfScreen;
  final Function onPressed;
  final bool circle;
  final bool alertDialog;

  const RaisedButtonComponent({
    Key key,
    this.label = "",
    this.halfScreen = false,
    this.alertDialog = false,
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
  bool _alertDialog;

  void initComponents() {
    _label = widget.label;
    _onPressed = widget.onPressed;
    _halfScreen = widget.halfScreen;
    _circle = widget.circle;
    _alertDialog = widget.alertDialog;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: _halfScreen ? 80 : 20),
      width: _alertDialog ? 70 : double.infinity,
      child: RaisedButton(
        padding: EdgeInsets.all(15),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_circle ? 30 : 5),
        ),
        color: defaultColor,
        onPressed: _onPressed,
        child: Text(
          _label,
          softWrap: true,
          style:
              TextStyle(color: _circle ? defaultBorderColor : Colors.black87),
        ),
      ),
    );
  }
}
