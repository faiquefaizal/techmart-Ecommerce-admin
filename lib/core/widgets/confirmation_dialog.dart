import 'package:flutter/material.dart';

custemAlertDialog(BuildContext context, VoidCallback? oPress) {
  return showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text("Delete It"),
          content: Text("Are you sure you want to delete It"),
          actions: [
            ElevatedButton(onPressed: oPress, child: Text("Delete it")),
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
