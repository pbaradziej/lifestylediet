import 'package:flutter/material.dart';

class RaisedButtonComponent extends StatefulWidget {
  final String label;
  final bool halfScreen;
  final Function onPressed;

  const RaisedButtonComponent({
    Key key,
    this.label = "",
    this.halfScreen = false,
    this.onPressed,
  }) : super(key: key);

  @override
  _RaisedButtonComponentState createState() => _RaisedButtonComponentState();
}

class _RaisedButtonComponentState extends State<RaisedButtonComponent> {
  String _label;
  bool _halfScreen;
  Function _onPressed;

  void initComponents() {
    _label = widget.label;
    _onPressed = widget.onPressed;
    _halfScreen = widget.halfScreen;
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
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        onPressed: _onPressed,
        child: Text(
          _label,
          style: TextStyle(color: Colors.black45),
        ),
      ),
    );
  }
}
