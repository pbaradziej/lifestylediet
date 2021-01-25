import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lifestylediet/utils/common_utils.dart';

class DateTimeFieldComponent extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool validationEnabled;
  final bool halfScreen;

  const DateTimeFieldComponent({
    Key key,
    this.controller,
    this.label = "",
    this.hintText = "Enter value...",
    this.validationEnabled = false,
    this.halfScreen = false,
  }) : super(key: key);

  @override
  _DateTimeFieldComponentState createState() => _DateTimeFieldComponentState();
}

class _DateTimeFieldComponentState extends State<DateTimeFieldComponent> {
  String _label;
  String _hintText;
  bool _validationEnabled;
  TextEditingController _controller;
  bool _halfScreen;
  DateTime selectedDate = DateTime.now();

  void initComponents() {
    _label = widget.label;
    _hintText = widget.hintText;
    _validationEnabled = widget.validationEnabled;
    _controller = widget.controller;
    _halfScreen = widget.halfScreen;
  }

  @override
  Widget build(BuildContext context) {
    initComponents();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_label, style: TextStyle(color: Colors.white)),
        FormField<String>(
          enabled: _validationEnabled,
          validator: (value) {
            if (_controller.text.isEmpty) {
              return 'Please enter a date';
            } else {
              return null;
            }
          },
          builder: (state) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () => _selectDate(context, state),
                  child: AbsorbPointer(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: 65,
                      width: _halfScreen ? 140 : 260,
                      decoration: new BoxDecoration(
                        color: appTextFieldsColor,
                        border: Border.all(
                          color:
                              state.hasError ? Colors.red : appTextFieldsColor,
                        ),
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _controller,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                                decoration: new InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10),
                                  hintText: _hintText,
                                  hintStyle: TextStyle(
                                      color: Colors.white60, fontSize: 15),
                                  border: new OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: appTextFieldsColor,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                state.errorText != null
                    ? Text(
                        state.errorText ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          //height: 0.3,
                          color: Colors.red,
                        ),
                      )
                    : Container(),
              ],
            );
          },
        ),
      ],
    );
  }

  _selectDate(BuildContext context, FormFieldState state) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime(2022),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.deepOrange,
            accentColor: Colors.orangeAccent,
            colorScheme: ColorScheme.light(primary: Colors.orange),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        state.reset();
        selectedDate = picked;
        DateFormat dateFormat = new DateFormat("yyyy-MM-dd");
        String strDate = dateFormat.format(selectedDate);
        _controller.text = strDate;
      });
  }
}
