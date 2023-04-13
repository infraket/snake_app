import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 760;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  void generateNewFood() {
    food = randomNumber.nextInt(700);
  }
 void startGame() {
   snakePosition = [45, 65, 85, 105, 125];
   const duration = const Duration(milliseconds: 300);
   Timer.periodic(duration, (Timer timer){
     updateSnake();
     if (gameOver()) {
       timer.cancel();
       _showGameOverScreen();
     }
   });
 }
 var direction = 'down';
       void updateSnake() {
     setState(() {
       switch (direction) {
         case 'down':
           if (snakePosition.last > 740) {
             snakePosition.add(snakePosition.last + 20 - 700);
           } else {
             snakePosition.add(snakePosition.last + 20);
           }
           break;
         case 'up':
           if (snakePosition.last < 20) {
             snakePosition.add(snakePosition.last - 20 + 760);
           } else {
             snakePosition.add(snakePosition.last - 20);
           }
           break;
         case 'left':
           if (snakePosition.last % 20 == 0) {
             snakePosition.add(snakePosition.last - 1 + 20);
           } else {
             snakePosition.add(snakePosition.last - 1);
           }
           break;
         case 'right':
           if ((snakePosition.last + 1) % 20 == 0) {
             snakePosition.add(snakePosition.last + 1 - 20);
           } else {
             snakePosition.add(snakePosition.last + 1);
           }
           break;
         default:
       }

       if (snakePosition.last == food) {
         generateNewFood();
         // dScore++;
       } else {
         snakePosition.removeAt(0);
       }
     });
   }
   bool gameOver() {
     for (int i = 0; i < snakePosition.length; i++) {
       int count = 0;
       for (int j = 0; j < snakePosition.length; j++) {
         if (snakePosition[i] == snakePosition[j]) {
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
            backgroundColor: Colors.white38,
            title: Center(child: Text(" G A M E   O V E R ")),
            content: Text("score: " + snakePosition.length.toString()),
            actions: [
              TextButton(
                child: Text('Play again'),
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != "up" && details.delta.dy > 0) {
                  direction = "down";
                } else if (direction != "down" && details.delta.dy < 0) {
                  direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != "left" && details.delta.dx > 0) {
                  direction = "right";
                } else if (direction != "right" && details.delta.dx < 0) {
                  direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: numberOfSquares,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20),
                    itemBuilder: (BuildContext context, int index) {
                      if (snakePosition.contains(index)) {
                        return Center(
                          child: Container(
                            padding: EdgeInsets.all(2),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      if (index == food) {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.green,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              color: Colors.grey[900],
                            ),
                          ),
                        );
                      }
                    }),
              ),
            )),
    Padding(
          padding: const EdgeInsets.only(
            bottom: 5.0, left: 20.0, right: 20.0, top: 5),
          child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
            onTap: startGame,
                  child: const Card(
                  child: Padding(
                  padding: EdgeInsets.only(
                  top: 5, left: 20, right: 20, bottom: 5),
                  child: Text(
                  's t a r t',
                  style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                      ),
                      ),
                      ),
                      ),
                      ),
                ],
          ),
        )
      ],
    );
  }
}
