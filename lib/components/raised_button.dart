import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/palette.dart';

class RaisedButtonComponent extends StatefulWidget {
  final String label;
  final bool halfScreen;
  final Function() onPressed;
  final bool circle;
  final bool alertDialog;

  const RaisedButtonComponent({
    required this.onPressed,
    this.label = '',
    this.halfScreen = false,
    this.alertDialog = false,
    this.circle = true,
  });

  @override
  _RaisedButtonComponentState createState() => _RaisedButtonComponentState();
}

class _RaisedButtonComponentState extends State<RaisedButtonComponent> {
  void Function() get onPressed => widget.onPressed;

  String get label => widget.label;

  bool get halfScreen => widget.halfScreen;

  bool get alertDialog => widget.alertDialog;

  bool get circle => widget.circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(horizontal: halfScreen ? 80 : 20),
      width: alertDialog ? 70 : double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          style: style(),
          onPressed: onPressed,
          child: buttonLabel(),
        ),
      ),
    );
  }

  ButtonStyle style() {
    return ElevatedButton.styleFrom(
      backgroundColor: defaultColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(circle ? 30 : 5),
      ),
    );
  }

  Widget buttonLabel() {
    return Text(
      label,
      softWrap: true,
      style: TextStyle(
        color: circle ? defaultBorderColor : Colors.black87,
      ),
    );
  }
}
