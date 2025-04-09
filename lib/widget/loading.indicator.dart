import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';

Widget loadingIndicator(text) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const CircularProgressIndicator(
          strokeWidth: .5,
          color: MyColor.white,
        ),
        const SizedBox(height: 16), // Adjust the height as needed
        Text('$text', style: const TextStyle(color: MyColor.white)),
      ],
    ),
  );
}

Widget loadingNoIndicator() {
  return const Center(
    child: CircularProgressIndicator(
      strokeWidth: .5,
      color: MyColor.white,
    ),
  );
}

Widget loadingIndicatorSize() {
  return Container(
    alignment: Alignment.center,
    height:MyString.padding32,
    child:const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator.adaptive(strokeWidth: 1.0,backgroundColor: MyColor.grey_tab,),
        // SizedBox(width: MyString.padding04,),
        // Text("loading data")
      ],
    )
  );
}
