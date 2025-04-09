import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:http/http.dart' as http;
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xpage/device/bloc/device_bloc.dart';
import 'package:tournament_client/xpage/device/devices_list.dart';


class DevicesPage extends StatelessWidget {
  SocketManager? mySocket;
  String? selectedId;

   DevicesPage({Key? key,this.mySocket,this.selectedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
       appBar: AppBar(
        centerTitle: false,
        title:  textcustom(text:'Device List',size: MyString.padding16),
        actions: const [],
      ),
      body: SizedBox(
          width:width,
          height:height,
          child:BlocProvider(
            lazy: false,
            create: (_) => DeviceBloc(httpClient: http.Client())..add(DeviceFetched()),
            child:   DevicesListPage(selectedId:selectedId,mySocket: mySocket),
          )
        ),
    );
  }
}
