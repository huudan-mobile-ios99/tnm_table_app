import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';

class AdminItemTitleJP extends StatelessWidget {
  Function? onRefresh;
  AdminItemTitleJP({Key? key,required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double widthItem = width / 8.5;
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: MyString.padding08,horizontal: MyString.padding08),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          border: const Border(
            bottom: BorderSide(width: 1.0, color: MyColor.grey_tab),
            top: BorderSide(width: 1.0, color: MyColor.grey_tab),
            left: BorderSide(width: 1.0, color: MyColor.grey_tab),
            right: BorderSide(width: 1.0, color: MyColor.grey_tab),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: widthItem,
              child: textcustom(
                text:"#",
                size: MyString.padding16,
                isBold: true
              ),
            ),
            const Divider(),
            SizedBox(
              width: widthItem,
              child: textcustom(text:"NAME JP", size:MyString.padding16,isBold: true),
            ),
            SizedBox(
              width: widthItem,
              child: textcustom(text:"DROP VALUE", size:MyString.padding16,isBold: true),
            ),
            const Divider(),
            SizedBox(
              width: widthItem,
              child: textcustom(text:"MACHINE ID", size:MyString.padding16,isBold: true),
            ),
            const Divider(),
            SizedBox(
              width: widthItem,
              child: textcustom(text:"COUNT", size:MyString.padding16,isBold: true),
            ),
            const Divider(),
            SizedBox(
                width: widthItem,
                child: textcustom(text:"TIME", size:MyString.padding16,isBold: true)),
            const Divider(),
            SizedBox(
                width: widthItem,
                child: textcustom(text:"DATE", size:MyString.padding16,isBold: true)),
            const Divider(),
            Expanded(
              child: SizedBox(
                  width: widthItem,
                  child: Row(
                    children: [
                      textcustom(text:"ACTION", size:MyString.padding16,isBold: true),
                      IconButton(onPressed: (){onRefresh!();}, icon: const Icon(Icons.refresh))
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

