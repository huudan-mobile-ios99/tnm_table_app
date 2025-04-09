// import 'package:flutter/material.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xgame/top/machineview.page.dart';
// import 'package:tournament_client/xpage/home/home_realtime.dart';
// import 'package:tournament_client/xpage/home/home_topranking.dart';

// class MachineViewContainer extends StatelessWidget {
//   const MachineViewContainer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final heightView = height * .545;
//     final heightRank = height * .455;
//     final widthItem = width * .5;
//     const paddingHorizontal = MyString.padding16;
//     const paddingHorizontalDouble = MyString.padding16*2;
//     const paddingHorizontalHalf = MyString.padding12;
//     const paddingVertical = MyString.padding08;
//     // final width = width
//     return Scaffold(
//       body: Container(
//         width: width,
//         height: height,
//         decoration: const BoxDecoration(
//           color:MyColor.black_absolute,
//           // image: DecorationImage(
//           //   image: AssetImage('asset/bg.jpg'),
//           //   fit: BoxFit.cover,
//           //   filterQuality: FilterQuality.none,
//           // ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(width: width, height: heightView,child: MachineViewPage(
              
//             ),),
//             SizedBox(
//               width: width,
//               height: heightRank,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   //top ranking
//                   Container(
//                     margin:  const EdgeInsets.only(
//                       top: paddingVertical,
//                       bottom: paddingVertical,
//                       left: paddingHorizontal,
//                       right: paddingHorizontalHalf,
//                     ),
//                     decoration: BoxDecoration(
//                         color: MyColor.whiteOpacity,
//                         borderRadius: BorderRadius.circular(MyString.padding16)),
//                     width: widthItem - paddingHorizontalDouble,
//                     height: heightRank - paddingVertical,
//                     child: HomeTopRankingPage(
//                         title: MyString.APP_NAME,
//                         url: MyString.BASEURL,
//                         selectedIndex: MyString.DEFAULTNUMBER),
//                   ),
//                   //realtime ranking
//                   Container(
//                     decoration: BoxDecoration(
//                         color: MyColor.whiteOpacity,
//                         borderRadius: BorderRadius.circular(MyString.padding16)),
//                     margin:  const EdgeInsets.only(
//                       top: paddingVertical,
//                       bottom: paddingVertical,
//                       right: paddingHorizontal,
//                       left: paddingHorizontalHalf,
//                     ),
//                     width: widthItem - paddingHorizontalDouble,
//                     height: heightRank - paddingVertical,
//                     child: 
//                     HomeRealTimePage(
//                       url: MyString.BASEURL,
//                       selectedIndex: MyString.DEFAULTNUMBER,
//                       title: MyString.APP_NAME,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
