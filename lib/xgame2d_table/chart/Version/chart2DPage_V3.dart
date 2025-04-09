import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:async';

import 'package:tournament_client/utils/mystring.dart';

class Chart2DPageV3 extends FlameGame {
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
  final int maxChipsPerColumn = 20;
  int milisecondAnimate = 150;
  final double spaceBetweenTextChip = 37.5;
  final double widthHeightChip = 48.5;

  List<List<SpriteComponent>> chipColumns = List.generate(5, (_) => []);
  List<TextComponent?> chipCountTexts = List.generate(5, (_) => null);

  int members;
  int valueDisplay;
  int valueDisplayPrev;

  Chart2DPageV3({
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
    // Immediately show the current value of `valueDisplay` without animation
    addInputNumberText('$valueDisplay'); // Show valueDisplay immediately when the game loads
    updateChipCountText();
    debugPrint('onLoad ValueDisplay: $valueDisplay');
  }



  Future<void> addChip(int index) async {
    final double xOffset = (index % 2 == 0) ? 0.0 : -0.0;
    // final double initialRotation = (index % 2 == 0) ? 0.001 : -0.001;
    final chip = SpriteComponent()
      ..sprite = await loadSprite('chip.png')
      ..size = Vector2(widthHeightChip, widthHeightChip)
      ..position = Vector2(positionX + xOffset, positionY - (chips.length * chipHeight))
      // ..angle = initialRotation
      ..anchor = Anchor.center;

    add(chip);
    chips.add(chip);

    updateChipCountText();
    _updateInputNumberPosition(); // Keep inputNumberText below

  }
void addInputNumberText(String valueDisplay) {
  inputNumberText?.removeFromParent();
  inputNumberText = TextComponent(
    text:  '\$$valueDisplay', // Hide if value is 0
    // text: valueDisplay == '0' ? '' : '\$$valueDisplay', // Hide if value is 0
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: MyString.padding16,
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

void _updateInputNumberPosition() {
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
    text:'${chips.length} stacks', // HiRde if no chips
    // text: chips.isEmpty ? '' : '${chips.length} stacks', // Hide if no chips
    textRenderer: TextPaint(
      style: const TextStyle(
        fontSize: MyString.padding10,
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
void increaseChipsBy(int amount) {
  debugPrint('BEFORE INCREASE -> Index: $index, Amount: $amount, Current: ${chips.length}, Value: $valueDisplay');
  List<Future<void>> tasks = [];
  for (int i = 0; i < amount; i++) {
    tasks.add(Future.delayed(Duration(milliseconds: milisecondAnimate * i), () async {
      await addChip(chips.length);
      debugPrint('INCREASE -> Index: $index, Amount: $amount, Current: ${chips.length}, Value: $valueDisplay');
      updateChipCountText();
      _updateInputNumberPosition(); // ✅ Update position after adding chip
    }));
  }

  // After all chips are added, animate the value display
  Future.wait(tasks).then((_) {
    animateValueDisplay(duration:1000);
    debugPrint('FINAL VALUE AFTER INCREASE -> Index: $index, Value: $valueDisplay');
    updateChipCountText();
    _updateInputNumberPosition(); // ✅ Ensure final position update
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
        _updateInputNumberPosition(); // ✅ Update position after removing chip
      }
    }));
  }
  // After all chips are removed, animate the value display
  Future.wait(tasks).then((_) {
    animateValueDisplay(duration:1000);
    debugPrint('FINAL VALUE AFTER DECREASE -> Index: $index, Value: $valueDisplay');
    updateChipCountText();
    _updateInputNumberPosition(); // ✅ Ensure final position update
    // Only animate if value changes
  });
  }



void animateValueDisplay({int duration = 1000}) async {
  if (valueDisplay == valueDisplayPrev) return; // No need to animate if values are the same

  int startValue = valueDisplayPrev; // Start from previous value
  int endValue = valueDisplay; // Target value

  int steps = 100; // Number of animation steps
  int stepDuration = duration ~/ steps; // Duration per step
  double currentValue = startValue.toDouble();
  double stepSize = (endValue - startValue) / steps; // Increment per step

  for (int i = 0; i < steps; i++) {
    await Future.delayed(Duration(milliseconds: stepDuration));

    currentValue += stepSize;

    if ((stepSize > 0 && currentValue > endValue) || (stepSize < 0 && currentValue < endValue)) {
      currentValue = endValue.toDouble();
    }

    inputNumberText?.text = '\$${currentValue.round()}';
  }

  // Ensure the final value is set correctly
  inputNumberText?.text = '\$$endValue';
}







}

