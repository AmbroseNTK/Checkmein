import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String text;

  const DialogButton({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(text);
      },
    );
  }
}
