import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:tournament_client/service/format.factory.dart';
import 'dart:async';

import 'package:tournament_client/utils/mystring.dart';

class Chart2DPage extends FlameGame  with ChangeNotifier{
  int inputNumber;
  int initialChip;
  int nextChip;
  bool played;
  int index;
  double positionX;
  double positionY;

  final List<SpriteComponent> chips = [];
  final double chipHeight = 8.5;

  TextComponent? chipCountText;
  TextComponent? inputNumberText;
  final int columns = 5;
  final int maxChipsPerColumn = 27;
  int milisecondAnimate = 1000;
  final double spaceBetweenTextChip = 37.5;
  final double widthChip = 45.5;
  final double heightChip = 45.5;

  List<List<SpriteComponent>> chipColumns = List.generate(5, (_) => []);
  List<TextComponent?> chipCountTexts = List.generate(5, (_) => null);

  int members;
  int valueDisplay;
  int valueDisplayPrev;

  Chart2DPage({
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
  });

  @override
  Color backgroundColor() => Colors.transparent;
  // Color backgroundColor() => Colors.white.withOpacity(1);

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < initialChip; i++) {
      await addChip(i);
    }
    addInputNumberText('$valueDisplay'); // Show valueDisplay immediately when the game loads
    updateChipCountText();
    updateInputNumberPosition();
    debugPrint('onLoad Data: ValueDisplay: $valueDisplay InitialChip: $initialChip NextChip: $nextChip');
  }


void updateInputNumberText(String newValue) {
  if (inputNumberText != null) {
    inputNumberText!.text = '\$$newValue';
  }
}


  Future<void> addChip(int index) async {
    final double xOffset = (index % 2 == 0) ? 0.0 : -0.0;
    // final double initialRotation = (index % 2 == 0) ? 0.001 : -0.001;
    final chip = SpriteComponent()
      ..sprite = await loadSprite('chip.png')
      ..size = Vector2(widthChip, heightChip)
      ..position = Vector2(positionX + xOffset, positionY - (chips.length * chipHeight))
      // ..angle = initialRotation
      ..anchor = Anchor.center;

    add(chip);
    chips.add(chip);

    updateChipCountText();
    updateInputNumberPosition(); // Keep inputNumberText below
  }
void addInputNumberText(String valueDisplay) {
  inputNumberText?.removeFromParent();
  inputNumberText = TextComponent(
    text:  '\$${formatNumberNoZero(double.parse(valueDisplay))} ', // Hide if value is 0
    // text: valueDisplay == '0' ? '' : '\$$valueDisplay', // Hide if value is 0
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: MyString.padding19,
        fontFamily: MyString.fontFamily,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
    position: Vector2(
      positionX.toDouble(),
      positionY  - (spaceBetweenTextChip * 1.5), // Move above chips
    ),
    anchor: Anchor.center,
  );

  add(inputNumberText!);
}

void updateInputNumberPosition() {
  if (inputNumberText != null) {
    inputNumberText!.position = Vector2(
      positionX.toDouble(),
      positionY - (chips.length * chipHeight) - (spaceBetweenTextChip*0.75), // Keep above chips
    );
  }
}



void updateChipCountText() {
  chipCountText?.removeFromParent();
  chipCountText = TextComponent(
    text: chips.isEmpty ? '' : '${chips.length}', // Hide if no chips
    textRenderer: TextPaint(
      style:  const TextStyle(
        fontSize: MyString.padding12,
        fontFamily: MyString.fontFamily,
        // color: Colors.transparent, ///HIDE THE TEXT
        color: Colors.white, ///HIDE THE TEXT
        fontWeight: FontWeight.w500,
      ),
    ),
    position: Vector2(
      positionX.toDouble(),
      positionY + spaceBetweenTextChip, // Move below chips
    ),
    anchor: Anchor.center,
  );

  add(chipCountText!);
}

void increaseChipsBy(int amount) {
int availableSlots = maxChipsPerColumn - chips.length;
  if (availableSlots <= 0) {
    debugPrint('MAX REACHED -> Index: $index, Chips: ${chips.length}, Limit: $maxChipsPerColumn');
    return;
  }
  int actualAmount = amount > availableSlots ? availableSlots : amount;
  debugPrint('BEFORE INCREASE -> Index: $index, Amount: $actualAmount, Current: ${chips.length}, Value: $valueDisplay');
  List<Future<void>> tasks = [];
  for (int i = 0; i < actualAmount; i++) {
    tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
      await addChip(chips.length);
      debugPrint('INCREASE -> Index: $index, Current: ${chips.length}, Value: $valueDisplay');
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
        remove(chips.removeLast());
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



// void addChipByAmount(int amount) {
//   debugPrint('START ADDING CHIPS -> Index: $index, Amount: $amount, Current: ${chips.length}');
//   List<Future<void>> tasks = [];
//   for (int i = 0; i < amount; i++) {
//     tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
//       await addChip(chips.length);
//       debugPrint('ADDING CHIP -> Index: $index, Current: ${chips.length}');
//       updateChipCountText();
//       updateInputNumberPosition();
//     }));
//   }
//   Future.wait(tasks).then((_) {
//     debugPrint('FINAL CHIP COUNT -> Index: $index, Total: ${chips.length}');
//     updateChipCountText();
//     updateInputNumberPosition();
//   });
// }

void removeAllChips() {
  debugPrint('REMOVE ALL -> Index: $index, Current: ${chips.length}');
  for (var chip in chips) {
    remove(chip);
  }
  chips.clear();
  resetChipCountText();
  updateInputNumberText('0'); // Ensure input number resets
  updateInputNumberPosition();
  debugPrint('ALL CHIPS REMOVED -> Index: $index');
}






void resetChipCountText() {
  chipCountText?.removeFromParent();
  chipCountText = TextComponent(
    text: '0', // Always show 0
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: MyString.padding12,
        fontFamily: MyString.fontFamily,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
    ),
    position: Vector2(
      positionX.toDouble(),
      positionY + spaceBetweenTextChip, // Move below chips
    ),
    anchor: Anchor.center,
  );

  add(chipCountText!);
}

void addAllChips() {
  int availableSlots = maxChipsPerColumn - chips.length;
  if (availableSlots <= 0) {
    debugPrint('MAX REACHED -> Index: $index, Chips: ${chips.length}, Limit: $maxChipsPerColumn');
    return;
  }

  debugPrint('ADDING ALL CHIPS -> Index: $index, MaxChips: $maxChipsPerColumn');
  List<Future<void>> tasks = [];
  for (int i = 0; i < maxChipsPerColumn; i++) {
    tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
      await addChip(chips.length);
      debugPrint('ADDING -> Index: $index, Current: ${chips.length}');
      updateChipCountText();
      updateInputNumberPosition();
    }));
  }

  Future.wait(tasks).then((_) {
    debugPrint('ALL CHIPS ADDED -> Index: $index, Total: ${chips.length}');
    updateChipCountText();
    updateInputNumberPosition();
  });
}

}















// void animateValueDisplay({int duration = 1000}) async {
//   // if (valueDisplay == valueDisplayPrev) return; // No animation needed

//   // int startValue = valueDisplayPrev;
//   int endValue = valueDisplay;

//   int steps = 60; // Smooth animation with 60 frames
//   int stepDuration = duration ~/ steps;
//   double currentValue = 0.toDouble();
//   double stepSize = (endValue - 0) / steps;

//   for (int i = 0; i < steps; i++) {
//     await Future.delayed(Duration(milliseconds: stepDuration));

//     currentValue += stepSize;
//     inputNumberText?.text = '\$${currentValue.round()}';
//   }

//   // Ensure the final value is set correctly
//   inputNumberText?.text = '\$$endValue';
// }
