import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:tournament_client/service/format.factory.dart';
import 'dart:async';

import 'package:tournament_client/utils/mystring.dart';

class Chart2DPageNew extends FlameGame with ChangeNotifier {
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
  final int maxChipsPerColumn = 27;
  int milisecondAnimate = 75;
  final double spaceBetweenTextChip = 37.5;
  final double widthChip = 45.5;
  final double heightChip = 45.5;

  List<List<SpriteComponent>> chipColumns = List.generate(5, (_) => []);
  List<TextComponent?> chipCountTexts = List.generate(5, (_) => null);

  int members;
  int valueDisplayPrev;


bool _isLoaded = false; // Prevent redundant execution


  Chart2DPageNew({
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
    debugPrint('INCREASECHIP Chart2DPageNew');
  } else if (nextChip < currentChipCount) {
    debugPrint('DECREASECHIP Chart2DPageNew');
    decreaseChipsBy(-(currentChipCount - nextChip));
  }
  // autoAdjust(chips.length,nextChip);

  updateChipCountText();
  updateInputNumberPosition();
  addInputNumberText('$valueDisplay');
}



void autoAdjust(int initialChip, int nextChip) {
  int diff = nextChip - initialChip;

  debugPrint('AUTO ADJUST -> Initial: $initialChip, Next: $nextChip, Diff: $diff');

  if (diff > 0) {
    debugPrint('autoAdjust INCRASE');
    increaseChipsBy(diff);
  } else if (diff < 0) {
    debugPrint('autoAdjust DECREASE');
    decreaseChipsBy(-diff); // Convert negative diff to positive for decrease
  } else {
    debugPrint('NO ADJUSTMENT NEEDED -> Chips remain the same.');
  }
}


void increaseChipsBy(int amount) {
int availableSlots = maxChipsPerColumn - chips.length;
  if (availableSlots <= 0) {
    // debugPrint('MAX REACHED -> Index: $index, Chips: ${chips.length}, Limit: $maxChipsPerColumn');
    return;
  }
  int actualAmount = amount > availableSlots ? availableSlots : amount;
  // debugPrint('BEFORE INCREASE -> Index: $index, Amount: $actualAmount, Current: ${chips.length}, Value: $valueDisplay');
  List<Future<void>> tasks = [];
  for (int i = 0; i < actualAmount; i++) {
    tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
      await addChip(chips.length);
      // debugPrint('INCREASE -> Index: $index, Current: ${chips.length}, Value: $valueDisplay');
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



  // bool shouldRebuild() {
  //   return initialChip != prevInitialChip ||
  //       nextChip != prevNextChip ||
  //       valueDisplay != prevValueDisplay;
  // }

  // void resetState() {
  //   prevInitialChip = initialChip;
  //   prevNextChip = nextChip;
  //   prevValueDisplay = valueDisplay;
  //   removeAllChips();
  // }

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
      // text: '\$${formatNumberNoZero(double.parse(valueDisplay))} (N:$nextChip/P:$initialChip T:${chips.length})',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: MyString.padding19,
          fontFamily: MyString.fontFamily,
          color: Colors.white,
          fontWeight: FontWeight.w600,
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
      text: chips.isEmpty ? '' : '${chips.length}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: MyString.padding12,
          fontFamily: MyString.fontFamily,
          color: Colors.transparent, //hide chip count text
          // color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      position: Vector2(positionX, positionY + spaceBetweenTextChip),
      anchor: Anchor.center,
    );
    add(chipCountText!);
  }

  void removeAllChips() {
    for (var chip in chips) {
      remove(chip);
    }
    chips.clear();
    updateChipCountText();
    updateInputNumberText('0');
    updateInputNumberPosition();
  }

  void updateInputNumberText(String newValue) {
    inputNumberText?.text = '\$$newValue';
  }
}
