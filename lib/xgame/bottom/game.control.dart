import 'package:flutter/material.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/xgame/bottom/game.time.dart';
import 'package:tournament_client/xgame/bottom/size.config.dart';

class GameControlPage extends StatelessWidget {
  final SocketManager socketManager;
  final String selectedNumber;
  final String uniqueId;
  final bool isChecked;
  const GameControlPage({
    required this.isChecked,
    required this.socketManager,required this.selectedNumber,required this.uniqueId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final heightItem = height * SizeConfig.controlItemMain;
    final heightItem2 = height * SizeConfig.controlItemSub;
    final width = MediaQuery.of(context).size.width * SizeConfig.controlVerMain;
    return Container(
      alignment: Alignment.centerLeft,
      width: width,
      height: height,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // SizedBox(
            //   width: width,
            //   height: heightItem,
            //   child: GameSettingPage(
            //       socketManager: socketManager,
            //       uniqueId:uniqueId,
            //       selectedNumber:selectedNumber,
            //       isChecked: isChecked,
            //       width: width,
            //       height: heightItem),
            // ),
            Container(
              alignment: Alignment.center,
              width: width,
              height: heightItem2,
              // color: MyColor.whiteOpacity,
              child: GameTime(
                  socketManager: socketManager,
                  width: width,
                  height: heightItem2),
            ),
          ]),
    );
  }
}
