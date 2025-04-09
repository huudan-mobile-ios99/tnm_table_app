import 'package:flutter/material.dart';
import 'package:tournament_client/lib/models/settingModelMongo.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/xgame/bottom/widget/image.box.dart';

class GameTableSettingPage extends StatefulWidget {

  const GameTableSettingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<GameTableSettingPage> createState() => _GameTableSettingPageState();
}

class _GameTableSettingPageState extends State<GameTableSettingPage> {
   final SocketManager socketManager = SocketManager();
  @override
  void initState() {
   socketManager.emitSetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: SocketManager().dataStreamSetting,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return textcustomColor(text: '',color:MyColor.white);
        } else if (snapshot.hasError) {
          return textcustom(text: '${snapshot.error}');
        }
        if (snapshot.data!.isEmpty ||
            snapshot.data == null ||
            snapshot.data == []) {
          return  Container();
        }
        SettingModelMongoList model =SettingModelMongoList.fromJson(snapshot.data!);
        // return const Text('Game Setting');
        return
           SizedBox(
            width: width,
             child: Stack(
              children: [
                Positioned(
                  bottom:MyString.padding84,left:0,
                  child: Column(
                    children: [
                      Container(
                        child: ImageBoxNoText(
                            textSize: MyString.padding84,
                            width: width/6,
                            height: height/6,
                            asset: "assets/circle.png",
                            text: '${model.list.first.round}',
                            ),

                      ),
                      const Text(
                        'ROUND #', // First text
                        style: TextStyle(
                          color: MyColor.white,
                          fontSize: MyString.padding18,
                          fontWeight: FontWeight.w600, // Non-bold for first text
                        ),
                        textAlign: TextAlign.center,),
                      ],
                  ),),



                // GAME
                Positioned(
                  bottom:MyString.padding84,right:0,
                  child: Column(
                    children: [
                      Container(
                        child: ImageBoxNoText(
                            textSize: MyString.padding84,
                            width: width/6,
                            height: height/6,
                            asset: "assets/circle.png",
                            text: '${model.list.first.game}',
                            ),

                      ),
                      const Text(
                        'GAME #', // First text
                        style: TextStyle(
                          color: MyColor.white,
                          fontSize: MyString.padding18,
                          fontWeight: FontWeight.w600, // Non-bold for first text
                        ),
                        textAlign: TextAlign.center,),
                      ],
                  ),)
              ],

                     ),
           );
      },
    );
  }
}
