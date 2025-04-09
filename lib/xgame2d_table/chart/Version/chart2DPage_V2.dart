import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:async';

import 'package:tournament_client/utils/mystring.dart';

class Chart2DPageV2 extends FlameGame {
  int inputNumber;
  int initialChip;
  int nextChip;
  bool played;
  int index;
  double positionX;
  double positionY;

  final List<SpriteComponent> chips = [];
  final double chipHeight = 7.5;

  TextComponent? chipCountText;
  TextComponent? inputNumberText;
  final int columns = 5;
  final int maxChipsPerColumn = 30;
  int milisecondAnimate = 200;
  final double spaceBetweenTextChip = 37.5;
  final double widthHeightChip = 37.5;

  List<List<SpriteComponent>> chipColumns = List.generate(5, (_) => []);
  List<TextComponent?> chipCountTexts = List.generate(5, (_) => null);

  final int members;
  final int valueDisplay;

  Chart2DPageV2({
    required this.index,
    required this.inputNumber,
    required this.initialChip,
    required this.nextChip,
    required this.positionX,
    required this.positionY,
    required this.members,
    required this.valueDisplay,
    this.played = false,
  });

  @override
  Color backgroundColor() => Colors.transparent;
  // Color backgroundColor() => Colors.white.withOpacity(1);

  @override
  Future<void> onLoad() async {
    _addInputNumberText(); // Add inputNumberText first
    for (int i = 0; i < initialChip; i++) {
      await addChip(i);
    }
    updateChipCountText();
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

  void _addInputNumberText() {
    inputNumberText?.removeFromParent();
    inputNumberText = TextComponent(
      text: '${chips.length}', //MEMBERS INPUT
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: MyString.padding12,
          fontFamily: MyString.fontFamily,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      position: Vector2(
        positionX.toDouble(),
        positionY + spaceBetweenTextChip, // Fixed position below the chips
      ),
      anchor: Anchor.center,
    );

    add(inputNumberText!);
  }

  void _updateInputNumberPosition() {
    if (inputNumberText != null) {
      inputNumberText!.position = Vector2(
        positionX.toDouble(),
        positionY + spaceBetweenTextChip, // Keep it fixed below chips
      );
    }
  }

  void updateChipCountText() {
    chipCountText?.removeFromParent();

    chipCountText = TextComponent(
      text: '\$$valueDisplay',
      // text: '$valueDisplay(${chips.length})',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: MyString.padding12,
          fontFamily: MyString.fontFamily,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      position: Vector2(
        positionX.toDouble(),
        positionY - (chips.length * chipHeight) - spaceBetweenTextChip/1.5,
      ),
      anchor: Anchor.center,
    );

    add(chipCountText!);
  }

  void updateChips() {
    if (played) {
      int difference = nextChip - initialChip;
      if (difference > 0) {
        for (int i = 0; i < difference; i++) {
          Future.delayed(Duration(milliseconds: milisecondAnimate * i), () {
            addChip(chips.length + 1);
          });
        }
      } else if (difference < 0) {
        for (int i = 0; i < -difference; i++) {
          Future.delayed(Duration(milliseconds: milisecondAnimate * i), () {
            if (chips.isNotEmpty) {
              remove(chips.removeLast());
              updateChipCountText();
              _updateInputNumberPosition(); // Keep inputNumberText below
            }
          });
        }
      }
    }
  }

  void increaseChipsBy(int amount) {
    debugPrint('Index: $index, Initial: $initialChip, Next: $nextChip');

    for (int i = 0; i < amount; i++) {
      Future.delayed(Duration(milliseconds: milisecondAnimate * i), () {
        addChip(chips.length + 1);
        debugPrint('INCREASE -> Index: $index, Amount: $amount, Current: ${chips.length}');
      });
    }
  }

  void decreaseChipsBy(int amount) {
    debugPrint('DECREASING -> Index: $index, Amount: $amount');
    for (int i = 0; i < amount; i++) {
      Future.delayed(Duration(milliseconds: milisecondAnimate * i), () {
        if (chips.isNotEmpty) {
          remove(chips.removeLast());
          updateChipCountText();
          _updateInputNumberPosition(); // Keep inputNumberText below
          debugPrint('Chip removed -> Remaining: ${chips.length}');
        }
      });
    }
  }
}
