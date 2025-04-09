import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/utils/functions.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tournament_client/lib/getx/controller.get.dart';
import 'package:tournament_client/utils/detect_resolution.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';

// ignore: must_be_immutable
class HomeTopRankingPage extends StatefulWidget {
  HomeTopRankingPage({
    Key? key,
    required this.url,
    required this.selectedIndex,
    required this.title,
  }) : super(key: key);
  final String title;
  int? selectedIndex;
  final String url;
  @override
  State<HomeTopRankingPage> createState() => _HomeTopRankingPageState();
}

class _HomeTopRankingPageState extends State<HomeTopRankingPage> {
  IO.Socket? socket;
  late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  final controllerGetX = Get.put(MyGetXController());

  @override
  void initState() {
    super.initState();
    print('home mongo test');
    SocketManager().initSocket();
    SocketManager().dataStream2.listen((List<Map<String, dynamic>> newData) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    socket!.disconnect();
    SocketManager().disposeSocket();
    controllerGetX.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    socket!.emit('eventFromClient2');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(
          top: kIsWeb ? MyString.TOP_PADDING_TOPRAKINGREALTIME : 0.0),
          child: SafeArea(
            key: widget.key,
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: SocketManager().dataStream2,
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
                      return const Text('empty data');
                  }
                  final List<Map<String, dynamic>>? data = snapshot.data;
                  final List<String> names = data![0]['name'].cast<String>();
                  final List<String> times = data[0]['time'].cast<String>();
                  final updatedNames = names.map((name) => name).toList();
                  final List<int> numbers = data[0]['number'].map<int>((number) => int.tryParse(number.toString()) ?? 0).toList();
                  debugPrint('list number home mongo test: ${numbers.length}');
                  final List<List<double>> dataField2 = List<List<double>>.from( data[0]['data'].map<List<double>>((item) =>List<double>.from(item.map((value) => value.toDouble()))));
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: Stack(
                      children: [
                        BarChartRace(
                          selectedIndex: widget.selectedIndex,
                          offset_text: detectResolutionOffsetX(input: numbers.length),
                          offset_title: detectResolutionOffsetX(input: numbers.length),
                          spaceBetweenTwoRectangles:detectResolutionSpacing(input: numbers.length),
                          rectangleHeight: detectResolutionHeight(input: numbers.length),
                          // numberOfRactanglesToShow: 10,
                          numberOfRactanglesToShow: numbers.length,
                          index: detectInt(numbers, times,widget.selectedIndex!.toDouble(), numbers),
                          data: convertData(dataField2),
                          initialPlayState: true,
                          framesPerSecond: 145.0,
                          framesBetweenTwoStates: 145,
                          title: "TOP PLAYERS RANKING",
                          columnsLabel: updatedNames,
                          statesLabel: listLabelGenerate(),
                          titleTextStyle: GoogleFonts.nunitoSans(
                            color: MyColor.white,
                            fontWeight: FontWeight.w600,
                            fontSize: kIsWeb ? MyString.DEFAULT_TEXTSIZE_WEB_TITLE : MyString.DEFAULT_TEXTSIZE_WEB_TITLE ,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(child: Text('An error orcur'));
                } else {
                  return const Center(
                    child: CircularProgressIndicator( strokeWidth: .5, color: MyColor.white),
                  );
                }
              },
            ),
          ),
        ));
  }
}

List<List<double>> generateGoodRandomData(int nbRows, int nbColumns) {
  List<List<double>> data =
      List.generate(nbRows, (index) => List<double>.filled(nbColumns, 0));
  for (int j = 0; j < nbColumns; j++) {
    data[0][j] = j * 10.0;
  }
  for (int i = 1; i < nbRows; i++) {
    for (int j = 0; j < nbColumns; j++) {
      double calculatedValue = data[i - 1][j] +
          (nbColumns - j) +
          math.Random().nextDouble() * 20 +
          (j == 2 ? 10 : 0);
      data[i][j] = calculatedValue;
      // print('calculate value: $calculatedValue');
    }
  }
  return data;
}

String removeDecimalZeroFormat(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}
