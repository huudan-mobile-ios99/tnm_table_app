import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:tournament_client/utils/mystring.dart';
import 'models/rectangle.dart';
import 'paint/my_state_paint.dart';
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/lib/getx/controller.get.dart';

/// Creates an interactive bar chart depending on the provided [data], which looks like a race
///
/// [data] should be a matrix of double with at least two columns and two rows, and stores data in cumulative way
/// [initialPlayState] if true then the bar chart will be animated, else it will show the first row of data and stop
/// [framesPerSecond] defines the number of frames to show per seconds
/// [columnsLabel] represents the name of the columns
/// [statesLabel] represents the name of the rows (usually time)
/// [numberOfRactanglesToShow] represents the number of the first columns to show
/// [title] title of the bar chart race
/// [columnsColor] the color of each column
class BarChartRace extends StatefulWidget {
  /// each row represents a state and each column represents one instance
  /// data should contains at least two rows and two columns, else it's not logic
  /// data should be cumulative
  final List<List<double>> data;

  /// if it's true then the bar chart will be animated
  final bool initialPlayState;

  /// number of frame to show in one second
  final double framesPerSecond;

  /// represent the number of frames to show between two states (two consecutive rows)
  final int framesBetweenTwoStates;

  /// a list of labels for each column.
  /// length of the this list show be equals to the number of columns of [data].
  ///
  /// for examle if you are going to study countries provides the list of countries with the same order as the columns in data.
  final List<String> columnsLabel;

  /// one label for each state.
  /// if your state is the time you need to prodive the time of each state
  /// length of [stateLabels] list should be equal to the number of rows in [data].
  final List<String> statesLabel;

  /// number of rectangles to show in the UI.
  ///
  /// For example if you are studying ten countries, you can show the first five countries only
  /// by default it equals to the number of columns in the data
  final int numberOfRactanglesToShow;

  /// a color for each column,
  ///
  /// for example if you are studying countries, you can assign to each country a color
  /// colors should be ordred as the column in the [data]
  /// by default it uses random colors
  final List<Color>? columnsColor;

  /// represent the title of the chart
  final String title;

  /// the styling for the text
  final TextStyle titleTextStyle;

  /// the height of the rectangle
  final double rectangleHeight;
  final int? index;
  final int? selectedIndex;
  final double? spaceBetweenTwoRectangles;
  final double? offset_text;
  final double? offset_title;

  const BarChartRace({
    Key? key,
    required this.data,
    required this.selectedIndex,
    this.index,
    required this.initialPlayState,
    this.framesPerSecond = 35,
    this.framesBetweenTwoStates = 40,
    // //vegas setting
    // this.rectangleHeight = 45,

    //vegas plaza setting
    this.rectangleHeight = 18,
    this.numberOfRactanglesToShow = 5,
    required this.columnsLabel,
    required this.statesLabel,
    this.columnsColor,
    required this.title,
    required this.titleTextStyle,
    required this.spaceBetweenTwoRectangles,
    required this.offset_text,
    required this.offset_title,
  }) : super(key: key);

  @override
  _BarChartRaceState createState() => _BarChartRaceState();
}

class _BarChartRaceState extends State<BarChartRace> {
  int? nbStates;
  int? nbParticipants;
  // data of preprocessing the initial data
  List<List<Rectangle>>? preparedData;
  // current data to show
  List<Rectangle>? currentData;

  //addtion from Dan
  TextEditingController? controller = TextEditingController();
  final controllerGetX = Get.put(MyGetXController());

  @override
  void initState() {
    // init local variables`
    nbStates = widget.data.length;
    nbParticipants = widget.data[0].length;
    // prepare data to be shown in the customPainer
    preparedData = prepareData(widget.data);
    currentData = preparedData![0];
    if (widget.initialPlayState) play();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant BarChartRace oldWidget) {
    if (oldWidget.data != widget.data) {
      debugPrint('didUpdateWidget: BarChartRace');
      // Update the preparedData and currentData based on the new widget.data
      preparedData = prepareData(widget.data);
      // currentData = preparedData![0];
      if (widget.initialPlayState) play();
    }
    super.didUpdateWidget(oldWidget);
  }

  // re-build
  void _update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    // //vegas setting
    // const double paddingVer = kIsWeb ? 60.0 : 16.0;
    //vegas plaza setting
    const double paddingVer = kIsWeb ? MyString.padding36 : MyString.padding16;
    const double paddingHozLeft = kIsWeb ? MyString.padding36 : MyString.padding12;
    const double paddingHozRight = kIsWeb ? MyString.padding16 : MyString.padding12;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: height,
          width: width,
          decoration:  const BoxDecoration(
          // border: Border.all(color: Colors.transparent), // Optional: set a transparent border or any other color
        ),
          padding: const EdgeInsets.only(
            left: paddingHozLeft,
            right: paddingHozRight,
            top: paddingVer,
            bottom: paddingVer,
          ),
          child: LayoutBuilder(
            builder: (_, constraints) => CustomPaint(
              painter: MyStatePaint(
                index: widget.index,
                currentState: currentData!,
                numberOfRactanglesToShow: widget.numberOfRactanglesToShow,
                rectHeight: widget.rectangleHeight,
                offset_text: widget.offset_text!,
                offset_title: widget.offset_title!,
                spaceBetweenTwoRectangles: widget.spaceBetweenTwoRectangles!,
                maxValue: currentData![0].maxValue,
                totalWidth: kIsWeb
                    ? constraints.maxWidth * .925
                    : constraints.maxWidth * .925,
                    // ? constraints.maxWidth * .885
                    // : constraints.maxWidth * .835,
                title: widget.title,
                titleTextStyle: widget.titleTextStyle,
                maxLength: null,
              ),
            ),
          ),
        )
        );
  }

  void play() async {
    for (int i = 1; i < nbStates!; i++) {
      await makeTransition(preparedData![i - 1], preparedData![i]);
    }
  }

  Future<void> makeTransition(List<Rectangle> before, List<Rectangle> after) async {
    int nbFrames = widget.framesBetweenTwoStates;
    int fps = widget.framesBetweenTwoStates;

    for (int k = 1; k <= nbFrames; k++) {
      // for each frame we update the current value
      for (int i = 0; i < nbParticipants!; i++) {
        // get the difference between two states
        double posDiff = (after[i].position - before[i].position) / nbFrames;
        double lengthDiff = (after[i].length - before[i].length) / nbFrames;
        double valueDiff = (after[i].value - before[i].value) / nbFrames;
        double maxValueDiff =  (after[i].maxValue - before[i].maxValue) / nbFrames;
        // add the new differences
        currentData![i].length = before[i].length + lengthDiff * k;
        currentData![i].position = before[i].position + posDiff * k;
        currentData![i].value = before[i].value + valueDiff * k;
        currentData![i].maxValue = before[i].maxValue + maxValueDiff * k;
        // upadte the labels
        if ((widget.columnsLabel.length ?? 0) > 0) {
          currentData![i].label = widget.columnsLabel[i];
        }
        if ((widget.statesLabel.length ?? 0) > 0) {
          currentData![i].stateLabel = before[i].stateLabel;
        }
      }
      // rebuild the UI
      _update();
      await Future.delayed(Duration(milliseconds: 3000 ~/ fps));
    }
  }

  // prepare data so that it can be shown,
  List<List<Rectangle>> prepareData(List<List<double>> data) {
    List<List<Rectangle>> resultData = [];
    // for each state (a row from data), we sort row without modifying by using anothe list of indexes
    for (int i = 0; i < nbStates!; i++) {
      List<int> indexes = List.generate(nbParticipants!, (index) => index);
      // sort the indexes in deceasing order based on the data in the row
      indexes.sort((int a, int b) {
        return data[i][b].compareTo(data[i][a]);
      });
      // get the max value, which is in the first index
      double maxValue = data[i][indexes[0]];
      // List<Rectangle> currentState = List(nbParticipants);
      List<Rectangle> currentState = List<Rectangle>.filled(
        nbParticipants ?? 0,
        Rectangle(
          maxValue: 0, // Provide appropriate values here
          length: 0,
          position: 0,
          value: 0,
          color: MyColor.blue,
          stateLabel: '',
          label: '',
        ),
      );
      for (int j = 0; j < nbParticipants!; j++) {
        int index = indexes[j];
        Color randomColor = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);
        // create the Rectable object which will be used to draw the chart
        currentState[index] = Rectangle(
          maxValue: maxValue,
          length: data[i][index] / maxValue,
          position: 1.0 * j,
          value: data[i][index],
          color: widget.columnsColor == null
              ? index != widget.index
                  ? MyColor.white
                  : MyColor.tealText
              : widget.columnsColor![index],
          stateLabel: widget.statesLabel[i],
          label: widget.columnsLabel[index],
        );
      }
      resultData.add(currentState);
    }
    return resultData;
  }
}
