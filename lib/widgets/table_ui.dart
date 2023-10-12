import 'package:flutter/material.dart';

class CustomTableUI {

  Widget headerTableCell({required text}) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
        ));
  }

  Widget bodyTableCell({required child}) {
    return TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: Padding(
          padding: const EdgeInsets.only(top: 7.0, bottom: 7.0),
          child: Center(
            child: child,
          ),
        ));
  }
}
