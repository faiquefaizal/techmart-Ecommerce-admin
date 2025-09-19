import 'package:flutter/material.dart';

custemAlertDialog(
  BuildContext context,
  VoidCallback? oPress,
  String title,
  String subTitle,
  String buttontext,
) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(subTitle),
          actions: [
            ElevatedButton(onPressed: oPress, child: Text(buttontext)),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context);
              },
              child: Text("No"),
            ),
          ],
        ),
  );
}
