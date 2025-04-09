import 'package:flutter/material.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/service/format.date.factory.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame/bottom/game.jackpot.dart';

class SettingJPDrop extends StatefulWidget {
  SocketManager? mySocket;
  SettingJPDrop({required this.mySocket, Key? key}) : super(key: key);

  @override
  State<SettingJPDrop> createState() => _SettingJPDropState();
}

class _SettingJPDropState extends State<SettingJPDrop> {
  final formatNumber = DateFormatter();
  Map<String, dynamic>? currentData;

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void initState() {
    widget.mySocket!.emitJackpotDrop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double widthItem = width/6;
    final DateFormatter format = DateFormatter();
    return Container(
      width: width,height:55.0,
      padding: const EdgeInsets.symmetric(horizontal:MyString.padding16),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SocketManager().dataStreamJackpotDrop,
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


            final dynamic data = snapshot.data;

            late final String name = data[0]['name'];
            // late final double jackpotValue = data[0]['value'];
            late final int jackpotValue = data[0]['value'].round();
            late final int machineId = data[0]['machineId'] ?? 0;
            late final int count = data[0]['count'];
            late final String createdAt = format.formatDateAFullLocalStandar(DateTime.parse(data[0]['createdAt'])) ;

            // Compare new data with previous data


          return SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                itemJPDrop(color:MyColor.greenLightOpacity,text: "\$$jackpotValue",width:widthItem,isSmall: true),
                itemJPDrop(color:MyColor.red_bg_opacity,text:machineId==null?"No Machine" :"#$machineId",width:widthItem,isSmall:true),
                itemJPDrop(color:Colors.transparent,text: name ,width:widthItem,isSmall: false),
                itemJPDrop(color:Colors.transparent,text: "$count (Times)",width:widthItem,isSmall: false),
                itemJPDrop(color:Colors.transparent,text:  createdAt ,width:widthItem,isSmall: false),

              ],
            ),
          );
        },
      ),
    );
  }
}

Widget itemJPDrop({required double width,required String text, required Color color,bool? isSmall }){
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(MyString.padding08),
    ),
    width:width,
    child:textcustom(text:text,size: isSmall ==false? MyString.padding18:MyString.padding36,isBold:isSmall ==false ? false :true )
  );
}
