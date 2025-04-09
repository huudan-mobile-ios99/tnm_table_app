
import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';

Widget layoutChildItem({required int index,
  required String number,required double width,required double height, }){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
                  width: width,
                  height:height,
                  decoration: const BoxDecoration(
                    // color:MyColor.appBar,
                  image: DecorationImage(
                  image: AssetImage('assets/bg_round.png'),
                  fit: BoxFit.contain,
                  ),
                  ),
                ),
      const SizedBox(height:MyString.padding04),
      number.isEmpty || number =='' || number=='...' ? Container(): Container(
        padding: const EdgeInsets.symmetric(horizontal:MyString.padding17,vertical: 0.0),
        decoration:BoxDecoration(
          color: MyColor.red_accent2,
          border: Border.all(color:MyColor.yellow3,width: MyString.padding02),
          borderRadius: BorderRadius.circular(MyString.padding12)
        ),
        child: textcustomColor(text:number,color:MyColor.white,size:MyString.padding16,isBold: true)
      ),
    ],
  );
}
