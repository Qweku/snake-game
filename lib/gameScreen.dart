// ignore_for_file: file_names, prefer_const_constructors, unnecessary_const

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:snake/ad_helper.dart';
import 'package:snake/game-functions.dart';

import 'settings.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  BannerAd? bottomAd;
  bool isLoaded = false;
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  RewardedAd? rewardedAd;
 // int _numRewardedLoadAttempts = 0;

  RewardedInterstitialAd? rewardedInterstitialAd;
 // int _numRewardedInterstitialLoadAttempts = 0;
  void generateNewFood() {
    food = randomNum.nextInt(680);
    if (brick1.contains(food) || brick2.contains(food)) {
      food += 100;
    } else if (brick3.contains(food) || brick4.contains(food)) {
      food -=100;
    } 
  }

  void startGame() {
    assetsAudioPlayer.open(Audio('assets/audios/game-music.mp3'),
        loopMode: LoopMode.playlist);

    tiMer = 250;
    isStarted = true;
    generateNewFood();
    snakePos = [210, 230, 250];
    Duration duration = Duration(milliseconds: tiMer);
    Timer.periodic(duration, (timer) {
      updateSnake();
      currentScore();
      if (GameFunction().gameOver() ||
          GameFunction().gameOver1() ||
          GameFunction().gameOver2() ||
          GameFunction().gameOver3() ||
          GameFunction().gameOver4()) {
        assetsAudioPlayer.open(Audio('assets/audios/game-over.mp3'));
        timer.cancel();
        isStarted = false;
         snakePos = [210, 230, 250];
        _showGameOverScreen();
      } else {
        if (isPaused == true) {
          timer.cancel();
        }
      }
      if (score >= 10 && 10 % score == 0) {
        setState(() {
          tiMer -= 10;
        });
      }
    });
  }

  int setHighScore() {
    setState(() {
      if (score > highScore) {
        highScore = score;
      }
    });
    return highScore;
  }

  int currentScore() {
    setState(() {
      if (snakePos.length > 1) {
        score = snakePos.length - 3;
      }
    });
    return score;
  }

  void playGame() {
    isStarted = true;
    isPaused = false;
    Duration duration = Duration(milliseconds: tiMer);
    Timer.periodic(duration, (timer) {
      updateSnake();
      currentScore();
      if (GameFunction().gameOver() ||
          GameFunction().gameOver1() ||
          GameFunction().gameOver2() ||
          GameFunction().gameOver3() ||
          GameFunction().gameOver4()) {
        assetsAudioPlayer.open(Audio('assets/audios/game-over.mp3'));
        timer.cancel();
        isStarted = false;
         snakePos = [210, 230, 250];
        _showGameOverScreen();
      } else {
        if (isPaused == true) {
          timer.cancel();
        }
      }
      if (score >= 10 && 10 % score == 0) {
        setState(() {
          tiMer -= 10;
        });
      }
      if (brick1.contains(food) ||
          brick2.contains(food) ||
          brick3.contains(food) ||
          brick4.contains(food)) {
        setState(() {
          food = food + 100;
        });
      }
    });
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
        eatAudio.open(Audio('assets/audios/eat.mp3'));
        generateNewFood();
      } else {
        snakePos.removeAt(0);
      }
    });
  }

  void _showGameOverScreen() {
    final theme = Theme.of(context);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                  side: BorderSide(width: 5, color: Colors.amber)),
              title: Center(
                  child: Text('G A M E  O V E R',
                      style: theme.textTheme.headline4!
                          .copyWith(color: Colors.amber))),
              // content: Text('High score: $score',
              //     textAlign: TextAlign.center,
              //     style: theme.textTheme.bodyText2),
              actions: [
                Center(
                  child: TextButton(
                      onPressed: () {
                        showInterstitialAd();

                        setHighScore();
                        Navigator.pop(context);
                      },
                      child:
                          Text('Try Again', style: theme.textTheme.bodyText2)),
                )
              ]);
        });
  }

  bool soundToggle = false;
  bool isPaused = false;
  void pauseGame() {
    setState(() {
      isPaused = true;
      //isStarted = false;
    });
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  final eatAudio = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
    createInterstitialAd();

    BannerAd(
            size: AdSize.banner,
            adUnitId: bottomAd == null
                ? 'ca-app-pub-3940256099942544/6300978111'
                : 'ca-app-pub-1282975341841237/2569125616',
            listener: BannerAdListener(onAdLoaded: (ad) {
              setState(() {
                isLoaded = true;
                bottomAd = ad as BannerAd;
              });
            }, onAdFailedToLoad: (ad, error) {
              ad.dispose();
            }),
            request: AdRequest())
        .load();
  }

  @override
  void dispose() {
    super.dispose();
    MyAds().interstitialAd!.dispose();
    rewardedAd!.dispose();
    bottomAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
          backgroundColor: theme.primaryColor,
          body: SafeArea(
            child: Stack(
              children: [
                Column(children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: pauseGame,
                            child: Icon(
                              Icons.pause_circle,
                              color: Colors.white,
                            )),
                        Text('S C O R E : $score',
                            style: theme.textTheme.bodyText2),
                        Text('H I G H S C O R E : $highScore',
                            style: theme.textTheme.bodyText2),
                        soundToggle
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    soundToggle = false;
                                    assetsAudioPlayer.playOrPause();
                                  });
                                },
                                child: Icon(
                                  Icons.music_off,
                                  color: Colors.white,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    soundToggle = true;
                                    assetsAudioPlayer.playOrPause();
                                  });
                                },
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ))
                      ],
                    ),
                  ),
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
                                                      color: Color.fromARGB(
                                                          255, 0, 132, 255)))));
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
                                                  color: Colors.amber)));
                                    } else {
                                      return Container(
                                          padding: EdgeInsets.all(2),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Container(
                                                  color: Color.fromARGB(255, 0, 0, 0))));
                                    }
                                  })))),
                  //SizedBox(height: 20),
                  Container(
                    height: isLoaded ? bottomAd!.size.height.toDouble() : 0,
                    width: isLoaded ? bottomAd!.size.width.toDouble() : 0,
                    color: isLoaded ? Colors.white : Colors.transparent,
                    child: isLoaded ? AdWidget(ad: bottomAd!) : SizedBox(),
                  )
                ]),
                isPaused
                    ? Container(
                        alignment: Alignment(0, 0),
                        child: Container(
                          height: height,
                          width: width,
                          color: Colors.black.withOpacity(0.4),
                          child: GestureDetector(
                              onTap: playGame,
                              child: Icon(Icons.play_circle,
                                  size: 50, color: Colors.white)),
                        ),
                      )
                    : Container(),
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
                                    style: theme.textTheme.bodyText2!.copyWith(
                                        color: theme.primaryColorLight))),
                          )),
                // Container(
                //   alignment: Alignment(0.9, 1),
                //   child: IconButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => Settings()));
                //       },
                //       icon:
                //           Icon(Icons.settings, color: theme.primaryColorLight)),
                // )
              ],
            ),
          )),
    );
  }

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAd == null
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-1282975341841237/8890582268',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
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
