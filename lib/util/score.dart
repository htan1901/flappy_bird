import 'dart:math';

class Score {
  late List<int> scores;
  late int highScore;

  void addScore(int newScore) {
    for (int i = scores.length - 1; i > 0; i--) {
      scores[i] = scores[i - 1];
    }
    scores[0] = newScore;
  }

  int getHighScore() {
    int max = scores[0];
    for (int element in scores) {
      max = element > max ? element : max;
    }
    highScore = max > highScore ? max : highScore;
    return highScore;
  }

  Score() {
    scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    highScore = 0;
  }

  fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      scores = json['scores'].cast<int>();
      highScore = json['highScore'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'scores': [
        scores[0],
        scores[1],
        scores[2],
        scores[3],
        scores[4],
        scores[5],
        scores[6],
        scores[7],
        scores[8],
        scores[9]
      ],
      'highScore': highScore
    };
  }
}
