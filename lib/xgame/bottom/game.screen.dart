import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xgame/bottom/size.config.dart';

class GameScreenPage extends StatefulWidget {
  const GameScreenPage({Key? key}) : super(key: key);

  @override
  State<GameScreenPage> createState() => _GameScreenPageState();
}

class _GameScreenPageState extends State<GameScreenPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('lib/xgame/bottom/game.screen.dart');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height*SizeConfig.screenVerMain;
    final width = MediaQuery.of(context).size.width*SizeConfig.screenVerMain;
    return Container(
      alignment: Alignment.topCenter,
      width: width,
      height: height,
      decoration: const BoxDecoration(
        color:MyColor.black_absolute,
        border: Border(
        right: BorderSide(width: MyString.padding02, color: MyColor.yellow_bg2),
        bottom: BorderSide(width: MyString.padding02, color: MyColor.yellow_bg2),
        ),
        // borderRadius: BorderRadius.circular(MyString.padding16)
      ),
      child: const Center(
        // child: Text('screen', style: TextStyle(color: MyColor.white)),
      ),
    );
  }
}
