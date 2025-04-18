library bar_chart_race;

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'dart:math' as math;
import 'models/rectangle.dart';
import 'paint/my_state_paint.dart';

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
class BarChartRaceCopy extends StatefulWidget {
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
  final List<Color> columnsColor;

  /// represent the title of the chart
  final String title;

  /// the styling for the text
  final TextStyle titleTextStyle;

  /// the height of the rectangle
  final double rectangleHeight;
  final double offset_text;
  final double offset_title;

  const BarChartRaceCopy({
    Key? key,
    required this.data,
    required this.initialPlayState,
    this.framesPerSecond = 20,
    this.framesBetweenTwoStates = 40,
    this.rectangleHeight = 27,
    this.numberOfRactanglesToShow = 5,
    required this.columnsLabel,
    required this.statesLabel,
    required this.columnsColor,
    required this.title,
    required this.titleTextStyle,
    required this.offset_text,
    required this.offset_title,
  }) : super(key: key);

  @override
  _BarChartRaceCopyState createState() => _BarChartRaceCopyState();
}

class _BarChartRaceCopyState extends State<BarChartRaceCopy> {
  int? nbStates;
  int? nbParticipants;
  // data of preprocessing the initial data
  List<List<Rectangle>>? preparedData;
  // current data to show
  List<Rectangle>? currentData;

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
  void didUpdateWidget(covariant BarChartRaceCopy oldWidget) {
    if (oldWidget.data != widget.data) {
      // Update the preparedData and currentData based on the new widget.data
      preparedData = prepareData(widget.data);
      currentData = preparedData![0];
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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () {
              _update();
            }),
        body: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.all(32),
          child: LayoutBuilder(
            builder: (_, constraints) => CustomPaint(
              painter: MyStatePaint(
                spaceBetweenTwoRectangles: kIsWeb ? 32 : 22,
                currentState: currentData!,
                numberOfRactanglesToShow: widget.numberOfRactanglesToShow,
                offset_text: widget.offset_text,
                offset_title: widget.offset_title,
                rectHeight: widget.rectangleHeight,
                maxValue: currentData![0].maxValue,
                totalWidth: constraints.maxWidth * .9,
                title: widget.title,
                titleTextStyle: widget.titleTextStyle,
                maxLength: 180,
              ),
            ),
          ),
        ));
  }

  void play() async {
    for (int i = 1; i < nbStates!; i++) {
      await makeTransition(preparedData![i - 1], preparedData![i]);
    }
  }

  Future<void> makeTransition(
      List<Rectangle> before, List<Rectangle> after) async {
    int nbFrames = widget.framesBetweenTwoStates;
    int fps = widget.framesBetweenTwoStates;

    for (int k = 1; k <= nbFrames; k++) {
      // for each frame we update the current value
      for (int i = 0; i < nbParticipants!; i++) {
        // get the difference between two states
        double posDiff = (after[i].position - before[i].position) / nbFrames;
        double lengthDiff = (after[i].length - before[i].length) / nbFrames;
        double valueDiff = (after[i].value - before[i].value) / nbFrames;
        double maxValueDiff =
            (after[i].maxValue - before[i].maxValue) / nbFrames;
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
      await Future.delayed(Duration(milliseconds: 1000 ~/ fps));
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
          color: Colors.black,
          stateLabel: '',
          label: '',
        ),
      );

      for (int j = 0; j < nbParticipants!; j++) {
        int index = indexes[j];
        // generate a random color to use in case the colors are not provided
        Color randomColor =
            Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0);
        // create the Rectable object which will be used to draw the chart
        currentState[index] = Rectangle(
          maxValue: maxValue,
          length: data[i][index] / maxValue,
          position: 1.0 * j,
          value: data[i][index],
          color: widget.columnsColor == null
              ? randomColor
              : widget.columnsColor[index],
          // ignore: unnecessary_null_comparison
          // stateLabel: widget.statesLabel != null ? widget.statesLabel[i] : null,
          // label:widget.columnsLabel != null ? widget.columnsLabel[index] : null,
          stateLabel: widget.statesLabel[i],
          label: widget.columnsLabel[index],
        );
      }
      resultData.add(currentState);
    }
    return resultData;
  }
}
