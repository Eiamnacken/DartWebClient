part of brickGame;

///
/// Sind kleine rechtecke die auf dem Spielfeld platziert werden
/// Es ist Ziel des Spieles diese zu zerstören
///
class Brick extends GameObject {




  ///
  /// Das [Item] das dieser brick entahlten kann
  ///
  Item _item;


  ///
  /// Leben eines [Brick]
  ///
  Health health;

  Brick(int xPosition, int yPosition, int width, int height, String health)
      : super(xPosition, yPosition, width, height) {
    this.health = generateHealth(health);
  }

  ///
  /// Verringert die [health] um eine Stufe
  /// Wenn der [Brick] vorher auf [red] stand wird ein `false` zurück gegeben
  /// ansonsten `true`
  ///
  void decHealth(int damage, List<List<GameObject>> gameField) {
    health = getHealth(damage, health);
    if (health == Health.grey) {
      destroy(gameField);
    }

  }

  ///
  /// Zerstört diesen [Brick] und prüft ob es ein [Item] enthält
  ///
  /// Wenn dieser [Brick] ein Item enthält, wird dieses an dieser stelle erzeugt
  ///
  void destroy(List<List<GameObject>> gameField) {
    if(_item!=null){
      gameField[xPosition][yPosition]=new Field.second(xPosition,yPosition);
      gameField[xPosition][yPosition].itemsBuffer.add(_item);
      _item.release();
    }else gameField[xPosition][yPosition]= new Field.second(xPosition,yPosition);

  }



  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if (collisionObject is Ball) {

      decHealth(collisionObject.damage, gameField);
    } else
      return;
  }

  String toString() {
    String buffer="";
    switch(health){
      case Health.brown:
        buffer="brownBrick";
        break;
      case Health.green:
        buffer="greenBrick";
        break;
      case Health.grey:
        buffer="greyBrick";
        break;
      case Health.red:
        buffer="redBrick";
        break;
      case Health.yellow:
        buffer="yellowBrick";
        break;
    }
    return buffer;
  }


}