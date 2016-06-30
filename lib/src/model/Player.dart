part of brickGame;
/// Wird durch den Spieler Kontrolliert. Ein rechteck am unteren Rand des
/// des Spieles das den Ball reflektiert
///
class Player extends MoveableObject {


  Direction lastMove;


  Player(int xPosition, int yPosition, int width, int length, int moveSpeed)
      : super(xPosition, yPosition, width, length, moveSpeed, null);


  ///
  /// Ändert die Länge des [Player]
  ///
  void changeLength(int length) {
    length += length;
  }

  ///
  /// Ändert den Abstand den der [Player] pro tastendruck zurück legt
  ///
  void changeSpeed(int speed) {
    super.moveSpeed = speed;
  }

  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    final int gameLength = (gameField.length) *
        gameField[xPosition][yPosition - 1].width;
    final playerLength = (1 + xPosition) *
        gameField[xPosition][yPosition - 1].width;
    if (direction == Direction.right) {
      if (gameLength - (playerLength) < (playerLength / 3).floor()) return;
    }
    int x = getValuesForDirection(direction)["X"];
    Map response = collisionAhead(direction, gameField, 0, x);
    if (!response.keys.first) {
      if (response[false] != null) {
        response[false].collision(gameField, this);
      }
      switchObjects(gameField, this, response.values.first);
      controller.updateView(gameField);
    }
  }

  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if(collisionObject is Item){
      collisionObject.activateItem(this);
    }
  }

  String toString() {
    return "player";
  }


}
