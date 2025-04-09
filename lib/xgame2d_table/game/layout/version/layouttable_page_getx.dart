


// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/widget/text.dart';
// import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
// import 'package:tournament_client/xgame2d_table/chart/getx/chartController.dart';
// import 'package:tournament_client/xgame2d_table/view/chartStreamNew.dart';
// import 'package:tournament_client/xgame2d_table/game/layouttable_page_bloc.dart';

// class LayoutTablePage extends StatelessWidget {
//   const LayoutTablePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width;
//     final double height = MediaQuery.of(context).size.height;
//     final heightItem = height/3.75;
//     final widthItem = width/5.225;
//     late List<String> membersList=[];

//     return GetBuilder<ChartStreamController>(
//        init: ChartStreamController(),
//        didChangeDependencies: (state) {

//        },
//        didUpdateWidget: (oldWidget, state) {

//        },
//        builder: (controller)  {
//        membersList = (controller.members.length >= 5)
//         ? controller.members.map((e) => e.toString()).toList()
//         : List.filled(5, '');  // Default empty values
//       return
//        Stack(
//         children: [
//           Positioned(
//             top: heightItem/3.15,
//             left: width / 18,
//             child: layoutChildItem(
//             index: 0,
//             number:  membersList.isNotEmpty ? membersList[4] ?? '' : '',
//             height: heightItem,
//             width: widthItem,
//             ),
//           ), //#tag1

//           Positioned(
//             top: heightItem * 1.525,
//             left: width / 6.65,
//             child: layoutChildItem(
//             index: 1,
//        number: membersList.isNotEmpty ? membersList[3] ?? '' : '',
//             height: heightItem,
//             width: widthItem,
//             ),
//           ), //#2

//           Positioned(
//             top: heightItem*2.285,
//             left:width/2-widthItem/2,
//             child:
//               layoutChildItem(
//                   index: 2,
//                  number: membersList.isNotEmpty ? membersList[2] ?? '' : '',
//                   height: heightItem,
//                   width: widthItem,
//                 ),
//           ), //#3

//           Positioned(
//             top: heightItem * 1.525,
//             left: width - widthItem - width / 6.65,
//             child: layoutChildItem(
//             index: 3,
//            number: membersList.isNotEmpty ? membersList[1] ?? '' : '',
//             height: heightItem,
//             width: widthItem,
//             ),
//           ), //#4


//           Positioned(
//             top: heightItem/3.15,
//             left: width - widthItem - width / 18,
//             child: layoutChildItem(
//             index: 4,
//             number: membersList.isNotEmpty ? membersList[0] ?? '' : '',
//             height: heightItem,
//             width: widthItem,
//             ),
//           ), //#5

//           // 2D Game Page
//           // const ChartStreamPage(),
//           const ChartStreamPageNew(),

//           //Positioned display data
//           // Positioned(
//           //   bottom:0,right:0,
//           //   child: Container(
//           //     width: width/2, height:50, child: textcustomColor(color:MyColor.white,text:"${membersList}")
//           //   ),
//           // ),
//           ]);
//       },);
//   }
// }
