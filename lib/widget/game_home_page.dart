import 'dart:async';
import 'dart:math';

import 'package:flappy_bird/entity/barrier_data.dart';
import 'package:flappy_bird/entity/bird.dart';
import 'package:flappy_bird/util/json_file.dart';
import 'package:flappy_bird/util/score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameHomePage extends StatefulWidget {
  Score score = Score();
  GameHomePage({Key? key}) : super(key: key);

  @override
  State<GameHomePage> createState() => _GameHomePageState();
}

class _GameHomePageState extends State<GameHomePage> {
  final double _gravityForce = 9.8;
  final double _birdFallingSpeed = 0.04;
  // change if you want bird move higher or shorter
  final double _initialVelocity = 2.8;
  // change if you want barrier move faster or slower
  double _barrierSpeed = 0.03;

  static final List<Map<String, double>> _data = BarierData.data;
  static final _numberOfBarrier = _data.length;

  static final Random _random = Random(DateTime.now().millisecondsSinceEpoch);

  static double _birdVerticalPosition = 0;
  double _currentHeight = _birdVerticalPosition;
  double _time = 0;
  double _heightOverTime = 0;
  bool _isGameStarted = false;
  bool _isGameEnd = false;
  int _showType = 1;

  static double _firstBarrierPosition = 1.5;
  static double _secondBarrierPosition = _firstBarrierPosition + 2;

  int _firstBarrierType = _random.nextInt(_numberOfBarrier - 1);
  int _secondBarrierType = _random.nextInt(_numberOfBarrier - 1);

  int _playScore = 0;
  late int _highScore;

  @override
  void initState() {
    super.initState();
    JsonManager().readJsonFile().then((value) {
      setState(() {
        widget.score.fromJson(value);
        _highScore = widget.score.getHighScore();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: GestureDetector(
            onTap: () {
              if (_isGameStarted) {
                _jump();
              } else {
                _startGame();
              }
            },
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(0, _birdVerticalPosition),
                  duration: const Duration(milliseconds: 0),
                  child: const Bird(),
                ),
                AnimatedContainer(
                  alignment: Alignment(_firstBarrierPosition, 0),
                  duration: const Duration(milliseconds: 0),
                  child: PairBarier(_data.elementAt(_firstBarrierType)),
                ),
                AnimatedContainer(
                  alignment: Alignment(_secondBarrierPosition, 0),
                  duration: const Duration(milliseconds: 0),
                  child: PairBarier(_data.elementAt(_secondBarrierType)),
                ),
                Container(
                  alignment: const Alignment(0, -0.2),
                  child: Text(
                    !_isGameStarted
                        ? !_isGameEnd
                            ? 'T A P  T O  P L A Y'
                            : ''
                        : '',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  alignment: const Alignment(0, -0.9),
                  child: Text(
                    _isGameStarted ? '$_playScore' : '',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 40,
                    ),
                  ),
                ),
                _buildDialog()
              ],
            ),
          )),
        ],
      ),
    );
  }

  Container _buildDialog() {
    return Container(
      alignment: Alignment.center,
      child: _isGameEnd
          ? Container(
              width: 350,
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.brown,
                  border: Border.all(
                    color: Colors.amberAccent,
                    style: BorderStyle.solid,
                    width: 5,
                  )),
              alignment: const Alignment(0, 0),
              padding: const EdgeInsets.all(15),
              child: _showDialog(_showType),
            )
          : null,
    );
  }

  Column _showDialog(int type) {
    switch (type) {
      case 1:
        return _endGameDialog();
      case 2:
        return _scoreDialog();
      default:
    }
    return _endGameDialog();
  }

  Column _scoreDialog() {
    return Column(
      children: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            BackButton(
              color: Colors.white,
              onPressed: () {
                setState(() {
                  _showType = 1;
                });
              },
            )
          ],
        )
      ],
    );
  }

  Column _endGameDialog() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Text(
          "GAME OVER",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text(
              'Score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              'Highest Score',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              '$_playScore',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              '$_highScore',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _restartGame();
                });
              },
              icon: const Icon(
                Icons.restart_alt,
                size: 30,
              ),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _showType = 2;
                });
              },
              icon: const Icon(
                Icons.format_list_numbered_outlined,
                size: 30,
              ),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              icon: const Icon(
                Icons.exit_to_app,
                size: 30,
              ),
              color: Colors.white,
            ),
          ],
        )
      ],
    );
  }

  void _restartGame() {
    _birdVerticalPosition = 0;
    _currentHeight = _birdVerticalPosition;
    _time = 0;
    _heightOverTime = 0;
    _isGameStarted = false;
    _isGameEnd = false;

    _firstBarrierPosition = 1.5;
    _secondBarrierPosition = _firstBarrierPosition + 2;

    _firstBarrierType = _random.nextInt(_numberOfBarrier - 1);
    _secondBarrierType = _random.nextInt(_numberOfBarrier - 1);

    _playScore = 0;
    _barrierSpeed = 0.03;
  }

  void _startGame() {
    _isGameStarted = true;
    setState(() {
      Timer.periodic(const Duration(milliseconds: 50), (timer) {
        _time += _birdFallingSpeed;
        _heightOverTime = _calculateHeightOverTime();
        setState(() {
          _firstBarrierPosition -= _barrierSpeed;
          _secondBarrierPosition -= _barrierSpeed;
          _birdVerticalPosition = _currentHeight - _heightOverTime;
        });
        if (_isGameEnded()) {
          timer.cancel();
          _isGameStarted = false;
          _isGameEnd = true;
          widget.score.addScore(_playScore);
          _highScore = widget.score.getHighScore();
          JsonManager().writeJsonFile(widget.score);
        }
        if (_isScored()) {
          _playScore++;
          if (_playScore % 10 == 0) {
            _barrierSpeed *= 1.5;
          }
        }

        // reset the position of bariers
        if (_firstBarrierPosition < -2) {
          _firstBarrierType = _random.nextInt(_numberOfBarrier - 1);
          _firstBarrierPosition += 4;
        }
        if (_secondBarrierPosition < -2) {
          _secondBarrierType = _random.nextInt(_numberOfBarrier - 1);
          _secondBarrierPosition += 4;
        }
      });
    });
  }

  void _jump() {
    setState(() {
      // reset the starting time and height
      _time = 0;
      _currentHeight = _birdVerticalPosition;
    });
  }

  bool _isScored() {
    double bound = _barrierSpeed / 2;
    return (_firstBarrierPosition < bound && _firstBarrierPosition > -bound) ||
        (_secondBarrierPosition < bound && _secondBarrierPosition > -bound);
  }

  bool _isBarrierCollision() {
    // collide with first barrier
    double firstTopPart = 2 * _data.elementAt(_firstBarrierType)['top']!;
    double firstBottomPart = 2 * _data.elementAt(_firstBarrierType)['bottom']!;
    if ((_birdVerticalPosition <= -1 + firstTopPart ||
        _birdVerticalPosition >= 1 - firstBottomPart)) {
      if (_firstBarrierPosition <= 0.45) return _firstBarrierPosition >= -0.3;
    }

    // collide with second barrier
    double secondTopPart = 2 * _data.elementAt(_secondBarrierType)['top']!;
    double secondBottomPart =
        2 * _data.elementAt(_secondBarrierType)['bottom']!;
    if ((_birdVerticalPosition <= -1 + secondTopPart ||
        _birdVerticalPosition >= 1 - secondBottomPart)) {
      if (_secondBarrierPosition <= 0.45) return _secondBarrierPosition >= -0.3;
    }
    return false;
  }

  bool _isGameEnded() {
    return _isBarrierCollision() ||
        _birdVerticalPosition < -1 ||
        _birdVerticalPosition > 1;
  }

  double _calculateHeightOverTime() {
    // x = (1/2)*a*t^2 + v0*t

    // equation to calculate position over time
    // in this case is the height of the bird over time
    // t: time, v0: initial velocity, a: acceleration
    // in this case acceleration is gravity force
    return -(_gravityForce / 2.0) * _time * _time + _initialVelocity * _time;
  }
}
