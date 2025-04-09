import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/setup/list.item.dart';

Widget SettingMachineTitle({required double width}) {
  return Container(
    color: MyColor.bedge,
    child: ListTile(
      minVerticalPadding: MyString.padding02,
      contentPadding: const EdgeInsets.all(0.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: itemListRT(
              width: width,
              child:textcustom(text: '#', size: MyString.padding14, isBold: true),
            ),
          ),
          itemListRT(
            width: width,
            child: textcustom( text: 'Member', size: MyString.padding14, isBold: true),
          ),
          itemListRT(
            width: width,
            child: textcustom(
                text: 'Machine', size: MyString.padding14, isBold: true),
          ),
          itemListRT(
            width: width,
            child:
                textcustom(text: 'Ip', size: MyString.padding14, isBold: true),
          ),
          itemListRT(
            width: width,
            child: textcustom(
                text: 'Bet', size: MyString.padding14, isBold: true),
          ),
          itemListRT(
            width: width,
            child: textcustom(
                text: 'Credit', size: MyString.padding14, isBold: true),
          ),
          itemListRT(
              width: width,
              child: textcustom(text: 'Aft', size: MyString.padding14, isBold: true)),
          itemListRT(
              width: width,
              child: textcustom(
                  text: 'Connect', size: MyString.padding14, isBold: true)),
          itemListRT(
              width: width,
              child: textcustom(
                  text: 'Status', size: MyString.padding14, isBold: true)),
          Expanded(
              child: itemListRT(
                  width: width,
                  child: textcustom(text: 'Action', size: MyString.padding14, isBold: true))),
        ],
      ),
    ),
  );
}
