import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/setting/bloc_machine/machine_bloc.dart';
import 'package:tournament_client/xpage/setting/bloc_timer/timer_bloc.dart';
import 'package:tournament_client/xpage/setting/setting.machine.page.dart';
import 'package:tournament_client/xpage/setting/setting.operator.dart';
import 'package:tournament_client/xpage/setting/setting.page.dart';
import 'package:http/http.dart' as http;


class SettingContainer extends StatelessWidget {
  SocketManager? mySocket;
  // final bool isAdmin;
  SettingContainer({required this.mySocket, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: textcustom(text: 'Settings Real Time', size: MyString.padding16),
        actions: const [],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TimerBloc(),
              child: SettingOperator(mySocket: mySocket)),
          BlocProvider( create: (context) => ListMachineBloc(httpClient: http.Client()))
        ],
        child:
          SingleChildScrollView(
            physics:const  AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              width: width,
              height:height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // SettingJPDrop(mySocket:mySocket),
                  // SettingOperator(mySocket:mySocket) ,
                  SettingPage(mySocket:mySocket),
                  const SettingMachinePage(),
                ]
              ),
            ),
          ),
      )
    );
  }
}
