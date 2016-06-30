part of brickGame;

///
/// [Item] sind die Positiven oder Negativen effekte die der Player im laufe des
/// Spieles einsammeln kann
///
class Item extends MoveableObject {
  ///
  /// Handelt es sich um ein Negativ[Effect] oder Positiv[Effect]
  ///
  bool _isPositive;

  ///
  /// Um welche art von [Item] handelt es sich
  ///
  Effect effect;

  Item(int xPosition, int yPosition, int width, int length, int moveSpeed)
      : super(xPosition, yPosition, width, length, moveSpeed);

  ///
  /// Gibt an ob es ein Positiv Effekt ist
  ///
  bool isPositive() {
    //TODO: Implement Method
  }

  @override
  void collision(Direction direction, List<List<GameObject>> gameField) {
    // TODO: implement collision
  }

  ///
  /// Wendet die eigenschaften dieses Items auf den Player an
  ///
  void _activateItem(Player player) {
    //TODO: Implement Method
  }



  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    // TODO: implement move
  }
}
