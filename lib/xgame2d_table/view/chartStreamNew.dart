import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/utils/functions.dart';
import 'package:tournament_client/xgame2d_table/chart/bloc/chartBloc.dart';
import 'package:tournament_client/xgame2d_table/view/chartScreenNew2.dart';
import 'package:tournament_client/xgame2d_table/chart/getx/chartController.dart';


class ChartStreamPageNew extends StatefulWidget {
  const ChartStreamPageNew({Key? key}) : super(key: key);

  @override
  State<ChartStreamPageNew> createState() => _ChartStreamPageNewState();
}

class _ChartStreamPageNewState extends State<ChartStreamPageNew> {
  late final StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  late final SocketManager mySocket = SocketManager();
  late final Stream<List<Map<String, dynamic>>> _throttledStream;
  late final StreamSubscription<List<Map<String, dynamic>>> streamSubscription;
  final ChartStreamController chartController = Get.put(ChartStreamController());



  List<int> members = [];
  List<int> initialChips = [];
  List<int> nextChips = [];
  List<int> inputNumber = [];
  List<int> valueDislay = [];
  List<int> valueDisplayPrev = [];

  @override
  void initState() {
    super.initState();
    mySocket.initSocket();

    // Listen for incoming socket data and only update if changed
    _throttledStream = mySocket.dataStream.distinct();
    streamSubscription = _throttledStream.listen((data) {
      if (data.isNotEmpty) {
        arrangeDataSkip(data, [],
       [-128.32080200501252, 82.28571428571429, 411.42857142857144, 310.85714285714283, 512,],
       [352, 702.5242718446601, 915.8640776699028, 702.5242718446601, 352]
        );
        streamController.add(data);
      }
    });
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
    final double heightItem = height / 5.15;
    final double widthItem = width / 5.25;

    final List<double> positionXs = [
      -widthItem / 2.85,
      widthItem * 0.225,
      widthItem * 1.125,
      widthItem * 0.85,
      widthItem * 1.4,
    ];
    final List<double> positionYs = [
      heightItem * 1.665,
      heightItem * 3.35,
      heightItem * 4.415,
      heightItem * 3.35,
      heightItem * 1.665,
    ];

    return GetBuilder<ChartStreamController>(builder: (controller) =>  StreamBuilder<List<Map<String, dynamic>>>(
      stream: _throttledStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Map<String, dynamic>>? dataList = snapshot.data;
          if (dataList == null || dataList.isEmpty) {
            return const Text('No Data Found');
          }

          // final List<double> positionXCombined = syncDefautLists(positionXs, valueDislay);
          // final List<double> positionYCombined = syncDefautLists(positionYs, valueDislay);
          // // debugPrint('$positionXCombined');
          // // debugPrint('$positionYCombined');
          //  context.read<ChartStreamBloc>().add(UpdateChartDataEvent(
          //         inputNumbers: inputNumber,
          //         initialChips: initialChips,
          //         nextChips: nextChips,
          //         valueDisplay: valueDislay,
          //         valueDisplayPrev: valueDisplayPrev,
          //         members: members,
          //         positionX: positionXCombined, // Now correctly updated
          //         positionY: positionYCombined, // Now correctly updated
          // ));


          return   const ChartScreenNew2(
          // inputNumbers: chartController.inputNumbers,
          // initialChips: chartController.initialChips,
          // nextChips: chartController.nextChips,
          // members: chartController.members,
          // positionXList: chartController.positionX,
          // positionYList: chartController.positionY,
          // valueDisplay: chartController.valueDisplay,
          // valueDisplayPrev: chartController.valueDisplayPrev,
          );


        } else {
          return const Center(
            child: CircularProgressIndicator(strokeWidth: 1, color: Colors.white),
          );
        }
      },)
    );
  }


void arrangeDataSkip(List<dynamic> dataList, List<int> skipList,List<double>positionXs,List<double> positionYs) {
  List<int> membersOrigin = dataList[0]['member'].map<int>((e) => int.tryParse(e) ?? 0).toList();
  List<dynamic> rawData = dataList[1]['data'];
  List<int> keys = List<int>.from(rawData[0]);
  // Create combined list
  List<Map<String, dynamic>> combined = List.generate(keys.length, (index) {
    return {
      'key': keys[index],
      'member': membersOrigin[index],
      'data1': (rawData[1][index] as num).round().toInt(),
      'data2': (rawData[2][index] as num).round().toInt(),
    };
  });
  // Filter out keys that are in skipList
  combined.removeWhere((item) => skipList.contains(item['key']));
  // Sort remaining data by key
  combined.sort((a, b) => a['key'].compareTo(b['key']));
  // Update lists with sorted and filtered data
  inputNumber = combined.map((e) => e['key'] as int).toList();
  members = combined.map((e) => e['member'] as int).toList();


  initialChips = transformAndTruncateRange(combined.map((e) => e['data1'] as int).toList(),);
  nextChips = transformAndTruncateRange(combined.map((e) => e['data2'] as int).toList(),);
  valueDisplayPrev = transformAndRoundOriginal(combined.map((e) => e['data1'] as int).toList());
  valueDislay = transformAndRoundOriginal(combined.map((e) => e['data2'] as int).toList());

  final List<double> positionXCombined = syncDefautLists(positionXs, valueDislay);
  final List<double> positionYCombined = syncDefautLists(positionYs, valueDislay);
  chartController.updateChartData(
      newInputNumbers: inputNumber,
      newInitialChips: initialChips,
      newNextChips: nextChips,
      newValueDisplay: valueDislay,
      newValueDisplayPrev: valueDisplayPrev,
      newMembers: members,
      newPositionX: positionXCombined,
      newPositionY: positionYCombined,
    );
   context.read<ChartStreamBloc>().add(UpdateChartDataEvent(
                  inputNumbers: inputNumber,
                  initialChips: initialChips,
                  nextChips: nextChips,
                  valueDisplay: valueDislay,
                  valueDisplayPrev: valueDisplayPrev,
                  members: members,
                  positionX: positionXs, // Now correctly updated
                  positionY: positionYs, // Now correctly updated
    ));
}
}
