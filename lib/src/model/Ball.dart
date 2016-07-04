part of brickGame;
///
/// Objekt das sich von selbst durch den Spielraum bewegt
/// Außerdem fügt es [Brick] schaden zu bei Kontakt
///
class Ball extends MoveableObject {
  ///
  /// Welchen schaden der [Ball] an einem [Brick] zufügt
  ///
  int _damage;

  ///
  /// Ist dieser Ball schon im Soiel ?
  ///
  bool activated=false;

  Ball(int xPosition, int yPosition, int width, int length, int moveSpeed)
      : super(xPosition, yPosition, width, length, moveSpeed, Direction.down) {
    _damage = 1;
  }

  Ball.withDirection(int xPosition, int yPosition, int width, int length, int moveSpeed,Direction direction)
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
    if(collisionObject is Ball){
      collisionObject._direction=getOpposit(collisionObject._direction);
      this._direction=getOpposit(this._direction);
    }
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

  ///
  /// Entscheide in welche Richtung der [Ball] fliegen soll wenn er den Spieler trifft
  /// Einfachhalber wird nur dadurch entschieden auf welche seite des Spielers der Ball trifft
  /// linke seite links hoch fliegen,rechte seite rechts hoch fliegen
  /// Mitte bleibt die Mitte
  ///
  void _getCollsionWithPlayer(Player object) {
    //Da wir den Spieler in 3 teile aufteilen links,rechts,mitte
    int playerPieces = (object.width / 3).round();
    //Die Spieler mitte ist seine momentane Position plus seine breite +1 wegen rundungsfehlern
    int playerMiddle = ((object.xPosition * this.width) + 1);
    //Größe des Balles
    int ballPosition = this.xPosition * this.width;
    if (ballPosition >= playerMiddle &&
        ballPosition <= playerMiddle + playerPieces) {
      direction = Direction.up;
    } else if ((ballPosition >= playerMiddle - playerPieces &&
        ballPosition < playerMiddle)|| ballPosition == playerMiddle-playerPieces) {
      direction = Direction.leftUp;
    } else direction = Direction.rightUp;
  }

  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    //Ball im aus tausche gegen feld so das sich der Spieler weiter bewegen kann
    if (yPosition == gameField[0].length - 1) {
      gameField[xPosition][yPosition] =
      new Field.second(xPosition,yPosition);
      destroyed=true;
      controller.updateView(gameField);
      return;
    }
    Map coordinates = getValuesForDirection(direction);


    Map response = collisionAhead(
        direction, gameField, coordinates["Y"], coordinates["X"]);
    //Kollison voraus ? wenn nicht einfach bewegen ansonsten werden die entsprechenden Schritte eingeleitet z.B. Kollision des Objekts aufgerufen
    if (!response.keys.first) {
      switchObjects(gameField, this, response.values.first);
      controller.updateView(gameField);
      return;
    } else {
      _changeDirection(direction, response[true], gameField, coordinates);
      if (response[true] != null) {
        response[true].collision(gameField, this);
        if(response[true] is Brick){
          controller.game.increasePoints(response[true].health);
          return;
        }

      }
      //Weiter mit der neuen richtung des Objektes die geändert wurde
      move(this.direction, gameField, controller);
    }
  }



  String toString() {
    return "ball";
  }


}
