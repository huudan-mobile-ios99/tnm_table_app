import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';

void showSnackBar({String? message, BuildContext? context}) {
  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: MyColor.white,
    duration: const Duration(seconds: 1),
    backgroundColor: MyColor.black_text_opa,
    content: Text(
      message!,
      style: const TextStyle(
        fontFamily: 'OpenSan',
        fontSize: 16.0,
        color: MyColor.white,
      ),
    ),
  );
  ScaffoldMessenger.of(context!).showSnackBar(snackBar);
}


void showSnackBarError({String? message, BuildContext? context,}) {
  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: MyColor.white,
    duration: const Duration(seconds: 1),
    backgroundColor: MyColor.red_accent,
    content: Text(
      message!,
      style: const TextStyle(
        fontFamily: 'OpenSan',
        fontSize: 16.0,
        color: MyColor.white,
      ),
    ),
  );
  ScaffoldMessenger.of(context!).showSnackBar(snackBar);
}
