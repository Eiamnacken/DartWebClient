part of brickGame;

///
/// Enthält alle objekte die sich momentan im Spiel befinden und stellt
/// Funktionen zu dessen bewegung zu verfügung. Lädt außerdem das Level und
/// deren Inhalt.
/// Für nähere Informationen siehe Dokumentation der Funktionen und Attribute
///
class Game {
  ///
  /// Enthält die angabe für den Positiven [Effect] [longerPLayer] wird zum Start
  /// festgelegt
  ///
  int _incLength;

  ///
  /// Enthält die angabe für den negativen [Effect] [smallerPlayer] wird zum Start
  /// festgelegt
  ///
  int _decLength;

  ///
  /// Enthält die angabe für den negativen [Effect] [slowerPLayer] wird zum Start
  /// festgelegt
  ///
  int _decSpeedPLayer;

  ///
  /// Enthält die angabe für den positiven [Effect] [damageBall] wird zum Start
  /// festgelegt
  ///
  int _incDamageBall;

  ///
  /// In welchem [Level] befinden wir uns
  ///
  int countLevel;

  int points=0;

  ///
  /// Die level
  ///
  List<Level> gameFields;

  Game() {
    gameFields = new List();
    countLevel = 0;
    _readConfig();
  }

  ///
  /// Bewegt alle Bälle um einen Schritt
  /// [direction] In welche Richtung soll sich der [Ball] bewegen
  ///
  void moveBall(GameController controller) {
    List balls = gameFields[countLevel].balls;
    if (balls.isNotEmpty) {
      balls.forEach((ball) {
        ball.move(
            ball.direction, gameFields[countLevel].gameField, controller);
        if (ball.yPosition == _getPlayer().yPosition) {
          gameFields[countLevel].balls.removeLast();
          controller.updateView(gameFields[countLevel].gameField);
        }
        if(won()) newLevel();

      });
    }
  }

  ///
  /// Bewegt alle Items um einen Schritt
  /// [direction] in welche richtung soll es sich bewegen
  ///
  ///
  void moveItem(GameController controller) {
    gameFields[countLevel].items.forEach((item) {
      item.move(
          Direction.down, gameFields[countLevel].gameField, controller);
      if (item.yPosition <= 0) {
        gameFields[countLevel].items.remove(item);
      }
    });
  }

  ///
  /// Bewegt den [Player] in die richtung von [x]
  /// [direction]   Die richtung in die der Spieler sich bewegt
  ///
  void movePLayer(Direction direction, GameController controller) {
    Player player = _getPlayer();
    if (!gameOver()) {
      for (int i = player.moveSpeed; i > 0; i--) {
        player.move(direction, gameFields[countLevel].gameField, controller);
      }
    }
  }

  Player _getPlayer() {
    return gameFields[countLevel].player;
  }

  bool gameOver() {
    if (gameFields[countLevel].balls.length == 0) {
      return true;
    }
    return false;
  }

  bool won() {
    if (gameFields[countLevel].bricks.length == 0 &&
        gameFields[countLevel].balls.length > 0) {
      return true;
    }
    return false;
  }

  ///
  /// Bereitet das nächste level vor in [Level]
  ///
  void newLevel() {
    if(countLevel != gameFields.length - 1) {
      countLevel++;
    }

  }

  void increasePoints(Health health){
    if(health==Health.grey) gameFields[countLevel].bricks.removeLast();
    if(health==Health.brown) return;
    points += 10;
  }



  ///
  /// Ließt die Json Config um die darin enthaltenen Level anzulgegen
  ///
  Future<bool> _readConfig() async {
    /// liest .json aus einem Ordner in einen String
    for(int i = 0; i < 5; i++) {
      final answer = await HttpRequest.getString('level${i}.json');

      String jsonLevel = answer;
      Level level = new Level();
      level.readLevel(jsonLevel);
      gameFields.add(level);
    }
  }

  ///
  /// Löscht ein [MoveableObject] aus dem Spiel
  ///
  void _removeObject(MoveableObject object) {}

  ///
  /// Setzt alle werte auf den Standard zurück
  ///
  void _resetState() {
    countLevel=0;
    points=0;
  }
}
