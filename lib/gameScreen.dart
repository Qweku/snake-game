// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> snakePos = [45, 65, 85];
  int nSquares = 760;
  bool isStarted = false;
  static var randomNum = Random();
  int food = randomNum.nextInt(700);
  void generateNewFood() {
    food = randomNum.nextInt(700);
  }

  void startGame() {
    isStarted = true;
    snakePos = [45, 65, 85];
    const duration = const Duration(milliseconds: 300);
    Timer.periodic(duration, (timer) {
      updateSnake();
      highScore();
      if (gameOver()) {
        timer.cancel();
        isStarted = false;
        _showGameOverScreen();
      }
    });
  }

  int score = 0;
  int highScore() {
    setState(() {
      if (snakePos.length > 1) {
        score = snakePos.length - 3;
      }
    });
    return score;
  }

  var dxn = 'down';
  void updateSnake() {
    setState(() {
      switch (dxn) {
        case 'down':
          if (snakePos.last > 740) {
            snakePos.add(snakePos.last + 20 - 760);
          } else {
            snakePos.add(snakePos.last + 20);
          }

          break;

        case 'up':
          if (snakePos.last < 20) {
            snakePos.add(snakePos.last - 20 + 760);
          } else {
            snakePos.add(snakePos.last - 20);
          }

          break;

        case 'left':
          if (snakePos.last % 20 == 0) {
            snakePos.add(snakePos.last - 1 + 20);
          } else {
            snakePos.add(snakePos.last - 1);
          }

          break;

        case 'right':
          if ((snakePos.last + 1) % 20 == 0) {
            snakePos.add(snakePos.last + 1 - 20);
          } else {
            snakePos.add(snakePos.last + 1);
          }

          break;
        default:
      }
      if (snakePos.last == food) {
        generateNewFood();
      } else {
        snakePos.removeAt(0);
      }
    });
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

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Center(
                  child:
                      Text('GAME OVER', style: TextStyle(color: Colors.red))),
              content: Text('High score: $score',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                    onPressed: () {
                      startGame();
                      Navigator.pop(context);
                    },
                    child:
                        Text('Play Again', style: TextStyle(color: Colors.red)))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Column(children: [
                Expanded(
                    child: GestureDetector(
                        onVerticalDragUpdate: (details) {
                          if (dxn != 'up' && details.delta.dy > 0) {
                            dxn = 'down';
                          } else if (dxn != 'down' && details.delta.dy < 0) {
                            dxn = 'up';
                          }
                        },
                        onHorizontalDragUpdate: (details) {
                          if (dxn != 'left' && details.delta.dx > 0) {
                            dxn = 'right';
                          } else if (dxn != 'right' && details.delta.dx < 0) {
                            dxn = 'left';
                          }
                        },
                        child: SizedBox(
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: nSquares,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 20),
                                itemBuilder: (context, index) {
                                  if (snakePos.contains(index)) {
                                    return Center(
                                        child: Container(
                                            padding: EdgeInsets.all(2),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                  color: Colors.white,
                                                ))));
                                  }
                                  if (index == food) {
                                    return Container(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child:
                                                Container(color: Colors.red)));
                                  } else {
                                    return Container(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                                color: Colors.black)));
                                  }
                                })))),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('S C O R E : $score',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                )
              ]),
              Container(
                  alignment: Alignment(0, 0),
                  child: isStarted
                      ? Container()
                      : GestureDetector(
                          onTap: startGame,
                          child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green)),
                              child: Text('START GAME',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 14))),
                        ))
            ],
          )),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    return (await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              backgroundColor: Colors.grey[900],
                  title: Center(child: Text("Warning", style: TextStyle(color: Colors.red))),
                  content: Text("Do you really want to quit?", textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child:
                            Text("Yes", style: TextStyle(color: Colors.red))),
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: Text("No", style: TextStyle(color: Colors.red)))
                  ],
                ))) ??
        false;
  }
}
