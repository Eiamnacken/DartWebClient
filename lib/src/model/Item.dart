
import 'package:DartWeb/src/model/Model.dart';
import 'dart:async';
import 'package:DartWeb/src/controller/GameController.dart';
///
/// Um welche länge wird der [Player] verkleinert wenn er ein [Item] einsammelt
/// welches die länge beeinflusst
///
const int changePLayerLength = 10;

const active = const Duration(seconds: 5);
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
  ///
  /// Gibt an ob dieses Item erstellt wurde so das es sich bewegen kann
  ///
  bool _released=false;
  ///
  /// Wie lange ist ein Item aktiv
  ///
  Timer _activeItem;
  Item(int xPosition, int yPosition, int width, int length, int moveSpeed,
      Direction direction)
      : super(xPosition, yPosition, width, length, moveSpeed, direction);



  ///
  /// Gibt an ob es ein Positiv Effekt ist
  ///
  bool isPositive() {
    return _isPositive;
  }
  ///
  /// Item darf sich bewegen
  ///
  /// Item darf sich bewegen da der [Brick] in dem dieses Item saß nun zerstört
  /// wurde.
  ///
  void release(){
    _released=true;
  }

  bool get released => _released;

  ///
  /// Wendet die eigenschaften dieses Items auf den Player an
  ///
  void activateItem(Player player) {
    switch (effect) {
      case Effect.damageBall:
        {}
        break;
      case Effect.longerPLayer:
        {
          player.changeLength(changePLayerLength);
          _activeItem = new Timer(active, (){
          _deactivateItem(player);
          });
        }
        break;
      case Effect.secondBall:
        {}
        break;
      case Effect.invertPlayer:
        {}
        break;
      case Effect.smallerPlayer:
        {
          player.changeLength(-changePLayerLength);
          _activeItem = new Timer(active, (){
            _deactivateItem(player);
          });
        }
        break;
    }
  }

  void _deactivateItem(Player player){
    switch(effect){
      case Effect.longerPLayer:{
        player.changeLength(-changePLayerLength);
      }
        break;
      case Effect.smallerPlayer:{
        player.changeLength(changePLayerLength);
      }break;
      default:
        break;
    }
  }

  @override
  void collision(List<List<GameObject>> gameField, GameObject collisionObject) {
    if (collisionObject is Player) {
      activateItem(collisionObject);
      gameField[xPosition][yPosition] =
          new Field(xPosition, yPosition, width, height);
      destroyed=true;
    }
  }

  @override
  void move(Direction direction, List<List<GameObject>> gameField,
      GameController controller) {
    if(_released) {
      var movement = getValuesForDirection(direction);
      var respond = collisionAhead(direction, gameField, movement["Y"]);
      if (respond.containsKey(true)) {
        if (respond[true] != null) {
          activateItem(respond[true]);
        }
        gameField[xPosition][yPosition] =
        new Field(xPosition, yPosition, width, height);
        gameField[xPosition][yPosition].itemsBuffer.remove(this);
      } else {
        //bewege item nur in den Itembuffern
        gameField[xPosition][yPosition].itemsBuffer.remove(this);
        respond[false].itemsBuffer.add(this);
        yPosition += movement["Y"];
      }
      controller.updateView(gameField);
    }
  }

  @override
  String toString() {
    return '$effect';
  }


}
