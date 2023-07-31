import 'package:flutter/material.dart';

class tag extends StatelessWidget {
  const tag({Key? key, required this.title, this.onTap}) : super(key: key);

  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(
            255,
            title.codeUnitAt(0) * 5 + 6 * title.length,
            title.codeUnitAt(title.length - 1) * 5 + 2 * title.length,
            title.codeUnitAt(2) * 2 + 5 * title.length),
        onPressed: onTap,
        label: Text(title));
  }
}
