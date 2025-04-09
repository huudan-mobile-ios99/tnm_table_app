// import 'package:flutter/material.dart';
// import 'package:tournament_client/lib/socket/socket_manager.dart';
// import 'package:tournament_client/utils/mycolors.dart';
// import 'package:tournament_client/widget/text.dart';
// import 'package:tournament_client/xgame/bottom/game.odometer.child2.dart';
// import 'package:tournament_client/xgame/bottom/size.config.dart';

// class GameJackpot2 extends StatefulWidget {
//   final SocketManager socketManager;

//   const GameJackpot2({
//     required this.socketManager,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<GameJackpot2> createState() => _GameJackpot2State();
// }

// class _GameJackpot2State extends State<GameJackpot2> {
//   @override
//   void initState() {
//     debugPrint("INIT GAME JACKPOT 2");
//     //emit lucky price
//     // widget.socketManager.emitJackpot2Number();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final double width = MediaQuery.of(context).size.width * SizeConfig.screenVerMain;
//     final double height = MediaQuery.of(context).size.height * SizeConfig.controlVerMain;

//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: SocketManager().dataStreamJackpotNumber2,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//               child: CircularProgressIndicator(
//             color: MyColor.white,
//             strokeWidth: .5,
//           ));
//         } else if (snapshot.hasError) {
//           return textcustom(text: 'error ${snapshot.error}');
//         }
//         if (snapshot.data!.isEmpty ||
//             snapshot.data == null ||
//             snapshot.data == []) {
//           return const Center(child: Icon(Icons.do_not_disturb_alt_sharp));
//         }
//         late final data = snapshot.data as List<Map<String, dynamic>>;
//         late final int jackpotValue = data[0]['returnValue'].round();
//         late final int jackpotValueOld = data[0]['oldValue'].round();
//         late final int selectedIp = data[0]['ip'] ?? 0;
//         late final bool drop = data[0]['drop'];
//         // return Text('${snapshot.data}', style: TextStyle(color: MyColor.white));
//         return GameOdometer2Child(height: height,width: width,
//          startValue1: jackpotValueOld,
//          endValue1: jackpotValue,
//          dropValue: jackpotValue,
//          title1: "LUCKY\nJP",
//          machineNumber: selectedIp,
//          droppedJP: drop,
//         );
//       },
//     );
//   }
// }
