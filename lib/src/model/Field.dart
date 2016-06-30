part of brickGame;


class Field extends GameObject{

  ///Wird beim ersten erzeugen eines Feldes gesetzt mit seinem eigenen Element
  ///
  /// Dient um das erzeugen leerer Felder zu vereinfachen es werden daruch Felder
  /// generiert die immer die gleiche [width] und [height] haben
  ///
  ///
  static int _widthField;
  static int _heightField;

  Field(int xPosition, int yPosition, int width, int height):super(xPosition,yPosition,width,height){
    _widthField=width;
    _heightField=height;
  }

  Field.second(int xPosition,int yPosition) : super(xPosition, yPosition, _widthField, _heightField);


  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    return;
  }

  String toString() {
    return "field";
  }


}