import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_client/xpage/home/home.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'package:tournament_client/utils/functions.dart';
import 'package:tournament_client/lib/bar_chart_race.dart';
import 'package:tournament_client/utils/detect_resolution.dart';
import 'package:tournament_client/lib/socket/socket_manager.dart';


class HomeRealTimePage extends StatefulWidget {
  HomeRealTimePage({
    Key? key,
    required this.url,
    required this.selectedIndex,
    required this.title,
  }) : super(key: key);

  final String title;
  int? selectedIndex;
  final String url;

  @override
  State<HomeRealTimePage> createState() => _HomeRealTimePageState();
}

class _HomeRealTimePageState extends State<HomeRealTimePage> {
  late StreamController<List<Map<String, dynamic>>> streamController = StreamController<List<Map<String, dynamic>>>.broadcast();
  late final SocketManager mySocket = SocketManager();
  late Stream<List<Map<String, dynamic>>> _creditStream;
  late Stream<List<Map<String, dynamic>>> _throttledStream;

  final int durationthrottled = 1000;

  @override
  void initState() {
    super.initState();
    mySocket.initSocket();
    _creditStream = mySocket.dataStream;
    // Assuming your socket stream is _creditStream
  //  _throttledStream = _creditStream.throttleTime(Duration(milliseconds: durationthrottled)); // Update every 500ms
  }

  @override
  void dispose() {
    mySocket.disposeSocket();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top:kIsWeb? MyString.TOP_PADDING_TOPRAKINGREALTIME : 0.0),
        child: SafeArea(
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: mySocket.dataStream,
            // stream: _throttledStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Map<String, dynamic>>? dataList = snapshot.data;
                final List<String> member = dataList![0]['member'].cast<String>();
                final List<dynamic> rawData = dataList[1]['data'];
                final List<List<double>> processData = rawData.map((entry) => entry is List<dynamic>? entry.map(toDoubleFunc).toList(): <double>[]).toList();
                if (snapshot.data!.isEmpty ||
                    snapshot.data == null ||
                    snapshot.data == []) {
                    return const Text('empty data');
                }
                // return Text(' Data: ${processData} ',style:TextStyle(color:MyColor.white));
                return Stack(
                  children: [
                    BarChartRace(
                      selectedIndex: widget.selectedIndex,
                      index: detect(widget.selectedIndex!.toDouble(), processData.first),
                      data: convertData(processData),
                      initialPlayState: true,
                      framesPerSecond: 85.0,
                      framesBetweenTwoStates: 85,
                      spaceBetweenTwoRectangles:detectResolutionSpacing(input: processData.last.length),
                      rectangleHeight:detectResolutionHeight(input: processData.last.length),
                      numberOfRactanglesToShow: processData.last.length, // <= 10
                      offset_text:detectResolutionOffsetX(input: processData.last.length),
                      offset_title:detectResolutionOffsetX(input: processData.last.length),
                      title: "RANKING",
                      columnsLabel: member,
                      statesLabel: listLabelGenerate(),
                      titleTextStyle: GoogleFonts.nunitoSans(
                            color: MyColor.white,
                            fontWeight: FontWeight.w600,
                            fontSize: kIsWeb ? MyString.DEFAULT_TEXTSIZE_WEB_TITLE : MyString.DEFAULT_TEXTSIZE_WEB_TITLE ,
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator( strokeWidth: 1, color: MyColor.white),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
