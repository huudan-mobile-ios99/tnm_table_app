import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:tournament_client/service/format.factory.dart';
import 'dart:async';

import 'package:tournament_client/utils/mystring.dart';

class Chart2DPageRanking extends FlameGame with ChangeNotifier {
  int inputNumber;
  int initialChip;
  int nextChip;
  int valueDisplay;

  int prevInitialChip;
  int prevNextChip;
  int prevValueDisplay;

  bool played;
  int index;
  double positionX;
  double positionY;

  final List<SpriteComponent> chips = [];
  final double chipHeight = 8.5;
  TextComponent? chipCountText;
  TextComponent? inputNumberText;
  final int columns = 5;
  final int maxChipsPerColumn = 95;
  int milisecondAnimate = 30;
  final double spaceBetweenTextChip = 57.5;
  final double widthChip = 70;
  final double heightChip = 65.5;
  Timer? _valueUpdateTimer;


  List<List<SpriteComponent>> chipColumns = List.generate(5, (_) => []);
  List<TextComponent?> chipCountTexts = List.generate(5, (_) => null);
  int members;
  int valueDisplayPrev;
  bool _isLoaded = false; // Prevent redundant execution


  Chart2DPageRanking({
    required this.index,
    required this.inputNumber,
    required this.initialChip,
    required this.nextChip,
    required this.positionX,
    required this.positionY,
    required this.members,
    required this.valueDisplay,
    required this.valueDisplayPrev,
    this.played = false,
  })  : prevInitialChip = initialChip,
        prevNextChip = nextChip,
        prevValueDisplay = valueDisplay;

  @override
  Color backgroundColor() => Colors.transparent;



@override
  Future<void> onLoad() async {
  debugPrint('ONLOAD RUN : $valueDisplay next: $nextChip old: $initialChip');
  if (_isLoaded) {
    debugPrint('onLoad already executed, skipping.');
    return;
  }
  _isLoaded = true; // Mark as executed

  int currentChipCount = chips.length;
  // // Only update if the chip count needs to change
  if (nextChip > currentChipCount) {
    increaseChipsBy(nextChip - currentChipCount);
  } else if (nextChip < currentChipCount) {
    decreaseChipsBy(-(currentChipCount - nextChip));
  }

  updateChipCountText();
  updateInputNumberPosition();
  addInputNumberText('0');   //replace this show by animate

}




void increaseChipsBy(int amount) {
int availableSlots = maxChipsPerColumn - chips.length;
  if (availableSlots <= 0) {
    return;
  }
  int actualAmount = amount > availableSlots ? availableSlots : amount;
  List<Future<void>> tasks = [];
  animateValueDisplay();
  for (int i = 0; i < actualAmount; i++) {
    tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
      await addChip(chips.length);
      updateChipCountText();
      updateInputNumberPosition();
    }));
  }
  Future.wait(tasks).then((_) {
    debugPrint('FINAL VALUE AFTER INCREASE -> Index: $index, Value: $valueDisplay');
    updateChipCountText();
    updateInputNumberPosition();
  });
}


void decreaseChipsBy(int amount) {
  debugPrint('BEFORE DECREASE -> Index: $index, Amount: $amount, Current: ${chips.length}, Value: $valueDisplay');
  List<Future<void>> tasks = [];
  for (int i = 0; i < amount; i++) {
    tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
      if (chips.isNotEmpty) {
        var removedChip = chips.removeLast();
        remove(removedChip);
        debugPrint('DECREASE -> Index: $index, Remaining: ${chips.length}, Value: $valueDisplay');
        updateChipCountText();
        updateInputNumberPosition();
      }
    }));
  }

  Future.wait(tasks).then((_) {
    debugPrint('FINAL VALUE AFTER DECREASE -> Index: $index, Value: $valueDisplay');
    updateInputNumberPosition();
    updateChipCountText();
  });
}

 Future<void> addChip(int index) async {
    final chip = SpriteComponent()
      ..sprite = await loadSprite('chip.png')
      ..size = Vector2(widthChip, heightChip)
      ..position =
          Vector2(positionX, positionY - (chips.length * chipHeight))
      ..anchor = Anchor.center;

    add(chip);
    chips.add(chip);
    updateChipCountText();
    updateInputNumberPosition();
  }

  void addInputNumberText(String valueDisplay) {
    inputNumberText?.removeFromParent();
    inputNumberText = TextComponent(
      text: '\$${formatNumberNoZero(double.parse(valueDisplay))}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: MyString.padding28,
          fontFamily: MyString.fontFamily,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          shadows: [
          Shadow(
            offset: Offset(0, 0),
            blurRadius: 10.0, // You can adjust the blur radius for the glow effect
            color:  Colors.white,
          ),
          // Shadow(
          //   offset: Offset(16,16),
          //   blurRadius: 20.0, // Larger blur for more glow
          //   color: Colors.yellowAccent, // Slightly dimmer second glow layer
          // ),
          Shadow(
            offset: Offset(-16,-16),
            blurRadius: 30.0, // Larger blur for more glow
            color: Colors.orange, // Slightly dimmer second glow layer
          ),
        ],
        ),
      ),
      position: Vector2(positionX, positionY - (spaceBetweenTextChip * 1.5)),
      anchor: Anchor.center,
    );
    add(inputNumberText!);
  }

  void updateInputNumberPosition() {
    inputNumberText?.position = Vector2(
      positionX,
      positionY - (chips.length * chipHeight) - (spaceBetweenTextChip * 0.75),
    );
  }

  void updateChipCountText() {
    chipCountText?.removeFromParent();
    chipCountText = TextComponent(
      text:'$inputNumber',
      // text: chips.isEmpty ? '' : '$inputNumber - ${chips.length}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: MyString.padding38,
          fontFamily: MyString.fontFamily,
          // color: Colors.transparent, //hide chip count text
          color: Colors.white,
          fontWeight: FontWeight.w600,
          shadows: [
          Shadow(
            offset: Offset(0, 0),
            blurRadius: 10.0, // You can adjust the blur radius for the glow effect
            color:  Colors.blue,
          ),
          Shadow(
            offset: Offset(16,16),
            blurRadius: 20.0, // Larger blur for more glow
            color: Colors.black, // Slightly dimmer second glow layer
          ),

        ],

        ),
      ),
      position: Vector2(positionX, positionY + spaceBetweenTextChip),
      anchor: Anchor.center,
    );
    add(chipCountText!);
  }





  void updateInputNumberText(String newValue) {
    inputNumberText?.text = '\$$newValue';
  }



void animateValueDisplay({int duration = 3000}) async {
  if (valueDisplay == valueDisplayPrev) return; // No animation needed if values are the same
  int endValue = valueDisplay; // Target value to animate to
  int steps = 60; // Smooth animation with 60 frames (steps)
  int stepDuration = duration ~/ steps; // Duration for each step (e.g., 33ms for 2 seconds / 60 steps)
  double currentValue = 0.0; // Starting point (0)
  double stepSize = (endValue - 0) / steps; // Step size for each frame
  // Animate the value from 0 to `valueDisplay`
  for (int i = 0; i < steps; i++) {
    await Future.delayed(Duration(milliseconds: stepDuration));
    currentValue += stepSize; // Increment the value for each frame
    // Update the displayed value
    inputNumberText?.text = '\$${currentValue.round()}';
  }
  // Ensure the final value is exactly `valueDisplay`
  inputNumberText?.text = '\$${formatNumberNoZero(endValue.toDouble())}';


}





//END HERE
}

