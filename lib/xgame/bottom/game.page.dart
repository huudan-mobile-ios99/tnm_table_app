import 'package:flutter/material.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/service/service_api.dart';
import 'package:tournament_client/service/service_ip.dart';
import 'package:tournament_client/utils/checkuuid.dart';
import 'package:tournament_client/utils/generate_string.dart';
import 'package:tournament_client/xgame/bottom/game.control.dart';
import 'package:tournament_client/xgame/bottom/game.jackpot.dart';
import 'package:tournament_client/xgame/bottom/game.screen.dart';
import 'package:tournament_client/xgame/bottom/size.config.dart';

class GamePage extends StatefulWidget {
  final String selectedNumber;
  final String uniqueId;
  final bool isChecked;
  const GamePage({Key? key,required this.isChecked, required this.selectedNumber,required this.uniqueId}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late final socketManager = SocketManager();


  final ServiceAPIs serviceAPIs = ServiceAPIs();
  final ServiceIP serviceIP = ServiceIP();
  final String uniqueId = getOrCreateUniqueId();
  late String ipAddress = '';
  @override
  void initState() {
    super.initState();
    debugPrint('lib/xgame/bottom/game.page.dart');
    socketManager.initSocket();

    final userAgent =  serviceIP.getUserAgent();
    final devicePlatform = serviceIP.getDevicePlatform();
    debugPrint("userAgent: $userAgent");
    debugPrint("devicePlatform: $devicePlatform");
    serviceIP.getPublicIp().then((ip){
      setState(() {
        ipAddress = ip;
      });
      if(uniqueId.isNotEmpty){
       serviceAPIs.createNewDevice(
        userAgent: userAgent! ,platform: devicePlatform! ,ipAddress: ip, deviceId: uniqueId, deviceName: 'DEVICE_${generateRandomString(8)}', deviceInfo: "");
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    socketManager.disposeSocket();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final double widthJP = width * SizeConfig.screenVerMain;
    final double heightJP = height * SizeConfig.controlVerMain;

    return Scaffold(
      body: Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/bg.jpg'),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.none,
        ),
      ),
      child: Stack(
        children: [
          const GameScreenPage(),
          //GAME CONTROL
          Positioned(
              top: 0,
              right: 0,
              child: GameControlPage(
                      uniqueId:widget.uniqueId ?? "",socketManager: socketManager,
                      selectedNumber:widget.selectedNumber,
                      isChecked: widget.isChecked,
                    )),
          //JACKPOT
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              width: widthJP,
              height: heightJP,
              // color:MyColor.whiteOpacity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  GameJackpot(
                    socketManager: socketManager,
                  ),
                  SizedBox(
                    width: width * SizeConfig.controlItemSub,
                  )
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   mainAxisSize: MainAxisSize.min,
              //   children: [
              //     GameJackpot(
              //       socketManager: socketManager,
              //     ),
              //     GameJackpot2(
              //       socketManager: socketManager,
              //     ),
              //   ],
              // ),
            ),
          )
        ],
      ),
    ));
  }
}
