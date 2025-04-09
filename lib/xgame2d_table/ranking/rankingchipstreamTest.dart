import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/xgame2d_table/chart/getx/chartController.dart';
import 'package:tournament_client/xgame2d_table/chart/getx/chartControllerRanking.dart';

// ignore: must_be_immutable
class RankingChipStreamPageV2 extends StatefulWidget {
  const RankingChipStreamPageV2({
    Key? key,
  }) : super(key: key);
  @override
  State<RankingChipStreamPageV2> createState() => _RankingChipStreamPageV2State();
}

class _RankingChipStreamPageV2State extends State<RankingChipStreamPageV2> {
  IO.Socket? socket;
  late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  SocketManager? mySocket;
  late final Stream<List<Map<String, dynamic>>> _throttledStream;
  late final StreamSubscription<List<Map<String, dynamic>>> streamSubscription;
  final ChartControllerRanking controller = Get.put(ChartControllerRanking());

  @override
  void initState() {
    super.initState();
    debugPrint('Ranking Chip Stream Page');
    mySocket!.initSocket();


    _throttledStream = mySocket!.dataStream.distinct();
    streamSubscription = _throttledStream.listen((data) {
      if (data.isNotEmpty) {
        // arrangeData(data);
        streamController.add(data);
      }
    });
  }

  @override
  void dispose() {
    socket!.disconnect();
    SocketManager().disposeSocket();
    controller.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    socket!.emit('eventFromClient2');
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GetBuilder<ChartStreamController>(builder: (controller) =>  StreamBuilder<List<Map<String, dynamic>>>(
      stream: _throttledStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Map<String, dynamic>>? dataList = snapshot.data;
          if (dataList == null || dataList.isEmpty) {
            return const Text('No Data Found');
          }

          return  Text('$dataList');


        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white),
          );
        }
      },)
    );

  }


  void arrangeData(List<dynamic> dataList,) {
                  final List<String> names = dataList[0]['name'].cast<String>();
                  final List <String> updatedNames = names.map((name) => name).toList();
                  final List<String> times = dataList[0]['time'].cast<String>();
                  final List<int> numbers = dataList[0]['number'].map<int>((number) => int.tryParse(number.toString()) ?? 0).toList();
                  final List<List<double>> dataField = List<List<double>>.from( dataList[0]['data'].map<List<double>>((item) =>List<double>.from(item.map((value) => value.toDouble()))));

  // controller.updateChartDataRanking(
  //     newInputNumbers: inputNumber,
  //     newInitialChips: initialChips,
  //     newNextChips: nextChips,
  //     newValueDisplay: valueDislay,
  //     newValueDisplayPrev: valueDisplayPrev,
  //     newMembers: members,
  //     newPositionX: positionXCombined,
  //     newPositionY: positionYCombined,
  //   );
  debugPrint('arrangeData dataList: $dataField');
}
}










// StreamBuilder<List<Map<String, dynamic>>>(
    //           stream: SocketManager().dataStream2,
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return const Center(
    //                 child: CircularProgressIndicator(
    //                     strokeWidth: .5, color: MyColor.white),
    //               );
    //             }
    //             if (snapshot.hasData) {
    //               if (snapshot.data!.isEmpty ||
    //                   snapshot.data == null ||
    //                   snapshot.data == []) {
    //                   return const Text('No Data');
    //               }
    //               final List<Map<String, dynamic>>? data = snapshot.data;
    //               final List<String> names = data![0]['name'].cast<String>();
    //               final List <String> updatedNames = names.map((name) => name).toList();
    //               final List<String> times = data[0]['time'].cast<String>();
    //               final List<int> numbers = data[0]['number'].map<int>((number) => int.tryParse(number.toString()) ?? 0).toList();
    //               final List<List<double>> dataField = List<List<double>>.from( data[0]['data'].map<List<double>>((item) =>List<double>.from(item.map((value) => value.toDouble()))));
    //   return Stack(
    //   children: [
    //   SizedBox(
    //   height: height, // Ensure it has a height
    //   width: width, // Ensure it has a width
    //   child: ListView.builder(
    //   itemCount: updatedNames.length,
    //   scrollDirection: Axis.horizontal,
    //   itemBuilder: (context, index) {
    //   return SizedBox(
    //     width: width / 10,
    //     height: height,
    //     child: GameWidget(
    //       key: ValueKey(controller.gameInstances[index].index),
    //       game: controller.gameInstances[index],
    //     ),
    //   );
    // },)
    // ),
    // ],
    // );
    // } else if (snapshot.hasError) {
    //   return const Center(child: Text('An Error Orcur'));
    // } else {
    //   return const Center(child: CircularProgressIndicator( strokeWidth: .5, color: MyColor.white),
    // );}},
    // );
