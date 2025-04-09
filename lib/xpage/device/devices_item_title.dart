import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
Widget itemListDeviceTitle({required context,required width}){
  return Container(
    padding:const EdgeInsets.all(MyString.padding08),
    color: Theme.of(context!).primaryColorLight,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        itemListDevice(
          width: width,
          child: textcustom(text: '#', size: MyString.padding14, isBold: true),
        ),
        itemListDevice(
          width: width,
          child: textcustom(text: 'IP Address', size: MyString.padding14, isBold: true),
        ),
        itemListDevice(
          width: width,
          child: textcustom(text: 'DeviceID', size: MyString.padding14, isBold: true),
        ),
        itemListDevice(
          width: width,
          child: textcustom(text: 'Device Name', size: MyString.padding14, isBold: true),
        ),
        itemListDevice(
          width: width,
          child: textcustom(text: 'User Agent', size: MyString.padding14, isBold: true),
        ),

        itemListDevice(
          width: width,
          child: textcustom(text: 'Device Info', size: MyString.padding14, isBold: true),
        ),

        itemListDevice(
          width: width,
          child: textcustom(text: 'Date Time', size: MyString.padding14, isBold: true),
        ),
        Expanded(
            child: itemListDevice(
                width: width,
                child: textcustom(text: 'Actions', size: MyString.padding14, isBold: true))),
      ],
    ),
  );
}

Widget itemListDevice({width, child}) {
  return Container(
    alignment: Alignment.centerLeft,
    width: width / 9,
    child:  child,
  );
}


