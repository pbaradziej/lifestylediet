import 'package:flutter/material.dart';
import 'package:lifestylediet/utils/palette.dart';

class LogicComponent extends StatefulWidget {
  final String label;
  final bool validationEnabled;
  final TextEditingController controller;
  final Function()? navigate;

  const LogicComponent({
    required this.controller,
    this.label = '',
    this.validationEnabled = false,
    this.navigate,
  });

  @override
  _LogicComponentState createState() => _LogicComponentState();
}

class _LogicComponentState extends State<LogicComponent> {
  String get label => widget.label;

  bool get validationEnabled => widget.validationEnabled;

  TextEditingController get controller => widget.controller;

  void Function()? get navigate => widget.navigate;

  @override
  Widget build(BuildContext context) {
    return FormField<bool>(
      validator: validator,
      builder: builder,
    );
  }

  String? validator(bool? value) {
    if (controller.text != 'true' && validationEnabled) {
      return 'You need to accept terms';
    } else {
      return null;
    }
  }

  Widget builder(FormFieldState<bool> state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 0, 0, 0),
      child: Container(
        height: 20,
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            logicComponent(state),
            logicLabel(state),
          ],
        ),
      ),
    );
  }

  Widget logicComponent(FormFieldState<bool> state) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: state.hasError ? errorColor : defaultColor),
      child: Checkbox(
        value: controller.text == 'true',
        checkColor: Colors.green,
        activeColor: defaultColor,
        onChanged: (bool? value) {
          setState(() {
            state.reset();
            controller.text = value.toString();
          });
        },
      ),
    );
  }

  Widget logicLabel(FormFieldState<bool> state) {
    return GestureDetector(
      onTap: navigate,
      child: Text(
        state.errorText ?? label,
        style: TextStyle(
          color: state.hasError ? Theme.of(context).colorScheme.error : defaultColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
