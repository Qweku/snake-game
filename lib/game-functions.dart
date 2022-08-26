
 import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

List<int> snakePos = [210, 230, 250];
  List<int> brick1 = [21, 22, 23, 24, 41, 61, 81];
  List<int> brick2 = [38, 37, 36, 35, 58, 78, 98];
  List<int> brick3 = [661, 662, 663, 664, 641, 621, 601];
  List<int> brick4 = [678, 677, 676, 675, 658, 638, 618];
  int nSquares = 720;
  int speedValue = 300;
  bool isStarted = false;
   int score = 0;
  int highScore = 0;
  int tiMer = 250;
  var randomNum = Random();
  int food = randomNum.nextInt(680);


  class GameFunction{
    void generateNewFood() {
    food = randomNum.nextInt(680);
  }


  bool gameOver() {
    for (int i = 0; i < snakePos.length; i++) {
      int count = 0;
      for (int j = 0; j < snakePos.length; j++) {
        if (snakePos[i] == snakePos[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  bool gameOver1() {
    int count = 0;
    for (int i = 0; i < brick1.length; i++) {
      if (snakePos[snakePos.length - 1] == brick1[i]) {
        count = 1;
      }
      if (count == 1) {
        return true;
      }
    }
    return false;
  }

  bool gameOver2() {
    int count = 0;
    for (int i = 0; i < brick2.length; i++) {
      if (snakePos[snakePos.length - 1] == brick2[i]) {
        count = 1;
      }
      if (count == 1) {
        return true;
      }
    }
    return false;
  }

  bool gameOver3() {
    int count = 0;
    for (int i = 0; i < brick3.length; i++) {
      if (snakePos[snakePos.length - 1] == brick3[i]) {
        count = 1;
      }
      if (count == 1) {
        return true;
      }
    }
    return false;
  }

  bool gameOver4() {
    int count = 0;
    for (int i = 0; i < brick4.length; i++) {
      if (snakePos[snakePos.length - 1] == brick4[i]) {
        count = 1;
      }
      if (count == 1) {
        return true;
      }
    }
    return false;
  }

  
  }