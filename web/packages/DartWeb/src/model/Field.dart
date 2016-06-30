part of brickGame;







class Field extends GameObject{
  Field(int xPosition, int yPosition, int width, int height) : super(xPosition, yPosition, width, height);

  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    return;
  }

  String toString() {
    return "field";
  }


}