// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

import 'gameScreen.dart';

class Launcher extends StatefulWidget {
  const Launcher({Key? key}) : super(key: key);

  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.2).animate(_controller);
    _controller.forward();
    startTime();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GameScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        backgroundColor: theme.primaryColor,
        body: Stack(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration:
                    BoxDecoration(border: Border.all(color: theme.primaryColorLight)),
                child: FadeTransition(
                  opacity: _animation,
                  child: Text('H U N G R Y  S N A K E',
                      style: theme.textTheme.headline4),
                ),
              ),
            ),
            Container(
              alignment: Alignment(0, 0.9),
              child: Text('@ c r e a t e d b y Q w e k u',
                  style: theme.textTheme.bodyText2!.copyWith(fontSize:12)),
            )
          ],
        ));
  }
}
