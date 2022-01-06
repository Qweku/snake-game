// ignore_for_file: file_names, prefer_const_constructors, unnecessary_const

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> snakePos = [205, 225, 245];
  List<int> brick1 = [21, 22, 23, 24, 41, 61, 81];
  List<int> brick2 = [38, 37, 36, 35, 58, 78, 98];
  List<int> brick3 = [701, 702, 703, 704, 681, 661, 641];
  List<int> brick4 = [718, 717, 716, 715, 698, 678, 658];
  int nSquares = 760;
  static int speedValue = 300;
  bool isStarted = false;
  static var randomNum = Random();
  int food = randomNum.nextInt(680);
  void generateNewFood() {
    food = randomNum.nextInt(680);
  }

  void startGame() {
    isStarted = true;
    snakePos = [205, 225, 245];
    const duration = const Duration(milliseconds: 250);
    Timer.periodic(duration, (timer) {
      updateSnake();
      highScore();
      if (
          gameOver() ||
          gameOver1() ||
           gameOver2() ||
          gameOver3() ||
          gameOver4()
          ) {
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

  bool gameOver1() {
    int count = 0;
    for (int i = 0; i < brick1.length; i++) {
      
      if (snakePos[snakePos.length-1] == brick1[i]) {
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
      
      if (snakePos[snakePos.length-1] == brick2[i]) {
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
      
      if (snakePos[snakePos.length-1] == brick3[i]) {
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
      
      if (snakePos[snakePos.length-1] == brick4[i]) {
        count = 1;
      }
      if (count == 1) {
        return true;
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    final theme = Theme.of(context);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Center(
                  child: Text('GAME OVER',
                      style: theme.textTheme.headline4!
                          .copyWith(color: theme.cardColor))),
              content: Text('High score: $score',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyText2),
              actions: [
                TextButton(
                    onPressed: () {
                      startGame();
                      Navigator.pop(context);
                    },
                    child: Text('Play Again',
                        style: theme.textTheme.bodyText2!
                            .copyWith(color: theme.cardColor)))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
          backgroundColor: theme.primaryColor,
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
                                                    color: theme
                                                        .primaryColorLight))));
                                  }
                                  if (brick1.contains(index)) {
                                    return Center(
                                        child: Container(
                                            padding: EdgeInsets.all(2),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                    color: Colors.brown))));
                                  }
                                  if (brick3.contains(index)) {
                                    return Center(
                                        child: Container(
                                            padding: EdgeInsets.all(2),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                    color: Colors.brown))));
                                  }
                                  if (brick2.contains(index)) {
                                    return Center(
                                        child: Container(
                                            padding: EdgeInsets.all(2),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                    color: Colors.brown))));
                                  }
                                  if (brick4.contains(index)) {
                                    return Center(
                                        child: Container(
                                            padding: EdgeInsets.all(2),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: Container(
                                                    color: Colors.brown))));
                                  }
                                  if (index == food) {
                                    return Container(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                                color: theme.cardColor)));
                                  } else {
                                    return Container(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                                color: theme.primaryColor)));
                                  }
                                })))),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('S C O R E : $score',
                      style: theme.textTheme.bodyText2),
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
                                  border: Border.all(
                                      color: theme.primaryColorLight)),
                              child: Text('START GAME',
                                  style: theme.textTheme.bodyText2!.copyWith(color:theme.primaryColorLight))),
                        )),
              Container(
                alignment: Alignment(0.9, 1),
                child:IconButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    },
                    icon: Icon(Icons.settings, color: theme.primaryColorLight)),
              )
            ],
          )),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.colorize_outlined,
                      color: Colors.blueAccent, size: 25),
                  title: Text('Change theme'),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  },
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('Speed',
                      style: TextStyle(color: Colors.black, fontSize: 17)),
                ),
                Slider(
                  value: speedValue.toDouble(),
                  max: 500,
                  min: 100,
                  divisions: 5,
                  label: speedValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      speedValue = value.toInt();
                    });
                  },
                ),
                SizedBox(height: 20)
              ],
            ),
          );
        });
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    final theme = Theme.of(context);
    return (await showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
                  backgroundColor: Colors.grey[900],
                  title: Center(
                      child: Text("Warning",
                          style: theme.textTheme.headline4!
                              .copyWith(color: theme.cardColor))),
                  content: Text("Do you really want to quit?",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyText2),
                  actions: [
                    TextButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text("Yes",
                            style: theme.textTheme.bodyText2!
                                .copyWith(color: theme.cardColor))),
                    TextButton(
                        onPressed: () => Navigator.pop(c, false),
                        child: Text("No",
                            style: theme.textTheme.bodyText2!
                                .copyWith(color: theme.cardColor)))
                  ],
                ))) ??
        false;
  }
}
