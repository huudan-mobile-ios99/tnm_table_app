import 'package:flutter/material.dart';

Widget itemListRT({width, child}) {
  return Container(
    // padding: EdgeInsets.all(0.0),
    alignment: Alignment.centerLeft,
    width: width / 11,
    child: Center(child: child),
  );
}