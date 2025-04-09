import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';

Widget ImageBoxNoText(
    {required double textSize,
    required double width,
    required double height,
    required String asset,
    required String label,
    required String text}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(asset),
          fit: BoxFit.contain,
        )),
        child: Text(
          text, // Second text
          style: TextStyle(
            color: MyColor.yellow_bg,
            fontSize: textSize,
            fontWeight: FontWeight.bold, // Bold for second text
          ),
          textAlign: TextAlign.center,
        ),
      ),
       Positioned(
        bottom: 0,
        child: Text(
          label, // First text
          style: const TextStyle(
            color: MyColor.white,
            fontSize: MyString.padding18,
            fontWeight: FontWeight.w500, // Non-bold for first text
          ),
          textAlign: TextAlign.center, // Center align if needed
        ),
      )
    ],
  );
}
