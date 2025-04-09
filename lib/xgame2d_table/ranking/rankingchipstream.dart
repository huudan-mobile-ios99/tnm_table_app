import 'dart:async';
import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tournament_client/utils/functions.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/lib/socket/socket_manager.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/widget/text.dart';
import 'package:tournament_client/xgame2d_table/chart/getx/chartControllerRanking.dart';

// ignore: must_be_immutable
class RankingChipStreamPage extends StatefulWidget {
  const RankingChipStreamPage({
    Key? key,
  }) : super(key: key);
  @override
  State<RankingChipStreamPage> createState() => _RankingChipStreamPageState();
}

class _RankingChipStreamPageState extends State<RankingChipStreamPage> {
  IO.Socket? socket;
  SocketManager? mySocket;
  late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final ChartControllerRanking controller = Get.put(ChartControllerRanking());

  @override
  void initState() {
    super.initState();
    debugPrint('Ranking Chip Stream Page');
    mySocket = SocketManager();
    mySocket!.initSocket();
    socket = mySocket!.socket;
    mySocket!.dataStream2.listen((List<Map<String, dynamic>> newData) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    socket?.disconnect(); // Ensure socket is not null before disconnecting
    mySocket?.disposeSocket();
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return StreamBuilder<List<Map<String, dynamic>>>(
              stream:mySocket!.dataStream2,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: .5, color: MyColor.white),
                  );
                }
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty ||
                      snapshot.data == null ||
                      snapshot.data == []) {
                      return const Text('No Data');
                  }
                  final List<Map<String, dynamic>>? data = snapshot.data;
                  final List<String> names = data![0]['name'].cast<String>();
                  final List <String> updatedNames = names.map((name) => name).toList();
                  final List<String> times = data[0]['time'].cast<String>();
                  final List<int> numbers = data[0]['number'].map<int>((number) => int.tryParse(number.toString()) ?? 0).toList();
                  final List<List<double>> dataField = List<List<double>>.from( data[0]['data'].map<List<double>>((item) =>List<double>.from(item.map((value) => value.toDouble()))));
              debugPrint('RankingChipStreamPage updatedNames: $updatedNames');
              debugPrint('RankingChipStreamPage numbers: $numbers');
              debugPrint('RankingChipStreamPage dataField: $dataField');

              controller.updateChartDataRanking(
                  newInputNumbers: numbers,
                  newInitialChips: transformAndTruncateRangeForRanking(dataField[1]),
                  newNextChips: transformAndTruncateRangeForRanking(dataField[2]),
                  newValueDisplay: transformAndRoundOriginal(dataField[2].map((e) => e.toInt() ?? 0).toList()),
                  newValueDisplayPrev: transformAndRoundOriginal(dataField[1].map((e) => e.toInt() ?? 0).toList()),
                  newMembers: numbers,
              );
              return  GetBuilder<ChartControllerRanking>(builder: (controller) {
                return Stack(
                  children: [
                  SizedBox(
                  height: height, // Ensure it has a height
                  width: width, // Ensure it has a width
                  child: ListView.builder(
                  itemCount: updatedNames.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                  int reversedIndex = updatedNames.length - 1 - index;
                  if (reversedIndex < 0 || reversedIndex >= controller.gameInstances.length) {
                    return const SizedBox(); // Avoids out-of-bounds errors
                  }
                  return SizedBox(
                    width: width / 10,
                    height: height,
                    child: GameWidget(
                      key: ValueKey(controller.gameInstances[reversedIndex].index),
                      game: controller.gameInstances[reversedIndex],
                    ),
                  );
                },) ),
                //View Data Saved
                // Positioned(
                //   top: 16,left:16,
                //   child: textcustomColor(
                //     size:MyString.padding24,
                //     color:MyColor.white,text:"${controller.members}"))
                ],);
              },);

    } else if (snapshot.hasError) {
      return const Center(child: Text('An Error Orcur'));
    } else {
      return const Center(child: CircularProgressIndicator( strokeWidth: .5, color: MyColor.white),
    );}},
    );
  }

}




