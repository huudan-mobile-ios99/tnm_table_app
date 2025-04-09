import 'dart:math' as math;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tournament_client/lib/bar_chart.widget.dart';
import 'package:tournament_client/utils/mycolors.dart';


List<Color> shuffleColorList() {
  final random = Random();
  const sublistLength = 10;
  // Make sure the sublist length doesn't exceed the length of the color list
  final shuffledList = colorList.sublist(0, sublistLength)..shuffle(random);
  // Create a new list with the shuffled sublist
  final newList = List<Color>.from(colorList);
  for (int i = 0; i < sublistLength; i++) {
    newList[i] = shuffledList[i];
  }
  return newList;
}

String formatNumberWithCommas(num number) {
  var formatter = NumberFormat('#,##0.###'); // Adjusted to handle decimals
  return formatter.format(number);
}


List<List<double>> generateGoodRandomData(int nbRows, int nbColumns) {
  List<List<double>> data = List.generate(nbRows, (index) => List<double>.filled(nbColumns, 0));
  for (int j = 0; j < nbColumns; j++) {
    data[0][j] = j * 10.0;
  }
  for (int i = 1; i < nbRows; i++) {
    for (int j = 0; j < nbColumns; j++) {
      double calculatedValue = data[i - 1][j] + (nbColumns - j) + math.Random().nextDouble() * 20 + (j == 2 ? 10 : 0);
      data[i][j] = calculatedValue;
      // print('calculate value: $calculatedValue');
    }
  }
  // print(data);
  return data;
}

List<List<double>> generateChartData(List<List<double>> inputData) {
  List<List<double>> data = List.generate(
      inputData.length, (index) => List<double>.filled(inputData[0].length, 0));

  for (int i = 0; i < inputData.length; i++) {
    for (int j = 0; j < inputData[i].length; j++) {
      data[i][j] = inputData[i][j];
    }
  }

  return data;
}

List<List<double>> generateGoodRandomData2(int nbRows, int nbColumns) {
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
    }
    // Shuffle the values in the current row
    data[i].shuffle();
  }
  // print('data shufffe $data');
  return data;
}

int detect(double targetIndex, List<double> myList) {
  for (int i = 0; i < myList.length; i++) {
    if (myList[i] == targetIndex) {
      debugPrint('index $i');
      return i;
    }
  }
  return -1; // Return -1 if the index is not found in the list
  }

List<Color> changeList(int index) {
  if (index < 0 || index >= 10) {
    throw ArgumentError('Invalid index. Index should be between 0 and 9.');
  }

  List<Color> colorList = List.generate(10, (i) => MyColor.orang3);
  colorList[index] = MyColor.green_araconda;
  return colorList;
}

List<Color> colorList = [
  MyColor.green_araconda,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
  MyColor.orang3,
];

class FormattedDataText extends StatelessWidget {
  final List<List<double>> formattedData;

  const FormattedDataText({Key? key, required this.formattedData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$formattedData');
  }
}

// ignore: unused_element
Future<void> _refresh(socket) async {
  socket!.emit('eventFromClient');
}

int detectInt(List<int> numbers, List<String> times, double targetNumber,
    List<int> myList) {
  DateTime latestTime = DateTime(2000); // An arbitrary initial date

  int latestIndex = -1; // Initialize with an invalid index

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == targetNumber) {
      final String timeStr = times[i];
      final DateTime time = DateTime.parse(timeStr);

      if (time.isAfter(latestTime)) {
        latestTime = time;
        latestIndex = i;
      }
    }
  }
  // print('latestIndex $latestIndex');
  // return latestIndex;

  for (int i = 0; i < myList.length; i++) {
    if (myList[i] == targetNumber) {
      // print('index $i');
      debugPrint('index in list: $i');
      return i;
    }
  }

  return -1; // Return -1 if the index is not found in the list
}

int findLatestTimeIndexForNumber(
    List<int> numbers, List<String> times, int targetNumber) {
  DateTime latestTime = DateTime(2000); // An arbitrary initial date

  int latestIndex = -1; // Initialize with an invalid index

  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] == targetNumber) {
      final String timeStr = times[i];
      final DateTime time = DateTime.parse(timeStr);

      if (time.isAfter(latestTime)) {
        latestTime = time;
        latestIndex = i;
      }
    }
  }
  debugPrint('latestIndex $latestIndex');
  return latestIndex;
}


///THIS IS CONVERTING OR CREATE 2D CHART DATA ** IMPORTANCE **
List<List<double>> generateNewData(List<List<double>> existingData) {
  if (existingData.isEmpty) {
    return existingData;
  }

  int nbRows = existingData.length;
  int nbColumns = existingData[0].length;

  // Create a new 2D list to store the generated data
  List<List<double>> newData =
      List.generate(nbRows, (index) => List<double>.filled(nbColumns, 0));

  // Set initial values for the first row based on the existing data
  for (int j = 0; j < nbColumns; j++) {
    newData[0][j] =
        existingData[0][j] * 0.00000001; // Adjust the multiplier as needed
  }

  // Copy the last row from the existing data to the second row in the new data
  for (int j = 0; j < nbColumns; j++) {
    newData[1][j] = existingData.last[j];
  }

  // Generate random data for the remaining rows
  for (int i = 2; i < nbRows; i++) {
    for (int j = 0; j < nbColumns; j++) {
      double calculatedValue = newData[i - 1][j] +
          (nbColumns - j) +
          math.Random().nextDouble() * 0.00000001 +
          (j == 2 ? 0.00000001 : 0);
      newData[i][j] = calculatedValue;
    }
    // Shuffle the values in the current row
    newData[i].shuffle();
  }

  return newData;
}

List<List<double>> convertData(data) {
  // print('data 2: $data');
  if (data.length == 2) {
    // print('convert data 2 : $data ');
    return [data.last];
  } else if (data.length == 3) {
    // print('convert data 3: $data ');
    return [data[1], data.last];
  }

  return data;
}


List<String> listLabelGenerate() {
  return List.generate(
    30,
    (index) => formatDate(
      DateTime.now().add(
        Duration(days: index),
      ),
    ),
  );
}




bool validateFields(
    TextEditingController controllerName,
    TextEditingController controllerNumber,
    TextEditingController controllerPoint) {
  // Check if any of the text controllers is null or empty
  if (controllerName.text.isEmpty ||
      controllerNumber.text.isEmpty ||
      controllerPoint.text.isEmpty) {
    return false;
  }

  // Check if the "point" field has a value greater than 0
  if (double.tryParse(controllerPoint.text)! <= 0) {
    return false;
  }

  // All validation conditions are met
  return true;
}




List<double> syncDefautLists(List<double> defaultList, List<dynamic> dynamicList) {
  while (defaultList.length < dynamicList.length) {
    defaultList.add(0.0); // ✅ Ensure 0.0 is added (not integer 0)
  }
  return List.from(defaultList); // ✅ Return a new list copy to avoid `null`
}



List<int> transformAndRound(List<dynamic> points) {
  return points.map((e) => (e is num) ? (e / 100).round() : 0).toList();
}
List<int> transformAndRound2(List<dynamic> points) {
  return points.map((e) => (e is num) ? (e * 10).round() : 0).toList();
}



final List<int> rangePoints = [
    100, 200, 300, 400, 500, 600, 700, 800, 900, 1000,
    1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000, 3250, 3500,
    3750, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000,
    8500, 9000, 9500, 10000, 12500, 15000, 17500, 20000, 22500,
    25000, 27500, 30000, 35000, 40000, 50000, 75000, 100000
  ];
const int maxLength = 27;

int transformTruncateNumber(num value) {
  // Find the appropriate range
  int selectedRange = rangePoints.firstWhere((r) => value <= r, orElse: () => rangePoints.last);
  int dividePoint = selectedRange ~/ maxLength;
  // Transform value
  int result = value ~/ dividePoint;
  return value >= dividePoint ? result : 0;
}


List<int> transformAndTruncateRange(List<dynamic> points) {
  if (points.isEmpty) return [];
  // Find the max value in the list
  int maxValue = points.whereType<num>().fold<int>(0, (max, e) => e > max ? e.toInt() : max);
  // Find the appropriate dividePoint
  int selectedRange = rangePoints.firstWhere((r) => maxValue <= r, orElse: () => rangePoints.last);
  int dividePoint = selectedRange ~/ maxLength;

  // Apply transformation with proper threshold handling
  return points.map((e) {
    if (e is num) {
      int result = e ~/ dividePoint;
      return e >= dividePoint ? result : 0; // Ensures values < dividePoint stay 0
    }
    return 0;
  }).toList();
}





List<int> transformAndTruncateRangeForRanking(List<dynamic> points) {
  const int maxLength = 100;
  if (points.isEmpty) return [];
  // Find the max value in the list
  int maxValue = points.whereType<num>().fold<int>(0, (max, e) => e > max ? e.toInt() : max);
  // Find the appropriate dividePoint
  int selectedRange = rangePoints.firstWhere((r) => maxValue <= r, orElse: () => rangePoints.last);
  int dividePoint = selectedRange ~/ maxLength;

  // Apply transformation with proper threshold handling
  return points.map((e) {
    if (e is num) {
      int result = e ~/ dividePoint;
      return e >= dividePoint ? result : 0; // Ensures values < dividePoint stay 0
    }
    return 0;
  }).toList();
}





//input 2 list and get max of 2 then compare
List<int> transformAndTruncateRangeMax(List<dynamic> points, List<dynamic> pointsTwo) {
  const int maxLength = 20;
  if (points.isEmpty) return [];

  List<int> rangePoints = [1000, 5000, 10000, 20000, 50000, 100000, 200000, 500000];

  // Find max value from both lists but only transform `points`
  int maxValuePoints = points.whereType<num>().fold<int>(0, (max, e) => e > max ? e.toInt() : max);
  int maxValuePointsTwo = pointsTwo.whereType<num>().fold<int>(0, (max, e) => e > max ? e.toInt() : max);
  int maxValue = maxValuePoints > maxValuePointsTwo ? maxValuePoints : maxValuePointsTwo;

  // Find the appropriate dividePoint
  int selectedRange = rangePoints.firstWhere((r) => maxValue <= r, orElse: () => rangePoints.last);
  int dividePoint = selectedRange ~/ maxLength;

  // Apply transformation to only `points`
  return points.map((e) {
    if (e is num) {
      int result = e ~/ dividePoint;
      return e >= dividePoint ? result : 0; // Keeps values below dividePoint as 0
    }
    return 0;
  }).toList();
}




List<int> transformAndRoundOriginal(List<dynamic> points) {
  return points.map((e) => (e is num) ? (e / 1).round() : 0).toList();
}












