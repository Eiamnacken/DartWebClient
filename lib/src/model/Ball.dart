
import 'package:DartWeb/src/model/Model.dart';
import 'package:DartWeb/src/controller/GameController.dart';
///
/// Objekt das sich von selbst durch den Spielraum bewegt
/// Außerdem fügt es [Brick] schaden zu bei Kontakt
///
class Ball extends MoveableObject {
  ///
  /// Welchen schaden der [Ball] an einem [Brick] zufügt
  ///
  int _damage;


  Ball(int xPosition, int yPosition, int width, int length, int moveSpeed,
      [Direction direction = Direction.down])
      : super(xPosition, yPosition, width, length, moveSpeed, direction) {
    _damage = 1;
  }

  ///
  /// Ändert den [_damage] den ein [Ball] einem [Brick] zufügt
  ///
  void changeDamage(int damage) {
    _damage = damage;
  }



  int get damage => _damage;

  ///
  /// Ändert die geschwindigkeit die der [Ball] pro zeiteinheit zurück legt
  ///
  void changeSpeed(int speed) {
    super.moveSpeed = speed;
  }

  ///
  /// Wird nur von Objekten aufgerufen die bei ihrer eigenen bewegung mit dem [Ball kolidieren
  ///
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if (collisionObject is Player) {
      _getCollsionWithPlayer(collisionObject);
    } else if (collisionObject == null) {
      if (direction == Direction.up) {
        direction = Direction.down;
      } else if (direction == Direction.leftUp) {
        if (xPosition == 0) direction = Direction.rightUp;
        if (yPosition == 0) direction = Direction.leftDown;
      } else if (direction == Direction.rightUp) {
        if (xPosition == gameField.length - 1) direction = Direction.leftUp;
        if (yPosition == 0) direction = Direction.rightDown;
      } else if (direction == Direction.leftDown) {
        direction = Direction.rightDown;
      } else if (direction == Direction.rightDown) {
        direction = Direction.leftDown;
      }
    } else
      direction = collisionObject.getCollison(this);
  }

  ///
  /// Wird nur von [move] und [collision] angesprochen
  ///
  /// Ändert die richtung in die der Ball fliegt
  /// [collisionObject] anhand dieses Objektes wird entschieden wie sich der [Ball] nach der kollision verhält
  ///
  ///
  void _changeDirection(Direction direction, GameObject collisionObject,
      List<List<GameObject>> gameField, Map<String, int> step) {
    collision(gameField, collisionObject);
  }

  void _getCollsionWithPlayer(MoveableObject object) {
    int playerPieces = (object.width / 3).round();
    int playerMiddle = (object.xPosition * this.width + 1);
    int ballPosition = this.xPosition * this.width;
    if (ballPosition >= playerMiddle &&
        ballPosition <= playerMiddle + playerPieces) {
      direction = Direction.up;
    } else if (ballPosition >= playerMiddle - playerPieces &&
        ballPosition <= playerMiddle) {
      direction = Direction.leftUp;
    } else direction = Direction.rightUp;
  }

  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    if (yPosition == gameField[0].length - 1) {
      gameField[xPosition][yPosition] =
      new Field.second(xPosition,yPosition);
      destroyed=true;
      controller.updateView(gameField);
    }
    Map coordinates = getValuesForDirection(direction);


    Map response = collisionAhead(
        direction, gameField, coordinates["Y"], coordinates["X"]);
    //Kollison voraus ? wenn nicht einfach bewegen ansonsten werden die entsprechenden Schritte eingeleitet z.B. Kollision des Objekts aufgerufen
    if (!response.keys.first) {
      switchObjects(gameField, this, response.values.first);
      controller.updateView(gameField);
    } else {
      _changeDirection(direction, response[true], gameField, coordinates);
      if (response[true] != null) {
        response[true].collision(gameField, this);
        if(response[true] is Brick){
          Brick brickBuffer = response[true];
          controller.game.increasePoints(brickBuffer.health);
        }

      }

      move(direction, gameField, controller);
    }
  }



  String toString() {
    return "ball";
  }


}
