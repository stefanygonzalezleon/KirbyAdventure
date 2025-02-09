import 'dart:async';
import 'package:flutter/material.dart';
import 'obstacle.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  int score = 0;
  double kirbyPositionY = 0.0;
  bool isJumping = false;
  bool canJump = true;
  int jumpCount = 0;
  List<Obstacle> obstacles = [];
  late Timer obstacleTimer;

  void _jump() {
    if (jumpCount < 5 && !isJumping) {
      setState(() {
        isJumping = true;
        jumpCount++;
        kirbyPositionY = -100.0;
      });

      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          kirbyPositionY = 0.0;
          isJumping = false;
        });

        if (jumpCount >= 5) {
          setState(() {
            canJump = false;
          });

          Future.delayed(Duration(seconds: 2), () {
            _endGame();
          });
        }
      });
    }
  }

  void _addObstacle() {
    double screenHeight = MediaQuery.of(context).size.height;
    double obstacleHeight = 20.0;

    setState(() {
      obstacles.add(Obstacle(
        left: 400.0,
        top: screenHeight / 2 + obstacleHeight,
      ));
    });
  }

  void _moveObstacles() {
    setState(() {
      for (var obstacle in obstacles) {
        obstacle.moveLeft();
      }
      obstacles.removeWhere((obstacle) => obstacle.left < 0);
    });
  }

  void _endGame() {
    Navigator.pushNamed(context, '/result', arguments: score);
  }

  @override
  void initState() {
    super.initState();
    obstacleTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      _moveObstacles();
    });

    Timer.periodic(Duration(seconds: 2), (timer) {
      _addObstacle();
    });
  }

  @override
  void dispose() {
    obstacleTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Juego de Kirby')),
      body: Stack(
        alignment: Alignment.center,
        children: [

          ...obstacles.map((obstacle) => obstacle.buildWidget()),


          Positioned(
            left: 50,
            top: screenHeight / 2 + kirbyPositionY,
            child: Image.asset(
              'assets/kirby.png',
              height: 100,
            ),
          ),


          Positioned(
            bottom: screenHeight * 0.25,
            child: ElevatedButton(
              onPressed: canJump ? _jump : null,
              child: Text('Saltar'),
            ),
          ),


          Positioned(
            top: 20,
            child: Column(
              children: [
                Text(
                  'Puntaje: $score',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Saltos: $jumpCount/5',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
