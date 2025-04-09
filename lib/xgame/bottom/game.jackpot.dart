import 'package:flutter/material.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame/bottom/game.odometer.child.dart';
import 'package:tournament_client/xgame/bottom/size.config.dart';


class GameJackpot extends StatefulWidget {
  final SocketManager socketManager;


  const GameJackpot({
    required this.socketManager,
    Key? key,
  }) : super(key: key);

  @override
  State<GameJackpot> createState() => _GameJackpotState();
}

class _GameJackpotState extends State<GameJackpot> {
    final bool _showOdometerChild = false; // State to control widget display
    Map<String, dynamic>? _currentData; // Cache the current data


  @override
  void initState() {
    debugPrint("INIT GAME JACKPOT");
    //emit vegas price
    // widget.socketManager.emitJackpotNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width =  MediaQuery.of(context).size.width * SizeConfig.screenVerMain;
    final double height =  MediaQuery.of(context).size.height * SizeConfig.controlVerMain;

        return StreamBuilder<List<Map<String, dynamic>>>(
          stream: SocketManager().dataStreamJackpotNumber,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return circularProgress();
            } else if (snapshot.hasError) {
              return textcustom(text: 'error ${snapshot.error}');
            }
            if (snapshot.data!.isEmpty ||
                snapshot.data == null ||
                snapshot.data == []) {
              return const Center(child: Icon(Icons.do_not_disturb_alt_sharp));
            }
            late final  data = snapshot.data as List<Map<String, dynamic>>;
            late final int jackpotValue = data[0]['returnValue'].round();
            late final int jackpotValueOld = data[0]['oldValue'].round();
            late final int selectedIp = data[0]['ip']  ?? 0 ;
            late final bool drop = data[0]['drop'];
            // return Text('${snapshot.data}', style: TextStyle(color: MyColor.white));

              return GameOdometerChild(
              height: height,width: width,
              startValue1: jackpotValueOld,
              endValue1: jackpotValue,
              dropValue: jackpotValue,
              title1: "VEGAS\nJP",
              machineNumber: selectedIp,
              droppedJP: drop,
              );

          },
        );
  }
}

Widget circularProgress(){
  return  const Center(
            child: CircularProgressIndicator(
            color: MyColor.white,
            strokeWidth: .5,
          ));
}
