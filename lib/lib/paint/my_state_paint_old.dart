import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tournament_client/lib/models/rectangle.dart';
import 'package:tournament_client/service/format.factory.dart';
import 'package:tournament_client/utils/mycolors.dart';
import 'package:tournament_client/utils/mystring.dart';

class MyStatePaint extends CustomPainter {
  final List<Rectangle> currentState;
  final double maxValue;
  final double rectHeight;
  final double totalWidth;
  final int numberOfRactanglesToShow;
  final double spaceBetweenTwoRectangles;
  final double offset_text;
  final double offset_title;
  final String title;
  final int? index;
  final TextStyle titleTextStyle;

  // rectangle paint
  final Paint rectPaint;
  // lines paint
  final Paint linePaint;

  // the lenth of the maximum value
  double? maxLength;
  MyStatePaint({
    required this.currentState,
    required this.maxValue,
    required this.numberOfRactanglesToShow,
    required this.totalWidth,
    required this.rectHeight,
    required this.spaceBetweenTwoRectangles,
    required this.offset_text,
    required this.offset_title,
    required this.title,
    this.index,
    required this.titleTextStyle,
    // required this.rectPaint,
    // required this.linePaint,
    required this.maxLength,
  })  : rectPaint = Paint(),
        linePaint = Paint() {
    // proporties for rectangle paint
    rectPaint.style = PaintingStyle.fill;
    rectPaint.strokeWidth = 0;
    rectPaint.strokeCap = StrokeCap.round;
    // proporties for lines paint
    linePaint.color = Colors.grey;
    linePaint.style = PaintingStyle.stroke;
    linePaint.strokeWidth = .5;
    linePaint.strokeCap = StrokeCap.round;
    maxLength = kIsWeb ? totalWidth * 0.865 : totalWidth * 0.835;
  }
    final double yShift = 55;
    final double xShift = 80;
    // define text painter to paint text (write text)



  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final TextStyle textStyle = GoogleFonts.bebasNeue(
    color: MyColor.white,
    fontSize: kIsWeb ? MyString.DEFAULT_TEXTSIZE_WEB : MyString.DEFAULT_TEXTSIZE,
    // fontSize: kIsWeb ? 29.0 : 24.0,
  );
  final TextStyle textStyleLabel = GoogleFonts.bebasNeue(
    color: MyColor.yellow3,
    // color: MyColor.red_text2,
    fontSize: kIsWeb ? MyString.DEFAULT_TEXTSIZE_WEB : MyString.DEFAULT_TEXTSIZE,
    // fontSize: kIsWeb ? 29.0 : 24.0,
  );

  final TextStyle textStyleDrawLine = GoogleFonts.nunito(
    color: Colors.grey,
    fontSize:  kIsWeb ? MyString.DEFAULT_TEXTSIZE_DRAWLINE_WEB : MyString.DEFAULT_TEXTSIZE_DRAWLINE,
  );

  // define text painter to paint title
  final TextPainter titlePainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  final TextStyle textStyleBold = GoogleFonts.playfairDisplay(
    color: Colors.black,
    // fontSize: kIsWeb ? 24.0 : 18.0,
    fontSize: kIsWeb ? MyString.DEFAULT_TEXTSIZE_WEB : MyString.DEFAULT_TEXTSIZE,
    textBaseline: TextBaseline.alphabetic,
    fontWeight: FontWeight.bold,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // print('access paint $index');
    canvas.translate(xShift, yShift);
    // draw title if not null
    _drawTitle(canvas, title);
    // first we draw the line under the ractangles
    _drawLines(canvas, spaceBetweenTwoRectangles);
    // we draw the rectangles
    for (int i = 0; i < currentState.length; i++) {
      _drawRectangle(
          Rectangle(
              position: currentState[i].position,
              length: currentState[i].length,
              color: i == index ? MyColor.yellow : MyColor.white,
              value: currentState[i].value,
              maxValue: maxValue,
              label: currentState[i].label,
              stateLabel: currentState[i].stateLabel),
          canvas,
          spaceBetweenTwoRectangles,
          offset_text,
          offset_title);
    }

    

    // draw current state label
    String stateLabel = currentState[0].stateLabel;

    _drawStateLabel(canvas, size, stateLabel);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // TODO test this
  void _drawStateLabel(Canvas canvas, Size size, String label) {
    // draw value (text)
    textPainter.text = TextSpan(
      text: label,
      style: textStyleBold,
    );
    double x = totalWidth;
    double y = rectHeight * numberOfRactanglesToShow;
    // print(y);
    canvas.save();
    textPainter.layout();
    canvas.translate(x, y);
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.width,
        textPainter.height,
      ),
    );
    canvas.restore();
  }

  void _drawTitle(Canvas canvas, String title) {
    // draw the title of the chart
    textPainter.text = TextSpan(
      text: title,
      style: titleTextStyle ?? textStyleBold,
    );
    double x = totalWidth / 2;
    double y = -40;
    // double y = -50;
    // double y = -60;
    canvas.save();
    textPainter.layout();
    canvas.translate(x, y);
    // canvas.translate(x, y + 2.5);
    // canvas.translate(x, y + 9);
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.width / 2,
        -textPainter.height / 2,
      ),
    );
    canvas.restore();
  }

  void _drawRectangle(
      Rectangle rect,
      Canvas canvas,
      double spaceBetweenTwoRectangles,
      double offsetxText,
      double offsetxTitle) {
    // draw rectangle
    final gradient = LinearGradient(
    colors: [rect.color, MyColor.yellowMain], // Adjust colors as needed
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    );

    // draw rectangle
    Path path = Path();
    double maxHeight = numberOfRactanglesToShow * (rectHeight + spaceBetweenTwoRectangles) - spaceBetweenTwoRectangles;
    // define postitons of the four corner to draw the rectangle
    double x1 = 0, y1 = rect.position * (rectHeight + spaceBetweenTwoRectangles);
    // if the rectancles if outside, we don't draw it
    if (y1 >= maxHeight) return;
    // min is to draw a rectangle partially, (in case it's showning up or hiding)
    double x2 = rect.length * maxLength!, y2 = min(y1 + rectHeight, maxHeight);

    path.moveTo(x1, y1);
    path.lineTo(x2, y1);
    path.lineTo(x2, y2);
    path.lineTo(x1, y2);
    rectPaint.color = rect.color;
    canvas.drawPath(path, rectPaint);


  //APPY GRADIENT AND BORDER RADIUS:
  double borderRadius = MyString.DEFAULT_BORDERRADIUS; // Customize as needed
  RRect rrect = RRect.fromRectAndRadius(
    Rect.fromPoints(Offset(x1, y1), Offset(x2, y2)),
    Radius.circular(borderRadius),
  );
  rectPaint.shader = gradient.createShader(Rect.fromPoints(Offset(x1, y1), Offset(x2, y2)));
    // Draw the rounded rectangle
  canvas.drawRRect(rrect, rectPaint);
  //END HERE


    // draw value (text)
    String value = rect.value.round().toString();
    if (value.length > 5) {
      value = "${value.substring(0, 5)}..";
    }
    textPainter.text = TextSpan(
      // text: '\$${(double.parse(value)).toStringAsFixed((double.parse(value)).truncateToDouble() == double.parse(value) ? 0 : 2)}',
      text: (formatAsCurrency(double.parse(value))),
      // text: '\$${(double.parse(value))}',
      // text:formatAsCurrency(double.parse(value)),
      style: textStyleLabel,
    );
    canvas.save();
    textPainter.layout();
    canvas.translate(x2, y1 + offset_text);
    // canvas.translate(x2, y1 + MyString.DEFAULT_OFFSETX_TEXT);
    // canvas.translate(x2, y1 + 9);
    textPainter.paint(
      canvas,
      const Offset(
        MyString.DEFAULT_OFFSETX,
        0,
      ),
    );
    canvas.restore();

    // draw the title for each rectangle
    String label = rect.label;
    if (label.length > 11) {
      label = "${label.substring(0, 9)}..";
    }
    textPainter.text = TextSpan(
      text: label,
      style: textStyle,
    );
    canvas.save();
    textPainter.layout();
    canvas.translate(0 - 9, y1 + offset_title);
    // canvas.translate(0 - 9, y1 + MyString.DEFAULT_OFFSETX_TITLE);
    // canvas.translate(0 - 9, y1 + 9);
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.width - 2,
        0,
      ),
    );
    canvas.restore();
  }

  // draw the lines with the respective value based on the current maximum value
  void _drawLines(Canvas canvas, double spaceBetweenTwoRectangles) {
    double lastDigit = maxValue;
    double p = 1;
    while (lastDigit >= 10) {
      lastDigit = lastDigit / 10.0;
      p *= 10;
    }
    double step;
    if (lastDigit < 3) {
      step = 0.5 * p / maxValue * maxLength!;
    } else {
      step = 2 * p / maxValue * maxLength!;
    }
    double posX = step;
    while (posX <= totalWidth) {
      double value = posX / maxLength! * maxValue;
      _drawLine(canvas, posX, value.round(), spaceBetweenTwoRectangles);
      posX += step;
    }
  }

  void _drawLine(
      Canvas canvas, double posX, int value, double spaceBetweenTwoRectangles) {
    Path path = Path();
    // define the two point of the line
    double x1 = posX, y1 = 0;
    double x2 = posX,
        y2 = numberOfRactanglesToShow *
                (rectHeight + spaceBetweenTwoRectangles) -
            spaceBetweenTwoRectangles;
    path.moveTo(x1, y1);
    path.lineTo(x2, y2);
    canvas.drawPath(path, linePaint);
    // draw the value (text)
    textPainter.text = TextSpan(
      text: value.round().toString(),
      style: textStyleDrawLine,
    );
    canvas.save();
    textPainter.layout();
    canvas.translate(x1, y1);
    textPainter.paint(
      canvas,
      Offset(-(textPainter.width / 2), -(textPainter.height)),
    );
    canvas.restore();
  }

  double min(double a, double b) {
    return a < b ? a : b;
  }
}
