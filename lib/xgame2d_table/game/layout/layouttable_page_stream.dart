import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
import 'package:tournament_client/xgame2d_table/game/layout/layout_item.dart';
import 'package:tournament_client/xgame2d_table/view/chartStreamNew.dart';
import 'package:tournament_client/xgame2d_table/game/layout/version/layouttable_page_bloc.dart';

class LayoutTablePageStream extends StatefulWidget {
  const LayoutTablePageStream({Key? key}) : super(key: key);

  @override
  State<LayoutTablePageStream> createState() => _LayoutTablePageStreamState();
}

class _LayoutTablePageStreamState extends State<LayoutTablePageStream> {
  late final StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  late final SocketManager mySocket = SocketManager();
  late final Stream<List<Map<String, dynamic>>> _throttledStream;
  late final StreamSubscription<List<Map<String, dynamic>>> streamSubscription;

  @override
  void initState() {
    super.initState();
    mySocket.initSocket();
    // Listen for incoming socket data and only update if changed
    _throttledStream = mySocket.dataStream.distinct();
    streamSubscription = _throttledStream.listen((data) {});
  }

  @override
  void dispose() {
    mySocket.disposeSocket();
    streamSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final heightItem = height/3.75;
    final widthItem = width/5.225;
    late List<String> memberNumber=[];

    return   StreamBuilder<List<Map<String, dynamic>>>(
      stream: _throttledStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Map<String, dynamic>>? dataList = snapshot.data;
          if (dataList == null || dataList.isEmpty) {
            return const Text('No Data Found',textAlign: TextAlign.center,);
          }
          List<int> membersOrigin = (dataList[0]['member'] as List<dynamic>)
          .map<int>((e) => int.tryParse(e.toString()) ?? 0)
          .toList();
          // Ensure `members` always has 5 elements
          List<String> paddedMembers = List<String>.filled(5, '');
          for (int i = 0; i < membersOrigin.length && i < 5; i++) {
            paddedMembers[i] = membersOrigin[i].toString();
          }

          return layoutBody(widthItem: widthItem, width: width, heightItem: heightItem, members: paddedMembers);


        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white),
          );
        }
      },
    );
  }
}


Widget layoutBody({required double widthItem, required double width,required double heightItem, required List<String> members}){
  return
       Stack(
        children: [
          Positioned(
            top: heightItem/3.15,
            left: width / 18,
            child: layoutChildItem(
            index: 0,
            number: members.isNotEmpty ? members[4] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#tag1

          Positioned(
            top: heightItem * 1.525,
            left: width / 6.65,
            child: layoutChildItem(
            index: 1,
            number:members.isNotEmpty ? members[3] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#2

          Positioned(
            top: heightItem*2.285,
            left:width/2-widthItem/2,
            child:
              layoutChildItem(
                  index: 2,
                  number:members.isNotEmpty ? members[2] : '',
                  height: heightItem,
                  width: widthItem,
                ),
          ), //#3

          Positioned(
            top: heightItem * 1.525,
            left: width - widthItem - width / 6.65,
            child: layoutChildItem(
            index: 3,
            number:members.isNotEmpty ? members[1] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#4


          Positioned(
            top: heightItem/3.15,
            left: width - widthItem - width / 18,
            child: layoutChildItem(
            index: 4,
            number:members.isNotEmpty ? members[0] : '',
            height: heightItem,
            width: widthItem,
            ),
          ), //#5

          // 2D Game Page
          const ChartStreamPageNew(),
          ]);
}
