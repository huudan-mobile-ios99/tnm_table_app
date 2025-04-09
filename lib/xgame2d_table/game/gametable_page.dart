import 'package:flutter/material.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/xgame2d_table/game/layout/layouttable_page_stream.dart';
import 'package:tournament_client/xgame2d_table/game/setting/gametable_setting.dart';
import 'package:tournament_client/xgame2d_table/game/layout/layouttable_page.dart';

class GameTablePage extends StatefulWidget {
  const GameTablePage({Key? key}) : super(key: key);

  @override
  State<GameTablePage> createState() => _GameTablePageState();
}

class _GameTablePageState extends State<GameTablePage> {
  @override
  void initState() {
    super.initState();
    debugPrint('lib/GameBaccaratPage.dart');
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final double widthItem = width / 3.6225;
    final double heightItem = height / 3.325;

    return
    Container(
      width:width,height:height,
      decoration:const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/bg_black.png"),fit: BoxFit.cover),
      ),
      child: SizedBox(
        width: width, height:height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -MyString.padding16,
              child: SizedBox(
                width: width,
                height: height,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/table2.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // Screen Display
            Positioned(
              top: MyString.padding56,
              child: SizedBox(
                // color:MyColor.appBar,
                width: widthItem,
                height: heightItem,
                child:const DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/bg_round2.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // Layout Baccarat
            const Align(
              alignment: Alignment.topLeft,
              child: LayoutTablePageStream(),
              // child: LayoutTablePage(),
            ),

            //Chip Game 2D
            const GameTableSettingPage(),
          ],
        ),
      ),
    );
  }
}
