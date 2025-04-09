// import 'package:flutter/material.dart';
// import 'package:tournament_client/utils/mystring.dart';
// import 'package:tournament_client/xgame/top/page.machine.parent.dart';
// import 'package:tournament_client/xgame/top/page.machine.child.dart';

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
//     const paddingHorizontalDouble = MyString.padding16 * 2;
//     const paddingHorizontalHalf = MyString.padding12;
//     const paddingVertical = MyString.padding08;

//     final double widthGridV = width / 3;
//     final double heightGridV = height / 3;

//     final double widthGridVCenter = width / 2.935;
//     final double heightGridVCenter = height / 2.935;
//     return Container(
//       width: width,
//       height: height,
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('asset/bg.jpg'), fit: BoxFit.cover)),
//       child: Stack(
//         children: [
//           //VIDEO VIEW
//           SizedBox(
//             width: width,
//             height: height,
//             child: const MachineViewPage(),
//           ),
//           //TOP & REALTIME RANKING VIEW
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//                 color: Colors.transparent,
//                 width: widthGridVCenter,
//                 height: heightGridVCenter,
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.circular(MyString.padding24),
//                     child: const MachineTopPage())),
//           ),
//         ],
//       ),
//     );
//   }
// }
