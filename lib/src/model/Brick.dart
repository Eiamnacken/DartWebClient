part of brickGame;

///
/// Sind kleine rechtecke die auf dem Spielfeld platziert werden
/// Es ist Ziel des Spieles diese zu zerstören
///
class Brick extends GameObject {


  ///
  /// The [Item] this brick holds
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
  /// Wenn der [Brick] vorher auf `red` stand wird ein `false` zurück gegeben
  /// ansonsten `true`
  ///
  void decHealth(int damage, List<List<GameObject>> gameField) {
    health = getHealth(damage, health);
    if (health == Health.grey) {
      gameField[xPosition][yPosition] = new Field(xPosition,yPosition,width,height);
    }

  }

  ///
  /// Zerstört diesen [Brick] und prüft ob es ein [Item] enthält
  /// Gibt ein [Item] zurück wenn es eines enthält ansonsten null
  ///
  Item destroy() {
    return _release();
  }

  ///
  /// Legt ein neues [Item] an und gibt diese zurück
  ///
  Item _release() {
    return null;
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
    //Handelt es sich um ein item special farbe ausgeben
    if(_item!=null){
      return "item";
    }
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
