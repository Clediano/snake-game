import 'dart:convert';

class Game {
  int foodIndex;
  int playerIndex;
  int score;

  Game({
    required this.foodIndex,
    required this.playerIndex,
    this.score = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'foodIndex': foodIndex,
      'playerIndex': playerIndex,
      'score': score,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      foodIndex: map['foodIndex'],
      playerIndex: map['playerIndex'],
      score: map['score'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));
}
