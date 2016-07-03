part of brickGame;

abstract class GameObject {
  ///
  /// X position des [MoveableObject] auf dem Spielfeld
  /// Zeigt immer den Mittelpunkt des [MoveableObject] an
  ///
  int xPosition;

  ///
  /// Y position des [MoveableObject] auf dem Spielfeld
  /// Zeigt immer den Mittelpunkt des [MoveableObject] an
  ///
  int yPosition;

  ///
  /// Die Breite des [MoveableObject]
  ///
  int width;

  ///
  /// Die Länge des [MoveableObject]
  ///
  int height;

  ///
  /// Itembuffer enthält die momentanen [Item] die sich auf diesem Feld befinden
  ///
  List<Item> itemsBuffer;

  GameObject(this.xPosition, this.yPosition, this.width, this.height) {
    itemsBuffer = new List();
  }

  ///
  /// Wird aufgerufen wenn eine Kollision mit diesem Objekt entsteht
  ///
  void collision(List<List<GameObject>> gameField, GameObject collisionObject);

  Direction getCollison(MoveableObject object) {
    int differenceX = xPosition - object.xPosition;
    int differenceY = yPosition - object.yPosition;
    Direction buffer;
    if (differenceX == 0 && differenceY <= 0) {
      buffer = Direction.down;
    } else if (differenceX >= 0 && differenceY == 0) {
      if (object._direction == Direction.leftUp) {
        buffer = Direction.rightUp;
      } else if (object._direction == Direction.rightUp) {
        buffer = Direction.leftUp;
      } else if (object._direction == Direction.leftDown) {
        buffer = Direction.rightDown;
      } else if (object._direction == Direction.rightDown) {
        buffer = Direction.leftDown;
      }
    } else if (differenceX == 0 && differenceY >= 0) {
      buffer = Direction.up;
    }
    return buffer;
  }

}

///
/// Objekte die sich im [Level] bewegen können
///
abstract class MoveableObject extends GameObject {
  ///
  /// Wie viel abstand legt ein [MoveableObject] pro zeiteinheit/tastendruck zurück
  ///
  int _moveSpeed;

  int get moveSpeed => _moveSpeed;

  ///
  ///
  ///
  Direction _direction;

  Direction get direction => _direction;

  MoveableObject(int xPosition, int yPosition, int width, int length,
      this._moveSpeed, this._direction)
      : super(xPosition, yPosition, width, length);

  ///
  /// Bewegt ein [MoveableObject] in eine Richtung
  /// [direction] gibt an in welche richtung sich das Objekt bewegt
  /// [gameField] gibt die nötigen Informationen für die [collision]
  ///
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller);

  ///
  /// Gibt an ob beim nächsten Schritt in diese Richtung eine kollision stattfinden wird
  ///
  /// Wenn der [Player] auf den [Ball] trifft gibt es einen `{false:Ball}` zurück
  /// Ist das ende des Levels erreicht gibt es ein `{true:null}` zurück
  ///
  ///
  Map<bool, GameObject> collisionAhead(Direction direction,
      List<List<GameObject>> gameField,
      [int y = 0, int x = 0]) {
    GameObject buffer;

    int xVert=0;
    int yVert=0;
    var response;
    //Auch quer schauen ob es kolisionen gibt
    if(direction==Direction.rightDown){
      response = getValuesForDirection(Direction.right);
    }else if(direction==Direction.leftDown){
      response=getValuesForDirection(Direction.left);
    }else if(direction==Direction.leftUp){
      response=getValuesForDirection(Direction.left);
    }else if(direction==Direction.rightUp){
      response=getValuesForDirection(Direction.right);
    }
    if(response!=null){
      xVert=response["X"];
      yVert=response["Y"];
      if(!_isOutofMap(yVert,xVert,gameField)){
        buffer=gameField[xPosition+xVert][yPosition+yVert];
        if(buffer is Field){
          buffer = null;
        }
      }
    }


    //Spielgrenze erreicht
    if (!_isOutofMap(y,x,gameField)) {

      try{
        buffer = buffer==null?gameField[xPosition + x][yPosition + y]:buffer;
      }catch(e){
        print(e);
      }


      //Aif dem weg zum player ?
      if (buffer is Field && (_direction == Direction.down|| _direction==Direction.rightDown||_direction==Direction.leftDown)) {
        if (buffer.yPosition == gameField[0].length - 1) {
          int wallDifference = (xPosition+1) * width;
          Player player;
          GameObject bufferPlayer;
          for (int i =  0; i < gameField.length; i++) {
            bufferPlayer = gameField[i][gameField[i].length - 1];
            if (bufferPlayer is Player) {
              player = bufferPlayer;
              break;
            }
          }
          int playerPosition;
          try{
            playerPosition = (((player.xPosition+1) * buffer.width) -
                player.width / 3).round();
          }catch(e){

          }

          if (wallDifference >= playerPosition &&
              wallDifference <= playerPosition + player.width) {
              //Bei item noch kollision von PLayer aufrufen
              buffer = player;
          }
        }
      }
    } else return {true: buffer};


    if (buffer is Field) {
      return {false: buffer};
    }
    if (this is Player && buffer is Ball) {
      return {false: buffer};
    }
    return {true: buffer};
  }

  bool _isOutofMap(int y,int x,List<List<GameObject>> gameField){

    if ((xPosition + x < gameField.length && xPosition + x >= 0) &&
        (yPosition + y < gameField[xPosition].length && yPosition + y >= 0))
      return false;
    else return true;
  }

  ///
  /// Tauscht den platz zwei [GameObject] im [gameField]
  ///
  /// Diese Methode braucht überarbeitung für flüssige bewegungen
  /// [x] momentane Position des Objekts mit dem dieses Objekt die position tauscht
  /// [y] Dito
  ///
  ///
  void switchObjects(List<List<GameObject>> gameField, GameObject object1,
      GameObject object2) {
    if (object1 == null || object2 == null) return;
    final int x = object1.xPosition;
    final int y = object1.yPosition;
    gameField[object1.xPosition][object1.yPosition] = object2;
    gameField[object2.xPosition][object2.yPosition] = object1;
    object1.xPosition = object2.xPosition;
    object1.yPosition = object2.yPosition;
    object2.xPosition = x;
    object2.yPosition = y;
  }


}
