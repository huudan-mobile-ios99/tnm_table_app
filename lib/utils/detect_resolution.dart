import 'package:tournament_client/utils/mystring.dart';

//HEIGHT
double detectResolutionHeight({input}) {
  final spacing =  (MyString.DEFAULT_ROW * MyString.DEFAULT_SPACING_LING) / input;
  final double height = ((MyString.DEFAULT_HEIGHT_LINE * MyString.DEFAULT_ROW +  MyString.DEFAULT_SPACING_LING * MyString.DEFAULT_ROW) - (spacing * MyString.DEFAULT_ROW)) / input;
  final double heightOver10 =  ((MyString.DEFAULT_HEIGHT_LINE*MyString.DEFAULT_ROW)+(MyString.DEFAULT_SPACING_LING*MyString.DEFAULT_ROW) - input * spacing) / input;
  if (input <= 5) {
    const value = MyString.DEFAULT_HEIGHT_LINE * 1.075;
    // const value = MyString.DEFAULT_HEIGHT_LINE * 1.75;
    // debugPrint('height <5: ${value}');
    return value;
  } else if (input <= 10) {
    // debugPrint('height <=10: ${height}');
    return heightOver10;
  } else if (input > 10 && input <= 20) {
    // debugPrint('height 10->20: $height');
    return heightOver10;
  } else {
    // debugPrint('height: >20: $height');
    //will set up a specific rule for height
    return heightOver10;
  }
}

//SPACING
double? detectResolutionSpacing({input}) {
  final spacing = ((MyString.DEFAULT_ROW * MyString.DEFAULT_SPACING_LING)) / input;
  if (input <= 5) {
    const value = MyString.DEFAULT_SPACING_LING * 2.65;
    // const value = MyString.DEFAULT_SPACING_LING * 1.75;
    // debugPrint('height <5: ${value}');
    return value;
  } else if (input <= 10) {
    const value = MyString.DEFAULT_SPACING_LING * 1;
    // debugPrint('spacing <=10 ${spacing}');
    return spacing;
  } else if (input > 10 && input <= 20) {
    // debugPrint('spacing 10->20: $spacing');
    return spacing;
  } else {
    // debugPrint('spacing >20 $spacing');
    return spacing;
  }
}

//OFFSET
double? detectResolutionOffsetX({input}) {
  double offsetX = (MyString.DEFAULT_OFFSETX_TEXT_VERTICAL / input) * MyString.DEFAULT_ROW;
  if (input <= 5) {
    // debugPrint('offsetX <=5 ${MyString.DEFAULT_OFFSETX_TEXT + offsetX * 2}');
    return MyString.DEFAULT_OFFSETX_TEXT_VERTICAL  + offsetX * 2;
  } else if (input <= 10) {
    // debugPrint('offsetX <=10 ${MyString.DEFAULT_OFFSETX_TEXT + offsetX}');
    return MyString.DEFAULT_OFFSETX_TEXT_VERTICAL + offsetX * 1.5;
  } else if (input > 10 && input <= 20) {
    const value = 0.0;
    // debugPrint('offsetX 10->20: $value');
    return value;
  } else {
    // debugPrint('offsetX: >20: $offsetX');
    //will set up a specific rule for height
    return offsetX;
  }
}





// double detectSpacingHeight({input, isSpacing, isHeight}) {
//   if (isSpacing == true && isHeight == false) {
//     final result = (40 * 34 * 10) / (input * 40);
//     debugPrint('spacing: $result');
//     return result;
//   } else if (isSpacing == false && isHeight == true) {
//     final spacing = (40 * 34 * 10) / (input * 40);
//     final result = (40 * 34 * 10) / (input * spacing);
//     debugPrint('height: $result');
//     return result;
//   } else {
//     return MyString.DEFAULT_HEIGHT_LINE;
//   }
// }
