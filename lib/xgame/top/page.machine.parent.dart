
import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xpage/home/home_topranking.dart';

class MachineTopPage extends StatelessWidget {
  const MachineTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    //ONLY TOP RANKING
    return SizedBox(
        width:width,
        height:height,
        child:
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: MyString.padding56),
              width:width*0.65 - (MyString.padding24*2),
              height:height,
              child:
               HomeTopRankingPage(
                          title: MyString.APP_NAME,
                          url: MyString.BASEURL,
                          selectedIndex: MyString.DEFAULTNUMBER),
            ),
            SizedBox(
              width: width*0.35,
              height:height,
            ),
          ],
        )
    );

  //   return Container(
  //       height:height,
  //       // color:MyColor.whiteOpacity,
  //       padding: const EdgeInsets.symmetric(horizontal: MyString.padding32),
  //       width:width - (MyString.padding32*2),
  //       child: ViewPageChild(
  //                   url: MyString.BASEURL,
  //                   child2 : HomeRealTimePage(
  //                       title: MyString.APP_NAME,
  //                       url: MyString.BASEURL,
  //                       selectedIndex: MyString.DEFAULTNUMBER),
  //                   child: HomeTopRankingPage(
  //                       title: MyString.APP_NAME,
  //                       url: MyString.BASEURL,
  //                       selectedIndex: MyString.DEFAULTNUMBER),
  //               ),
  //     );
  }
}
