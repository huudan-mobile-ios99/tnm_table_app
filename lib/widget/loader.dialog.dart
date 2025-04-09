import 'package:flutter/material.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';


showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: MyColor.white,
      content: Row(
        children: [
          const CircularProgressIndicator.adaptive(),
          Container(margin: const EdgeInsets.only(left: MyString.padding08),child:textcustom(text:"Loading, Please wait for a moment" )),
        ],),
    );
    showDialog(barrierDismissible: true,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }