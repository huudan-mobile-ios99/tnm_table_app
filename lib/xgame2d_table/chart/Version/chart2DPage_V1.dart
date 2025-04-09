import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'dart:async';

import 'package:tournament_client/utils/mystring.dart';

// import 'package:google_fonts/google_fonts.dart';



class Chart2DPageV1 extends FlameGame {
   int inputNumber; // Number assigned from the parent
   int initialChip; // initialChip assigned from the parent
   int nextChip; // initialChip assigned from the parent

   bool played; // Determines if the chip should animate (increase or decrease)
   int index; // Identifies each game instance

  //  int valueCredit;
  final List<SpriteComponent> chips = [];
  final double chipHeight = 15; // Simulated 3D thickness


  void updateValues(int newInputNumber, int newInitialChip, int newNextChip, bool newPlayed) {
    inputNumber = newInputNumber;
    initialChip = newInitialChip;
    nextChip = newNextChip;
    played = newPlayed;
  }

  // Declare these globally to update them dynamically
  TextComponent? chipCountText;
  TextComponent? inputNumberText;
  final int columns = 5; // Number of columns
  final int maxChipsPerColumn = 30; // Max stack size per column
  int milisecondAnimate = 150;

  final double spaceBetweenTextChip = 50;



  List<List<SpriteComponent>> chipColumns = List.generate(5, (_) => []);
  List<TextComponent?> chipCountTexts = List.generate(5, (_) => null);
  final double positionX ;
  final double positionY;
  final int members;
  final int valueDisplay;

  Chart2DPageV1({
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
  Color backgroundColor() => Colors.white.withOpacity(.95); // Set game background to white

  @override
  Future<void> onLoad() async {
    for (int i = 0; i < initialChip; i++) {
      await addChip(i);
    }
  }

  Future<void> addChip(int index) async {
    final double xOffset = (index % 2 == 0) ? 0.0 : -0.0; // Alternating wobble effect
    final double initialRotation = (index % 2 == 0) ? 0.001 : -0.001;

    final chip = SpriteComponent()
      ..sprite = await loadSprite('chip.png') // Load sprite correctly
      ..size = Vector2(100, 100)
      ..absoluteAngle
      ..decorator
      ..position = Vector2(positionX + xOffset, positionY - (index * chipHeight))// Stack effect
      ..angle = initialRotation // Slight tilt effect
      ..anchor = Anchor.center; // Stack rotates from the center

    add(chip);
    chips.add(chip);
    chipCountText?.removeFromParent();

  // **Chip Count Text (Above Chips, Updates Dynamically)**
  chipCountText = TextComponent(text: '\$$nextChip', // Displays total chips
  textRenderer: TextPaint(
    style:const TextStyle(
    fontSize: MyString.padding22,
    fontFamily: MyString.fontFamily,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  ),
  ),
  position: Vector2(positionX.toDouble(), positionY - (chips.length * chipHeight) - 62.5), // Positioned above chips
    anchor: Anchor.center,
  );
  add(chipCountText!);

  // **Remove Previous Input Number Text (To Prevent Duplicates)**
  inputNumberText?.removeFromParent();

  // **Input Number (Fixed Below Column)**
  inputNumberText = TextComponent( text: '$inputNumber', // Displays input number
  // Apply Google Font Montserrat
    textRenderer: TextPaint(
      style: const TextStyle(
        fontFamily: MyString.fontFamily,
        fontSize: MyString.padding22,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
    ),
    position: Vector2(positionX.toDouble(), positionY.toDouble()*1.15), // Fixed Position Below Stack
    anchor: Anchor.center,
  );
  add(inputNumberText!);
  }




void updateChips() {
      if (played) {
        int difference = nextChip - initialChip;
        if (difference > 0) {
          for (int i = 0; i < difference; i++) {
            Future.delayed(Duration(milliseconds: milisecondAnimate * i), () => addChip(chips.length + 1));
          }
        } else if (difference < 0) {
          for (int i = 0; i < -difference; i++) {
            Future.delayed(Duration(milliseconds: milisecondAnimate * i), () {
              if (chips.isNotEmpty) remove(chips.removeLast());
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
        remove(chips.removeLast()); // Remove last chip dynamically
        debugPrint('Chip removed -> Remaining: ${chips.length}');

        // Update chip count text dynamically
        chipCountText?.removeFromParent();
        chipCountText = TextComponent(
          text: '${chips.length}', // Updated count
          textRenderer: TextPaint(
            style: const TextStyle(
              fontSize: MyString.padding22,
              fontFamily: MyString.fontFamily,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          position: Vector2(
            positionX.toDouble(),
            positionY - (chips.length * chipHeight) - spaceBetweenTextChip, // Adjust position
          ),
          anchor: Anchor.center,
        );
        add(chipCountText!);
      }
    });
  }
}











}















